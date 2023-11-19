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
                isAdded = coreVM.addItem(userName: username, pass: password)
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

    
    
}

#Preview {
    SignUpView()
}
