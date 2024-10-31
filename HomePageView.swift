import SwiftUI
import GoogleGenerativeAI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct HomePageView: View {
    @State private var destination = ""
    @State private var searchResults: [String] = []
    @State private var tripDuration = ""
    @State private var budget = ""
    @State private var travelCompanion = ""
    @State private var responseText = ""
    @StateObject private var aiService = GenerativeAIService()
    @State private var selectedBudget: String? = nil
    @State private var selectedTravelCompanion: String? = nil
    @State private var isLoading = false
    @State private var isTripGenerated = false
    @State private var selectedTab: Tab = .home
    @State private var navigateToLiked = false
    @State private var navigateToProfile = false
    @StateObject private var documentIDStore = DocumentIDStore()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Travel")
                            .bold()
                            .font(.title)

                        Text("Tell us about your travel preferences 🌴🏕️")
                            .font(.title2)
                            .padding(.horizontal)
                            .padding(.top, 20)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Just provide some basic information, and our trip planner will generate a customized itinerary based on your preferences")
                            .padding(.horizontal)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("What is the Destination of your choice?")
                            .padding(.horizontal)
                            .padding(.top, 20)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        TextField("Destination", text: $destination)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)) // Adding border
                            .padding(.horizontal)
                            .onChange(of: destination) { newValue in
                                if newValue.count >= 3 {
                                    searchForDestinations(query: newValue)
                                } else {
                                    searchResults.removeAll()
                                }
                            }

                        Text("For how many days are you planning the trip?")
                            .bold()
                            .padding(.horizontal)
                            .padding(.top, 20)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        TextField("Trip Duration", text: $tripDuration)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)) // Adding border
                            .padding(.horizontal)

                        Text("What is Your Budget?")
                            .padding(.horizontal)
                            .padding(.top, 20)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(alignment: .center, spacing: 20) {
                            VStack {
                                Button(action: {
                                    budget = "Cheap"
                                    selectedBudget = "Cheap"
                                }) {
                                    VStack {
                                        Text("💵")
                                            .font(.system(size: 50))
                                        Text("Cheap")
                                    }
                                }
                                .padding()
                                .background(selectedBudget == "Cheap" ? Color.gray.opacity(0.2) : Color.clear) // Optional background color
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedBudget == "Cheap" ? Color.black : Color.clear, lineWidth: 2)
                                )
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Button(action: {
                                    budget = "Moderate"
                                    selectedBudget = "Moderate"
                                }) {
                                    VStack {
                                        Text("💰")
                                            .font(.system(size: 50))
                                        Text("Moderate")
                                    }
                                }
                                .padding()
                                .background(selectedBudget == "Moderate" ? Color.gray.opacity(0.2) : Color.clear) // Optional background color
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedBudget == "Moderate" ? Color.black : Color.clear, lineWidth: 2)
                                )
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Button(action: {
                                    budget = "Luxury"
                                    selectedBudget = "Luxury"
                                }) {
                                    VStack {
                                        Text("💸")
                                            .font(.system(size: 50))
                                        Text("Luxury")
                                    }
                                }
                                .padding()
                                .background(selectedBudget == "Luxury" ? Color.gray.opacity(0.2) : Color.clear) // Optional background color
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedBudget == "Luxury" ? Color.black : Color.clear, lineWidth: 2)
                                )
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)

                        Text("Who do you plan to travel with on your adventure?")
                            .bold()
                            .padding(.horizontal, 30) // Increased padding for bold text
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(alignment: .center, spacing: 20) {
                            VStack {
                                Button(action: {
                                    travelCompanion = "Solo"
                                    selectedTravelCompanion = "Solo"
                                }) {
                                    VStack {
                                        Text("✈️")
                                            .font(.system(size: 50))
                                        Text("Solo")
                                    }
                                }
                                .padding()
                                .background(selectedTravelCompanion == "Solo" ? Color.gray.opacity(0.2) : Color.clear) // Optional background color
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedTravelCompanion == "Solo" ? Color.black : Color.clear, lineWidth: 2)
                                )
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Button(action: {
                                    travelCompanion = "Couple"
                                    selectedTravelCompanion = "Couple"
                                }) {
                                    VStack {
                                        Text("🥂")
                                            .font(.system(size: 50))
                                        Text("Couple")
                                    }
                                }
                                .padding()
                                .background(selectedTravelCompanion == "Couple" ? Color.gray.opacity(0.2) : Color.clear) // Optional background color
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedTravelCompanion == "Couple" ? Color.black : Color.clear, lineWidth: 2)
                                )
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                        
                        HStack(alignment: .center, spacing: 20) {
                            VStack {
                                Button(action: {
                                    travelCompanion = "Family"
                                    selectedTravelCompanion = "Family"
                                }) {
                                    VStack {
                                        Text("🏡")
                                            .font(.system(size: 50))
                                        Text("Family")
                                    }
                                }
                                .padding()
                                .background(selectedTravelCompanion == "Family" ? Color.gray.opacity(0.2) : Color.clear) // Optional background color
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedTravelCompanion == "Family" ? Color.black : Color.clear, lineWidth: 2)
                                )
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Button(action: {
                                    travelCompanion = "Friends"
                                    selectedTravelCompanion = "Friends"
                                }) {
                                    VStack {
                                        Text("🛥️")
                                            .font(.system(size: 50))
                                        Text("Friends")
                                    }
                                }
                                .padding()
                                .background(selectedTravelCompanion == "Friends" ? Color.gray.opacity(0.2) : Color.clear) // Optional background color
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedTravelCompanion == "Friends" ? Color.black : Color.clear, lineWidth: 2)
                                )
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)

                        Button("Generate Trip") {
                            Task {
                                isLoading = true
                                await generateTrip()
                                isLoading = false
                                
                                isTripGenerated = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.top, 30)
                        .disabled(destination.isEmpty || tripDuration.isEmpty || budget.isEmpty || travelCompanion.isEmpty)


                        if isLoading {
                            ProgressView()
                                .padding()
                        }

                        NavigationLink(
                            destination: TripResultView(responseText: responseText).environmentObject(documentIDStore),
                            isActive: $isTripGenerated
                        ) {
                            EmptyView()
                        }

                        List(searchResults, id: \.self) { result in
                            Text(result)
                                .padding(.horizontal)
                        }

                        if !responseText.isEmpty {
                            Text(responseText)
                                .padding()
                        }
                    }
                    .padding()
                }

                BottomNavigationBar(selectedTab: $selectedTab)
                    .onChange(of: selectedTab) { newTab in
                        switch newTab {
                        case .home:
                            break
                        case .liked:
                            navigateToLiked = true
                        case .profile:
                            navigateToProfile = true
                        }
                    }
            }
            .navigationDestination(isPresented: $navigateToLiked) {
                Liked()
            }
            .navigationDestination(isPresented: $navigateToProfile) {
                ProfileView()
            }
        }
    }

    func searchForDestinations(query: String) {
        searchResults = ["Paris", "London", "New York", "Tokyo", "Sydney", "Barcelona"]
    }
    
    private func generateTrip() async {
        let prompt = "Generate Travel plan for Location : \(destination), for \(tripDuration) days, for \(travelCompanion) with a \(budget) budget. Give me a hotel options list with HotelName, HotelAddress, Price, Hotel image url, geo coordinates, rating, description and suggest itinerary with placeName, placeDetails, place image url, geo coordinates, ticket pricing, time to travel each of the location for 3 days with each day plan with best time to visit in JSON format Only and No text outside the json filem and Price should be in INR"
        
        do {
             let response: GenerateContentResponse = try await aiService.chat.sendMessage(prompt)
             
             if let text = response.text {
                 responseText = text
                 print(responseText)
                 await addTrip(response: text)
             } else {
                 responseText = "No content available"
             }
         } catch {
             print("Error sending message: \(error)")
             responseText = "Failed to generate trip."
         }
    }
    private func addTrip(response: String) async {
        let db = Firestore.firestore()
        var docId = String(Int(Date().timeIntervalSince1970))
        
        documentIDStore.docID = docId;
        
        guard let userID = Auth.auth().currentUser?.uid else {
                print("No logged-in user")
                return
            }
        
        
        guard let currEmail = Auth.auth().currentUser?.email else {
                print("No logged-in user")
                return
            }
        
        
        let tripData: [String: Any] = [
            "userId" : userID,
            "emailId" : currEmail,
            "docId": docId,
            "destination": destination,
            "tripDuration": tripDuration,
            "budget": budget,
            "travelCompanion": travelCompanion,
            "response": response,
            "createdAt": Timestamp(date: Date())
        ]

        do {
            try await db.collection("AiTrips").document(docId).setData(tripData)
            print("Document successfully written with ID: \(docId)")
        } catch {
            print("Error writing document: \(error)")
        }
    }
}

#Preview {
    HomePageView()
}

