//
//  APIService.swift
//  PumpPal
//
//  Created by Om Shewale on 11/20/23.
//

import Foundation
class APIService{
    func makeAPICall(query:String,completion: @escaping (Result<FoodResponse, Error>)-> Void) {
        // API endpoint URL
        
        let apiUrl = URL(string: "https://trackapi.nutritionix.com/v2/natural/nutrients")!
        print("In API call")
        // Request body data
        let requestBody: [String: Any] = [
            "query": query,
            "timezone": "US/Eastern"
        ]

        // Convert the request body to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)

        // Create the request object
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("25f485ae", forHTTPHeaderField: "x-app-id")
        request.setValue("d5eec014d43490ecb93beaef4a716ae2", forHTTPHeaderField: "x-app-key")

        // Create a URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let foodResponse = try decoder.decode(FoodResponse.self, from: data)
                    for food in foodResponse.foods{
                        print(food)
                    }
                    completion(.success(foodResponse))
        

                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(.failure(error))
                }
                print(data)
            }
        }
        // Resume the task to initiate the request
        task.resume()
        
    }
    
    
}
