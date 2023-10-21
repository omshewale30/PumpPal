//
//  ViewHistory.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI
import CoreData

struct ViewHistory: View {
    @StateObject var coreVM=CoreDataViewModel()
    let gradient = LinearGradient(gradient: Gradient(colors: [Color(hex:"#eecda3 "),Color(hex:"#ef629f")]), startPoint: .topLeading, endPoint: .bottomTrailing)

    let gradientEntry = LinearGradient(gradient: Gradient(colors: [Color(hex:"#ff9966"),Color(hex:" #ff5e62")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    

    @EnvironmentObject var userStore: UserStore
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var date:Date = .now
    @State private var fetchedFood:[FoodItemEntity]=[]
    
    
    var body: some View {
        gradient.edgesIgnoringSafeArea(.all)
            .overlay(
                    ScrollView{
                        VStack(alignment: .leading) {
                                  Text("Meal Summary")
                                      .font(.largeTitle)
                                      .bold()
                                      .padding(.bottom, 20)
                            DatePicker("Date", selection: $date, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding()
                            
                            Button("Show data", action: {
                                getFood(forUser: userStore.loggedInUser!, forDate: formatToDayMonth(date))
                            })


                            ForEach(Array(fetchedFood), id: \.self) { foodItem in
                                VStack(alignment: .center) {
                                    if let foodName = foodItem.foodName {
                                        Text("Name \(foodName)")
                                            .font(.headline)
                                    }
                                          Text("Carbohydrate \(foodItem.carbohydrates)")
                                              .font(.headline)
                                          Text("Fats \(foodItem.totalFat)")
                                              .font(.headline)
                                          Text("Protein \(foodItem.protein)")
                                              .font(.headline)
                                      }
                                      .background(gradientEntry.edgesIgnoringSafeArea(.all))
                                      .padding(20)
                                      .cornerRadius(80)
                                      .cornerRadius(20) // Apply corner radius
                                      .shadow(radius: 10) // Add shadow for depth
                                      .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 2)) // Add white border
                                      .padding() // Add extra padding for the border
                                  }
                              }
                              .padding()
                              .edgesIgnoringSafeArea(.all)
                    }
        )
    }
    
    func getFood(forUser user: UserEntity, forDate date: String) -> [FoodItemEntity] {
        let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "username == %@", argumentArray: [user.username])
        
        do {
            let currentUser = try viewContext.fetch(userFetchRequest)
            if let cur_user = currentUser.first {
                print(" \(String(describing: cur_user.username)) foodHistory has these many foodhistory entities \(String(describing: cur_user.foodHistory?.count))")
                if let foodHistorySet=cur_user.foodHistory as? Set<FoodHistoryEntity>{
                    let filteredFoodHistory=foodHistorySet.filter{$0.date == date}
                    print("Size of foodItemHistory for date \(date) is \(filteredFoodHistory.count)")
                    return filteredFoodHistory.flatMap{$0.foodItem?.allObjects as? [FoodItemEntity] ?? []}
                }
            }
        } catch{
            print("user not found")
        }
        return []
    }
        

    func formatToDayMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Format the date to a string
        let formattedDateString = dateFormatter.string(from: date)
        
        return formattedDateString
    }
}


struct ViewHistory_Previews: PreviewProvider {
    static var previews: some View {
        ViewHistory()
    }
}
