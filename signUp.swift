//
//  signUp.swift
//  Let'goFirebase
//
//  Created by Harmeet Singh on 11/08/24.
//

import SwiftUI

struct signUp: View {
    @State private var errorMessage: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
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
                
                Text("Sign Up")
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
                        authorization.register(email: email, password: password) { error in
                            if let error = error {
                                alertMessage = error.localizedDescription
                                showingAlert = true
                            } else {
                                isLoggedIn = true
                            }
                        }
                    }
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 55)
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .navigationDestination(isPresented: $isLoggedIn) {
                    HomePageView()
                }
                
                NavigationLink(destination: loginView()) {
                    Text("Already have an account? Login")
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        signUp()
    }
}
