//
//  FoodItem.swift
//  PumpPal
//
//  Created by Om Shewale on 10/22/23.
//

import Foundation

struct User{
    var username:String
    var password:String
    var foodConsumption: [Date: [FoodResponse]]
}



struct FoodResponse: Decodable {
    var foods: [FoodItem]
}

struct FoodItem: Decodable {
    var foodName: String
    var calories: Double
    var totalFat: Double
    var carbohydrates: Double
    var protein: Double

    enum CodingKeys: String, CodingKey {
        case foodName = "food_name"
        case calories = "nf_calories"
        case totalFat = "nf_total_fat"
        case carbohydrates = "nf_total_carbohydrate"
        case protein = "nf_protein"
    }
}
