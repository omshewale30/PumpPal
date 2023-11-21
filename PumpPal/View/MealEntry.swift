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
    @State var isDiffLocation : Bool = false
    @State private var addressString=""
    @State var locationVM=LocationViewModel()
    @State var apiService=APIService()
    
    @State private var foodResponse: FoodResponse = .init(foods: .init())
    
    @State private var showAlert = false

    var body: some View {
          
        VStack {
            Spacer()
            TextField("Enter Food Item", text: $foodItem)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            DatePicker("Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
            
            VStack{
                Text("Where did you eat the meal")
                    .padding()
                Button("Current Location", action: {
                    locationVM.getUserLocation()
                    
                })
                .padding()
                Button("Different Location", action: {
                    isDiffLocation=true
                    })
                .padding()
                .popover(isPresented: $isDiffLocation, content: {
                    VStack {
                        Text("Enter Location")
                            .font(.headline)
                            .padding()

                        TextField("Enter Address", text: $addressString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button(action: {
                            locationVM.getCoordinate(addressString: addressString)
                            isDiffLocation = false
                        }) {
                            Text("OK")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
                })

                }

            Button(action: {
                
        
                apiService.makeAPICall(query: foodItem){ result in
                    switch result{
                    case .success(let receivedFoodResponse):
                        self.foodResponse=receivedFoodResponse
                        let userCordinates = locationVM.userLocation?.coordinate
                        let lat=Double(userCordinates?.latitude ?? 0.0)
                        let long=Double(userCordinates?.longitude ?? 0.0)
                        coreVM.saveFood(foodResponse: foodResponse, forUser: userStore.loggedInUser!, forDate: formatToDayMonth(date), atLatitude: lat, atLongitude: long)
                    case .failure(let error):
                        showAlert=true
                        print("Error \(error)")
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Response"),
                message: Text("We could not find the food in our database. Please enter a valid meal."),
                dismissButton: .default(Text("OK"))
            )
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
}

struct MealEntry_Previews: PreviewProvider {
    static var previews: some View {
        MealEntry()
    }
}
