//
//  UserStore.swift
//  PumpPal
//
//  Created by Om Shewale on 11/15/23.
//

import Foundation
import SwiftUI
import CoreData

class UserStore: ObservableObject {
    @Published var loggedInUser: UserEntity?

    func loginUser(username: String, password: String, context: NSManagedObjectContext) {
           // Fetch the user with the provided username and password
           let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

           do {
               let users = try context.fetch(fetchRequest)
               if let user = users.first {
                   // User found, set it as the loggedInUser
                   loggedInUser = user
               } else {
                   // User not found, you might want to handle this case (show an error, etc.)
                   print("User not found")
               }
           } catch {
               print("Error fetching user: \(error.localizedDescription)")
           }
       }

       func logout() {
           // You might want to perform some cleanup or handle the logout logic here
           loggedInUser = nil
       }
}
