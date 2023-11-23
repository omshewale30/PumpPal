//
//  ActionView.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI

struct ActionView: View {
    
    
    
    @State private var greeting = TimeViewModel.getGreeting()
    @State private var currentTime = TimeViewModel.getCurrentTime()
    @State private var currentDay = TimeViewModel.getCurrentDay()
    @State private var currentDate = TimeViewModel.getCurrentDate()

   

    @EnvironmentObject var userStore: UserStore
    @State private var logOut=false
    var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    Text("PumpPal")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.black)
                    
                        .shadow(color: .brown, radius: 3, x: 0, y: 2)
                    Rectangle()
                        .fill(Color(hex: "ED7D31"))
                        .frame(width: 160, height: 100)
                        .cornerRadius(60)
                        .overlay(
                            VStack {
                                Text("\(currentDay)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("\(currentDate)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        )
                        .padding()
                        .offset(x:+110)
                    
                    Rectangle()
                        .fill(Color(hex: "ED7D31"))
                        .frame(width:300, height: 100)
                        .cornerRadius(60)
                        .overlay(
                            Text(greeting)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            )
                        .offset(x:-40)
                    
                    VStack {
                        Text("Clock is ticking")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "6C5F5B"))
           
                        Text("\(currentTime)")
                            .font(.headline)
                            .foregroundColor(Color(hex: "6C5F5B"))
                            .padding(5)
                        Text("What are you going to do about it? ")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "6C5F5B"))
                    }
                    Spacer()
                    
                    HStack(spacing: 60) {
                        Rectangle()
                            .fill(Color(hex: "F4DFC8"))
                            .frame(width: 150, height: 120)
                            .cornerRadius(10)
                            .overlay(
                        NavigationLink(destination: MealEntry()) {
                            VStack {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .fontWeight(.bold)
                                Text("Log food")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .buttonStyle(PlainButtonStyle())
                        )
                        Rectangle()
                            .fill(Color(hex: "F4DFC8"))
                            .frame(width: 150, height: 120)
                            .cornerRadius(10)
                            .overlay(
                        NavigationLink(destination: ViewHistory()) {
                            VStack {
                                Image(systemName: "clock")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .fontWeight(.bold)
                                Text("History")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .buttonStyle(PlainButtonStyle())
                        )
                    }
                    Spacer()
                    
                    HStack{
            
                        Rectangle()
                            .fill(Color(hex: "F4DFC8"))
                            .frame(width: 150, height: 120)
                            .cornerRadius(10)
                            .overlay(
                        NavigationLink(destination: LocationView()) {
                            VStack {
                                Image(systemName: "map")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .fontWeight(.bold)
                                Text("History")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .buttonStyle(PlainButtonStyle())
                        )
                        
                        Spacer()
                        Rectangle()
                            .fill(Color(hex: "F4DFC8"))
                            .frame(width: 150, height: 120)
                            .cornerRadius(10)
                            .overlay(
                        Button {
                            userStore.logout()
                            logOut = true
                        } label: {
                            VStack {
                                Image(systemName:  "arrow.backward.square")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .fontWeight(.bold)
                                Text("Log Out")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            
                        }
                        .padding()
                        .navigationDestination(isPresented: $logOut){
                            LoginView().navigationBarBackButtonHidden(true)
                        }
                        .buttonStyle(PlainButtonStyle())
                        )
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(hex: "FAF6F0").edgesIgnoringSafeArea(.all))
                .onAppear {
                    // Update the time every second
                    let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        currentTime = TimeViewModel.getCurrentTime()
                    }
                    RunLoop.main.add(timer, forMode: .common)
                }
            }
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
