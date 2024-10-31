//
//  BottomNavigationBar.swift
//  Let'goFirebase
//
//  Created by Harmeet Singh on 15/09/24.
//

import Foundation
import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                selectedTab = .home
            }) {
                VStack {
                    Image(systemName: selectedTab == .home ? "house.fill" : "house")
                    Text("Home")
                }
            }
            Spacer()

            Button(action: {
                selectedTab = .liked
            }) {
                VStack {
                    Image(systemName: selectedTab == .liked ? "heart.fill" : "heart")
                    Text("Liked")
                }
            }
            Spacer()

            Button(action: {
                selectedTab = .profile
            }) {
                VStack {
                    Image(systemName: selectedTab == .profile ? "person.fill" : "person")
                    Text("Profile")
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1)) // Add a background color if needed
    }
}

enum Tab {
    case home, liked, profile
}

