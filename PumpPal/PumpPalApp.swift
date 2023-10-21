//
//  PumpPalApp.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI

@main
struct PumpPalApp: App {
    let persistenceController = PersistenceController.shared
    let userStore=UserStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userStore)
        }
    }
}
