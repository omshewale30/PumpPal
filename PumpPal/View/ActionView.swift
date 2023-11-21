//
//  ActionView.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI

struct ActionView: View {
    
    
    
    @State private var greeting = GreetingUtility.getGreeting()
    @State private var currentTime = GreetingUtility.getCurrentTime()
    @State private var currentDay = GreetingUtility.getCurrentDay()
    @State private var currentDate = GreetingUtility.getCurrentDate()

   

    @EnvironmentObject var userStore: UserStore
    @State private var logOut=false
    var body: some View {
        NavigationView {
                    VStack(spacing: 20) {
                        Text("PumpPal")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.black) // Adjust the color to match your design
                        Spacer()
                        
                        Text(greeting)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)

                        Text("It's \(currentTime)")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text("Today is \(currentDay), \(currentDate)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        

  
                    }
                    .onAppear {
                        // Update the time every second
                        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            currentTime = GreetingUtility.getCurrentTime()
                        }
                        RunLoop.main.add(timer, forMode: .common)
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            HStack(spacing: 60) {
                                NavigationLink(destination: MealEntry()) {
                                    Label("Log", systemImage: "pencil")
                                        
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: ViewHistory()) {
                                    Label("History", systemImage: "clock")
                                        
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: LocationView()) {
                                    Label("Location", systemImage: "map")
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button {
                                    userStore.logout()
                                    logOut = true
                                } label: {
                                    Label("Logout", systemImage: "arrow.backward.square")
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .background(
                    NavigationLink(
                        destination: LoginView().navigationBarBackButtonHidden(true),
                        isActive: $logOut,
                        label: { EmptyView() }
                    )
                )
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
