//
//  WelcomeView.swift
//  Let'goFirebase
//
//  Created by Harmeet Singh on 15/09/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: loginView()) {
                        Text("Next  >")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("") // Optional: Set the title if needed
        .navigationBarHidden(true) // Optional: Hide the default navigation bar
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}


#Preview {
    WelcomeView()
}
