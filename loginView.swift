//
//  loginView.swift
//  Let'goFirebase
//
//  Created by Harmeet Singh on 11/08/24.
//

import SwiftUI

struct loginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    @State private var alertMessage: String = ""
    @StateObject private var authorization = AuthService()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 25)
                
                Text("Login")
                    .font(.largeTitle)
                    .padding(.bottom, 40)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(30)
                    .padding(.horizontal, 25)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(30)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 80)
                
                Button(action: {
                    if email.isEmpty || password.isEmpty {
                        alertMessage = "Please enter both email and password"
                        showingAlert = true
                    } else {
                        authorization.signIn(email: email, password: password) { error in
                            if let error = error {
                                alertMessage = error.localizedDescription
                                showingAlert = true
                            } else {
                                isLoggedIn = true
                            }
                        }
                    }
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 55)
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .navigationDestination(isPresented: $isLoggedIn) {
                   HomePageView()// Navigate to the home page upon successful login
                }
                
                NavigationLink(destination: signUp()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        loginView()
    }
}
