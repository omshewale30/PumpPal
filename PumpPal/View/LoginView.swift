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
    @State private var isShowingAlert=false
    @State private var isAuth=false
    @StateObject var coreVM=CoreDataViewModel()
    
    var body: some View{
        NavigationStack{
            VStack{
                Text("LOGIN")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding()
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    isAuth = coreVM.authenticateUser(forUser: username, pass: password)
                    isShowingAlert=true
                    
                }) {
                    Text("Login")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
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
            .background(
                NavigationLink(
                    destination: ActionView().navigationBarBackButtonHidden(true),
                    isActive: $shouldNavigateToActionView,
                    label: { EmptyView() }
                )
        
            )
        }
    }
    

}

            



#Preview {
    LoginView()
}
