//
//  MealEntry.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI
import CoreData

struct MealEntry: View {
    @State private var foodItem = ""
    @StateObject var coreVM=CoreDataViewModel()
    @State private var date:Date = .now
    @EnvironmentObject var userStore: UserStore
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserEntity.username, ascending: true)],
        animation: .default)
    
    private var Users: FetchedResults<UserEntity>
    var body: some View {
        
        
        VStack {
            TextField("Enter Food Item", text: $foodItem)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            DatePicker("Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()


            Button(action: {
                makeAPICall(query: foodItem){ foodResponse in
                    if let foodResponse = foodResponse{       
                        saveFood(foodResponse: foodResponse, forUser: userStore.loggedInUser!, forDate: formatToDayMonth(date))
                    }
                    else{
                        print("No response")
                    }
                }
                
            }) {
                Text("Enter Meal")
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(CustomButtonStyle1(buttonColor: .gray))
            .padding()
            Spacer()
        }
        .padding()
    }
    
    

    func formatToDayMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Format the date to a string
        let formattedDateString = dateFormatter.string(from: date)
        
        return formattedDateString
    }




    
    
    private func saveFood(foodResponse: FoodResponse, forUser user: UserEntity, forDate date: String) {
        
        let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "username == %@", argumentArray: [user.username])

        do {
            let currentUser = try viewContext.fetch(userFetchRequest)
            if let cur_user = currentUser.first {
                
                do{
                    print("Found user: \(user.username ?? "Unknown username")")
                    let foodHistoryFetchRequest: NSFetchRequest<FoodHistoryEntity> = FoodHistoryEntity.fetchRequest()
                    foodHistoryFetchRequest.predicate=NSPredicate(format: "date == %@ AND user == %@", argumentArray: [date,cur_user])
                    let existingFoodHistoryEntities = try viewContext.fetch(foodHistoryFetchRequest)
                    
                    if let foodHistoryEntity = existingFoodHistoryEntities.first{
                   
                        associateFoodItems(with: foodResponse.foods,to:foodHistoryEntity)
                    }else{
                        let newFoodHistoryEntity = FoodHistoryEntity(context: viewContext)
                        newFoodHistoryEntity.date = date
                        newFoodHistoryEntity.user = cur_user
                        cur_user.addToFoodHistory(newFoodHistoryEntity)
                        associateFoodItems(with: foodResponse.foods, to: newFoodHistoryEntity)
                    }
                    try viewContext.save()
                    
                    print("Saved the foodHistory for date \(date)")
                }
                catch{
                    print("Error saving FoodHistoryEntity: \(error)")
                }
                
            } else {
                print("User not found")
            }
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    



    func associateFoodItems(with foodItems:[FoodItem], to foodHistoryEntity:FoodHistoryEntity) {
        for foodItem in foodItems{
            let newFoodItemEntity=FoodItemEntity(context: viewContext)
            newFoodItemEntity.foodName=foodItem.foodName
            newFoodItemEntity.calories=String(foodItem.calories)
            newFoodItemEntity.carbohydrates=foodItem.carbohydrates
            newFoodItemEntity.protein=foodItem.protein
            newFoodItemEntity.totalFat=foodItem.totalFat
            foodHistoryEntity.addToFoodItem(newFoodItemEntity)
        }
    }

    
    private func makeAPICall(query:String,completion: @escaping (FoodResponse?) -> Void) {
        // API endpoint URL
        
        let apiUrl = URL(string: "https://trackapi.nutritionix.com/v2/natural/nutrients")!
        print("In API call")
        // Request body data
        let requestBody: [String: Any] = [
            "query": query,
            "timezone": "US/Eastern"
        ]

        // Convert the request body to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)

        // Create the request object
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("25f485ae", forHTTPHeaderField: "x-app-id")
        request.setValue("d5eec014d43490ecb93beaef4a716ae2", forHTTPHeaderField: "x-app-key")

        // Create a URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let foodResponse = try decoder.decode(FoodResponse.self, from: data)
                    for food in foodResponse.foods{
                        print(food)
                    }
                    completion(foodResponse)
        

                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
                print(data)
            }
        }
        // Resume the task to initiate the request
        task.resume()
        
    }
}

struct MealEntry_Previews: PreviewProvider {
    static var previews: some View {
        MealEntry()
    }
}
