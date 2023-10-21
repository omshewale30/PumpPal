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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View{
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
                authenticateUser()
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
                    userStore.loginUser(username: username, password: password, context: viewContext)
                    shouldNavigateToActionView=true
                    
                })
            } else {
                return Alert(title: Text("Invalid Login"), message: Text("Please check your username and password and try again."), dismissButton: .default(Text("OK")))
            }
        }
        .background(
            NavigationLink(
                destination: shouldNavigateToActionView ? ActionView() : nil,
                isActive: $shouldNavigateToActionView
            ) {
                EmptyView()
            }
                .navigationTitle("Login")
            .hidden()
            )
    }
        private func authenticateUser(){
            let context=PersistenceController.shared.container.viewContext
            let fetchRequest : NSFetchRequest<UserEntity>=UserEntity.fetchRequest()
            fetchRequest.predicate=NSPredicate(format: "username == %@", username)
    
            do {
                let users = try context.fetch(fetchRequest)
                if let user = users.first, user.password == password {
                    isAuth = true
    
                } else {
                    // Display an authentication error message
                    print("Authentication failed. Incorrect username or password.")
                }
            } catch {
                // Handle the error
                print("Error fetching user: \(error.localizedDescription)")
            }
    
    
        }
}

            



#Preview {
    LoginView()
}
