//
//  PumpPalApp.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI



@main
struct PumpPalApp: App {
    let userStore=UserStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userStore)
        }
    }
}
