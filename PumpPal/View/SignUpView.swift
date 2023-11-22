//
//  SignUpView.swift
//  PumpPal
//
//  Created by Om Shewale on 11/14/23.
//

import SwiftUI

struct SignUpView: View {
    

    @StateObject var coreVM=CoreDataViewModel()
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var isShowingAlert=false
    @State private var isAdded=false
    
    @State private var shouldNavigateToLoginView=false
    var body: some View {
        
        ZStack {
            Color(hex: "#454d66")
                .ignoresSafeArea()
            VStack{
                Text("Sign Up")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding()
                    .foregroundStyle(Color(hex: "#454d66"))
                VStack{
                    TextField("Username", text: $username)
                        .padding()
            
                    
                    SecureField("Password", text: $password)
                        .padding()
                }
                .background(Color(hex: "#efeeb4"))

                Button(action: {
                    isAdded = coreVM.addItem(userName: username, pass: password)
                    isShowingAlert=true
                }) {
                    Text("Sign Up")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#309975"))
                        .cornerRadius(10)
                }
                .padding()
                HStack{
                    Text("Already have an account?")
                    Text("Log in")
                        .foregroundColor(Color(hex: "#454d66"))
                        .fontWeight(.bold)
                        .onTapGesture {
                            shouldNavigateToLoginView = true
                        }
                }
                .padding()
             
            }
            .background(Color(hex: "#dad873")).ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            .alert(isPresented: $isShowingAlert) {
                if isAdded {
                    return Alert(title: Text("Sign Up Successful"), message: Text("Welcome, \(username)!"), dismissButton: .default(Text("OK")){
                        shouldNavigateToLoginView=true
                    })
                    
                } else {
                    return Alert(title: Text("Invalid Login"), message: Text("Please check your username and password and try again."), dismissButton: .default(Text("OK")))
                }
            }
            .navigationDestination(isPresented: $shouldNavigateToLoginView){
                LoginView().navigationBarBackButtonHidden(true)
        }
        }
    }

    
    
}

#Preview {
    SignUpView()
}
