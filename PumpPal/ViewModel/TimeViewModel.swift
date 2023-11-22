//
//  TimeViewModel.swift
//  PumpPal
//
//  Created by Om Shewale on 11/20/23.
//

import Foundation
import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }
}

class TimeViewModel : ObservableObject{
    
    @Published var selectedFilter: DateFilter = .pastWeek
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    static func getGreeting() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())

        switch hour {
        case 0..<12:
            return "Good morning!"
        case 12..<17:
            return "Good afternoon!"
        case 17..<21:
            return "Good evening!"
        default:
            return "Good night!"
        }
    }

    
    func formatToDayMonth(_ date: Date) -> Date {
        // Extract the day, month, and year components from the date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)

        // Create a new date using the extracted components
        if let formattedDate = calendar.date(from: components) {
            return formattedDate
        } else {
            print("Date conversion failed")
            return date
        }
    }

    static func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        return formatter.string(from: Date())
    }

    static func getCurrentDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }

    static func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }

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
    func applyFilter() {
        let dateRange = selectedFilter.getDateRange()
        startDate = dateRange.startDate
        endDate = dateRange.endDate
    }
}
