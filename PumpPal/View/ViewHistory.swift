//
//  ViewHistory.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI
import CoreData



enum DateFilter {
    case pastWeek
    case lastMonth
    case allTime

    func getDateRange() -> (startDate: Date, endDate: Date) {
        let calendar = Calendar.current
        let currentDate = Date()

        switch self {
        case .pastWeek:
            let startDate = calendar.date(byAdding: .day, value: -7, to: currentDate) ?? currentDate
            return (startDate, currentDate)
        case .lastMonth:
            let startDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
            return (startDate, currentDate)
        case .allTime:
    
            let startDate = calendar.date(byAdding: .year, value: -1, to: currentDate) ?? currentDate // specify a start date for all time
            return (startDate, currentDate)
        }
    }
}

struct ViewHistory: View {
    @StateObject var coreVM=CoreDataViewModel()
    @StateObject var timeVM=TimeViewModel()
    let gradient = LinearGradient(gradient: Gradient(colors: [Color(hex:"#eecda3 "),Color(hex:"#ef629f")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    let gradientEntry = LinearGradient(gradient: Gradient(colors: [Color(hex:"#ff9966"),Color(hex:" #ff5e62")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    
    @EnvironmentObject var userStore: UserStore


    @State private var selectedTimeFrame: DateFilter = .allTime
    
    @State private var foodHistoryEntities : [FoodHistoryEntity] = .init()
   
    @State private var startDate: Date = .now
    @State private var endDate: Date = .now
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                Text("Meal Summary")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                Picker("Select Date Filter", selection: $selectedTimeFrame) {
                    Text("Past Week").tag(DateFilter.pastWeek)
                    Text("Last Month").tag(DateFilter.lastMonth)
                    Text("All Time").tag(DateFilter.allTime)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button("Show data", action: {
                    let dateRange = selectedTimeFrame.getDateRange()
                    startDate = timeVM.formatToDayMonth(dateRange.startDate)
                    endDate = timeVM.formatToDayMonth(dateRange.endDate)
                    print("Start date is \(startDate) and end date is \(endDate)")
                    
                    print("This is the size of fetched foodentites \(coreVM.fetchedFoodForTimePeriod.count)")
                    foodHistoryEntities=coreVM.fetchFoodHistoryEntityForTimePeriod(forUser: userStore.loggedInUser ?? .init(), fromDate: startDate, toDate: endDate)
                })
                .buttonStyle(CustomButtonStyle1(buttonColor: Color(hex:"#ef629f") ))
                List{   
                    ForEach(foodHistoryEntities) { foodHistoryEntity in
                        NavigationLink("", destination: DetailView(date: foodHistoryEntity.date ?? .now))
                        VStack(alignment: .leading, spacing: 8) {
                            if let fhDate=foodHistoryEntity.date{
                                Text("Date is \(fhDate)")
                                    .font(.headline)
                            }
                        }
                        .padding(12)
                        .background(gradientEntry.edgesIgnoringSafeArea(.all))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 2))
                        .padding([.top, .horizontal])
                    }
                    .onDelete(perform: { indexSet in
                        //TODO: implement delete
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
