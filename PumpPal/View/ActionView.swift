//
//  ActionView.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI

struct ActionView: View {
    @EnvironmentObject var userStore: UserStore
    var body: some View {
            VStack(spacing: 20) {
                Spacer()
                NavigationLink(destination: MealEntry()){
                    Text("Log my meal")
                }
                .buttonStyle(CustomButtonStyle1())
                
                NavigationLink(destination: ViewHistory()) {
                    Text("View History")
                }
                .buttonStyle(CustomButtonStyle1())
                
                
                NavigationLink(destination: LocationView()) {
                    Text("Where did I eat my meals?")
                }
                .buttonStyle(CustomButtonStyle1())
                
                Button("Logout", action: {
                    userStore.logout()
                })
                .buttonStyle(CustomButtonStyle1())
                
                Spacer()
            }
            .navigationTitle("Activity Tracker")
            .padding()
        }
    
}

struct CustomButtonStyle1: ButtonStyle {
   var buttonColor: Color = Color.red
   var textColor: Color = Color.white
   var shadowColor: Color = Color.gray.opacity(0.5)
   var cornerRadius: CGFloat = 10

   func makeBody(configuration: Configuration) -> some View {
       configuration.label
           .frame(maxWidth: 200)
           .padding()
           .foregroundColor(textColor)
           .background(buttonColor)
           .cornerRadius(cornerRadius)
           .shadow(color: configuration.isPressed ? shadowColor : Color.clear, radius: 10, x: 0, y: 4)
           .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
   }
}
struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
    }
}
