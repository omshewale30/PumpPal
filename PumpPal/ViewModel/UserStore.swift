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
  
        loggedInUser = UserEntity(context: context)
        loggedInUser?.username = username
        loggedInUser?.password = password
        loggedInUser?.foodHistory = NSSet()
    }
    
    func logout() {
            // Save changes to Core Data
        
            

            // Reset the current user session
            
    }
}
