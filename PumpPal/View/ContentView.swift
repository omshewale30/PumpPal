//
//  ContentView.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI

import CoreData

struct ContentView: View {
        var body: some View {
            NavigationStack{
                VStack(spacing: 20) {
                    NavigationLink("Sign Up", destination: SignUpView())
                    NavigationLink("Login", destination: LoginView())
                }
            }
        }

    }

    
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
