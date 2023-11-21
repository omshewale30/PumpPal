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
    @State private var isShowingList = false
    
    
    var body: some View {
        ZStack{
            gradient.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Text("Meal Summary")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 20)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                    
                    Button("Show data", action: {
                        coreVM.getFood(forUser: userStore.loggedInUser!, forDate: formatToDayMonth(date))
                        isShowingList=true
                        
                    })
                    .buttonStyle(CustomButtonStyle1(buttonColor: Color(hex:"#ef629f") ))
                    
                    List(coreVM.fetchedFood, id: \.self) { foodItem in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name: \(foodItem.foodName ?? "")")
                                .font(.headline)
                            Text("Carbohydrates: \(foodItem.carbohydrates)")
                                .font(.subheadline)
                            Text("Fats: \(foodItem.totalFat)")
                                .font(.subheadline)
                            Text("Protein: \(foodItem.protein)")
                                .font(.subheadline)
                        }
                        .padding(12)
                        .background(gradientEntry.edgesIgnoringSafeArea(.all))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 2))
                        .padding([.top, .horizontal])
                    }
                }
                .padding()
                .edgesIgnoringSafeArea(.all)
        }
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
