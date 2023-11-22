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
    
    var date:Date
    var body: some View {
        
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
            .cornerRadius(20)
            .shadow(radius: 10)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 2))
            .padding([.top, .horizontal])
        }
        .onAppear{
            coreVM.getFoodForDate(forUser: userStore.loggedInUser!, forDate: date)
        }
    }
}

#Preview {
    DetailView(date: .init())
}
