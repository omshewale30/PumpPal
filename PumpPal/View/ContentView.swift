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
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                    VStack(spacing: 20) {
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                            
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .frame(width: 200, height: 50)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                                    .padding(.bottom, 20)
                            }
                            NavigationLink(destination: LoginView()) {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .frame(width: 200, height: 50)
                                    .background(Color.green)
                                    .cornerRadius(25)
                            }
                            Spacer()
                        }
                        .padding()
                    .navigationBarHidden(true)  
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
