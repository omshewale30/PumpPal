//
//  MealEntry.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI
import CoreData

struct MealEntry: View {
    @EnvironmentObject var userStore: UserStore
    @StateObject var coreVM=CoreDataViewModel()
    @State var locationVM=LocationViewModel()
    @State var apiService=APIService()
    @State var timeVM=TimeViewModel()
    
    
    @State private var foodItem = ""
    @State private var date:Date = .now
  
    @State var isDiffLocation : Bool = false
    @State private var addressString=""

    
    
    @State private var foodResponse: FoodResponse = .init(foods: .init())
    
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color(hex: "F5F5F5").ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack{
                    TextField("Enter Food Item", text: $foodItem)
                        .padding()

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .fontWeight(.bold)
                }
                .background(Color(hex: "FFC26F"))
                .cornerRadius(10)
                
                VStack(spacing: 20) {
                    Text("Where did you eat the meal ?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()

                    Button(action: {
                        locationVM.getUserLocation()
                    }) {
                        HStack {
                            Image(systemName: "location.circle.fill")
                                .font(.title)
                            Text("Use Current Location")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth: 200)
                        .background(Color(hex: "4F709C"))
                        .cornerRadius(10)
                    }

                    Button(action: {
                        isDiffLocation = true
                    }) {
                        HStack {
                            Image(systemName: "map.fill")
                                .font(.title)
                            Text("Choose Different Location")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth: 200)
                        .background(.black)
                        .cornerRadius(10)
                    }
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
                .padding()
                Button(action: {
                    apiService.makeAPICall(query: foodItem){ result in
                        switch result{
                        case .success(let receivedFoodResponse):
                            self.foodResponse=receivedFoodResponse
                            let userCordinates = locationVM.userLocation?.coordinate
                            let lat=Double(userCordinates?.latitude ?? 0.0)
                            let long=Double(userCordinates?.longitude ?? 0.0)
                            coreVM.saveFood(foodResponse: foodResponse, forUser: userStore.loggedInUser!, forDate: timeVM.formatToDayMonth(date), atLatitude: lat, atLongitude: long)
                        case .failure(let error):
                            showAlert=true
                            print("Error \(error)")
                        }
                    }
                    
                }) {
                    Text("Enter Meal")
                        .foregroundColor(.white)
                }
                .buttonStyle(CustomButtonStyle1(buttonColor: Color(hex: "3F2305"),cornerRadius: 60))
                .padding()
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 50).fill(Color(hex: "C38154").opacity(0.4)))
            .shadow(radius: 5)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Response"),
                    message: Text("We could not find the food in our database. Please enter a valid meal."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .padding()
        }
    }
}

struct MealEntry_Previews: PreviewProvider {
    static var previews: some View {
        MealEntry()
    }
}
