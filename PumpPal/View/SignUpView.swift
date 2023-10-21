//
//  SignUpView.swift
//  PumpPal
//
//  Created by Om Shewale on 11/14/23.
//

import SwiftUI

struct SignUpView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserEntity.username, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<UserEntity>
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var isShowingAlert=false
    @State private var isAdded=false
    var body: some View {
        VStack{
            Text("Sign Up")
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
                addItem(userName: username, pass: password)
                isShowingAlert=true
            }) {
                Text("Sign Up")
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
            if isAdded {
                return Alert(title: Text("Sign Up Successful"), message: Text("Welcome, \(username)!"), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Invalid Login"), message: Text("Please check your username and password and try again."), dismissButton: .default(Text("OK")))
            }
        }
    }
    private func addItem(userName:String,pass:String) {
            withAnimation {
                let newItem = UserEntity(context: viewContext)
                newItem.username=userName
                newItem.password=pass
                
                do {
                    try viewContext.save()
                    isAdded=true
                    print("User \(newItem.username) saved")
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    
    
    
}

#Preview {
    SignUpView()
}
