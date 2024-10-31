import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Liked: View {
    @EnvironmentObject var tripData: TripData
    @State private var selectedTab: Tab = .liked
    @State private var navToHome = false
    @State private var navToProfile = false
    @State private var trips: [Trip] = []
    @State private var selectedTrip: Trip?
    @State private var currEmail: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                if trips.isEmpty {
                    Text("No trips liked yet.")
                        .font(.title)
                        .padding()
                        .frame(height: 600)
                } else {
                    List(trips.reversed()) { trip in
                        HStack {
                            Button(action: {
                                // Set the responseText in the shared state before navigating
                                tripData.responseText = trip.response
                                self.selectedTrip = trip
                            }) {
                                VStack(alignment: .leading) {
                                    Text("Destination: \(trip.destination)")
                                        .font(.headline)
                                    Text("Duration: \(trip.tripDuration)")
                                        .font(.subheadline)
                                    Text("Companion: \(trip.travelCompanion)")
                                        .font(.subheadline)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                BottomNavigationBar(selectedTab: $selectedTab)
                    .onChange(of: selectedTab) { newTab in
                        switch newTab {
                        case .home:
                            navToHome = true
                        case .liked:
                            // Stay on Liked
                            break
                        case .profile:
                            navToProfile = true
                        }
                    }
                
                NavigationLink(destination: HomePageView(), isActive: $navToHome) {
                    EmptyView()
                }
                
                NavigationLink(destination: ProfileView(), isActive: $navToProfile) {
                    EmptyView()
                }
                
                NavigationLink(destination: TripDetailsView()
                    .environmentObject(tripData), isActive: Binding(
                        get: { selectedTrip != nil },
                        set: { if !$0 { selectedTrip = nil } })
                ) {
                    EmptyView()
                }
            }
            .onAppear {
                fetchCurrentUserEmail()
            }
            .navigationTitle("Liked Trips")
        }
    }
    
    // Fetch the logged-in user's email from Firebase Auth
    private func fetchCurrentUserEmail() {
        if let userEmail = Auth.auth().currentUser?.email {
            self.currEmail = userEmail
            fetchLikedTrips()
        } else {
            print("No logged-in user")
        }
    }
    
    // Fetch trips from Firestore based on the logged-in user's email
    private func fetchLikedTrips() {
        let db = Firestore.firestore()
        db.collection("AiTrips").whereField("emailId", isEqualTo: currEmail).whereField("isLiked" ,isEqualTo: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching liked trips: \(error)")
            } else {
                self.trips = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Trip.self)
                } ?? []
            }
        }
    }
}

struct Trip: Identifiable, Decodable {
    @DocumentID var id: String?
    var destination: String
    var tripDuration: String
    var travelCompanion: String
    var docId : String
    var response :String
}

