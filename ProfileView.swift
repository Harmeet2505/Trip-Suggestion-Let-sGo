import SwiftUI
import FirebaseAuth
import Firebase

struct ProfileView: View {
    @State private var selectedTab: Tab = .profile
    @State private var navToHome = false
    @State private var navToLiked = false
    @State private var navToLogin = false
    @State var userEmail = ""
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Profile")
                            .font(.title)
                            .bold()
                            .padding(.top, 16)
                            .padding(.leading, 5)

                        if isLoading {
                            Text("Loading...")
                                .font(.title2)
                                .padding(.leading, 5)
                        } else {
                            Text("Email: \(userEmail)")
                                .font(.title2)
                                .padding(.leading, 5)
                        }

                        Button(action: logOut) {
                            Text("Log Out")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding(.top, 400)
                        .padding(.horizontal, 130)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onAppear {
                        fetchUserEmail()
                    }
                }

                BottomNavigationBar(selectedTab: $selectedTab)
                    .onChange(of: selectedTab) { newTab in
                        switch newTab {
                        case .home:
                            navToHome = true
                        case .liked:
                            navToLiked = true
                        case .profile:
                            break
                        }
                    }
                
                NavigationLink(destination: HomePageView(), isActive: $navToHome) {
                    EmptyView()
                }
                
                NavigationLink(destination: Liked(), isActive: $navToLiked) {
                    EmptyView()
                }
                
                NavigationLink(destination: loginView(), isActive: $navToLogin) {
                    EmptyView()
                }
            }
        }
    }
    
    private func fetchUserEmail() {
        Task {
            let user = Auth.auth().currentUser
            if let email = user?.email {
                print("Fetched email: \(email)")
                self.userEmail = email
            } else {
                print("No user found")
            }
            self.isLoading = false
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
            navToLogin = true
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

