//
//  DetailView.swift
//  PumpPal
//
//  Created by Om Shewale on 11/21/23.
//

import SwiftUI

struct DetailView: View {
    @StateObject var coreVM = CoreDataViewModel()
    @EnvironmentObject var userStore: UserStore
    let gradientEntry = LinearGradient(gradient: Gradient(colors: [Color(hex:"#ff9966"),Color(hex:" #ff5e62")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var date:Date
    var body: some View {
        List{
            
            ForEach(coreVM.fetchedFood, id: \.self) { foodItem in
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
            .onDelete(perform: { indexSet in
                let foodItemsToDelete = indexSet.map { coreVM.fetchedFood[$0] } 
                for foodItem in foodItemsToDelete {
                    coreVM.deleteFoodItem(foodItem: foodItem)
                }
      
                coreVM.getFoodForDate(forUser: userStore.loggedInUser!, forDate: date)
            })
        }
        .onAppear{
            coreVM.getFoodForDate(forUser: userStore.loggedInUser!, forDate: date)
        }
    }
}

#Preview {
    DetailView(date: .init())
}
