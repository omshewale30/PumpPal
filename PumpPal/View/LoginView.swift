//
//  LoginView.swift
//  PumpPal
//
//  Created by Om Shewale on 11/14/23.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var shouldNavigateToActionView=false
    
    @State private var shouldNavigateToSignUpView=false
    @State private var isShowingAlert=false
    @State private var isAuth=false
    @StateObject var coreVM=CoreDataViewModel()
    
    
    var body: some View{
        ZStack {
            Color(hex: "2E4374").ignoresSafeArea()
            VStack{
                    Text("LOGIN")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding()
                    
                    TextField("Username", text: $username)
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .padding()
                    
                    Button(action: {
                        isAuth = coreVM.authenticateUser(forUser: username, pass: password)
                        isShowingAlert=true
                        
                    }) {
                        Text("Login")
                            .font(.title2)
                            .foregroundColor(Color(hex: "2E4374"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "7C81AD"))
                            .cornerRadius(10)
                    }
                    .padding()
                    HStack{
                        Text("Don't have an account?")
                        Text("Sign up")
                            .foregroundColor(Color(hex: "2E4374"))
                            .fontWeight(.bold)
                            .onTapGesture {
                                shouldNavigateToSignUpView = true
                            }
                    }
                    .padding()
                }
            .background(Color(hex: "E5C3A6"))
                .navigationBarBackButtonHidden(true)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
                .alert(isPresented: $isShowingAlert) {
                    if isAuth {
                        return Alert(title: Text("Login Successful"), message: Text("Welcome, \(username)!"), dismissButton: .default(Text("OK")){
                            userStore.loginUser(username: username, password: password, context: coreVM.container.viewContext)
                            shouldNavigateToActionView=true
                        })
                    } else {
                        return Alert(title: Text("Invalid Login"), message: Text("Please check your username and password and try again."), dismissButton: .default(Text("OK")))
                    }
                }
                .navigationDestination(isPresented: $shouldNavigateToSignUpView){
                    SignUpView().navigationBarBackButtonHidden(true)
                }
                .navigationDestination(isPresented: $shouldNavigateToActionView){
                    ActionView().navigationBarBackButtonHidden(true)
            }
        }
        
    }
    

}

            



#Preview {
    LoginView()
}
