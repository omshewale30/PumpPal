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
    @StateObject var timeVM=TimeViewModel()
    let gradient = LinearGradient(gradient: Gradient(colors: [Color(hex:"#eecda3 "),Color(hex:"#ef629f")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    

    
    @EnvironmentObject var userStore: UserStore

   
    @State private var startDate: Date = .now
    @State private var endDate: Date = .now
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                Text("Meal Summary")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                Picker("Select Date Filter", selection: $timeVM.selectedFilter) {
                    Text("Past Week").tag(TimeViewModel.DateFilter.pastWeek)
                    Text("Last Month").tag(TimeViewModel.DateFilter.lastMonth)
                    Text("All Time").tag(TimeViewModel.DateFilter.allTime)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button("Show data", action: {
                    timeVM.applyFilter()
                    startDate = timeVM.formatToDayMonth(timeVM.startDate)
                    endDate = timeVM.formatToDayMonth(timeVM.endDate)
                    print("Start date is \(startDate) and end date is \(endDate)")
                    
                    print("This is the size of fetched foodentites \(coreVM.fetchedFoodForTimePeriod.count)")
                    coreVM.fetchFoodHistoryEntityForTimePeriod(forUser: userStore.loggedInUser ?? .init(), fromDate: startDate, toDate: endDate)
                })
                .padding()
                .buttonStyle(CustomButtonStyle1(buttonColor: Color(hex:"#ef629f") ))
                List{   
                    ForEach(coreVM.fetchedFoodHistory) { foodHistoryEntity in
                        NavigationLink(destination: DetailView(date: foodHistoryEntity.date ?? .now)) {
                            VStack(alignment: .leading, spacing: 8) {
                                if let fhDate = foodHistoryEntity.date {
                                    Text("Date: \(fhDate.formattedString())")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(12)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        let foodHistoryEntitiesToDelete = indexSet.map { coreVM.fetchedFoodHistory[$0] }
                        for foodHE in foodHistoryEntitiesToDelete {
                            coreVM.deleteFoodHistoryEntity(foodHistoryEntity: foodHE)
                        }
                        coreVM.fetchFoodHistoryEntityForTimePeriod(forUser: userStore.loggedInUser ?? .init(), fromDate: startDate, toDate: endDate)
                    })
                }

            }
            .padding()
        }
    }
}
    


struct ViewHistory_Previews: PreviewProvider {
    static var previews: some View {
        ViewHistory()
    }
}
