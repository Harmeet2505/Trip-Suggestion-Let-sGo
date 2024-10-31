import SwiftUI
import FirebaseFirestore
import GooglePlaces

struct TripResultView: View {
    let responseText: String
    
    @State private var tripPlan: TripPlan?
    @State private var selectedHotelId: UUID?
    @State private var selectedTab: Tab = .home
    @State private var navigateToHome: Bool = false
    @State private var navigateToLiked: Bool = false
    @State private var navigateToProfile: Bool = false
    @State private var showAlert: Bool = false
    @State private var showSuccessMessage: Bool = false
    @State private var db = Firestore.firestore() // Firestore reference
    @EnvironmentObject var documentIDStore: DocumentIDStore
    @State private var placeResults: [GMSPlace] = []
    
    // State to store loaded hotel images
    @State private var hotelImages: [UUID: URL] = [:]
    @State private var placeImages: [UUID: URL] = [:]
    
    var body: some View {
        NavigationStack {
            VStack {
                if let tripPlan = tripPlan {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Hotels Section
                            Text("Hotels")
                                .font(.title)
                                .bold()
                                .padding(.leading, 16) // Add left padding for the title
                            
                            ForEach(tripPlan.hotels) { hotel in
                                Button(action: {
                                    self.selectedHotelId = hotel.id
                                }) {
                                    VStack(alignment: .leading) {
                                        // Adjust the image view for hotels
                                        if let hotelImageUrl = hotelImages[hotel.id] {
                                            AsyncImage(url: hotelImageUrl) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit() // Scale to fit the view
                                                    .frame(maxWidth: .infinity, maxHeight: 200) // Set max width and height
                                                    .clipped() // Maintain aspect ratio
                                            } placeholder: {
                                                ProgressView() // Show a loading indicator
                                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                            }
                                            .padding(.horizontal, 16) // Adjust horizontal padding for the image
                                        } else {
                                            AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit() // Scale to fit the view
                                                    .frame(maxWidth: .infinity, maxHeight: 200) // Set max width and height
                                                    .clipped() // Maintain aspect ratio
                                            } placeholder: {
                                                ProgressView() // Show a loading indicator
                                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                            }
                                            .padding(.horizontal, 16) // Adjust horizontal padding for the image
                                            .onAppear {
                                                fetchHotelImage(for: hotel)
                                            }
                                        }
                                        
                                        Text(hotel.hotelName)
                                            .font(.headline)
                                            .padding(.top, 5) // Add some spacing
                                            .lineLimit(1) // Limit to one line
                                            .truncationMode(.tail) // Add ellipsis if text overflows
                                        Text(hotel.hotelAddress)
                                            .font(.subheadline)
                                            .lineLimit(1) // Limit to one line
                                            .truncationMode(.tail) // Add ellipsis if text overflows
                                        Text("Price: \(hotel.price)")
                                            .font(.subheadline)
                                            .lineLimit(1) // Limit to one line
                                            .truncationMode(.tail) // Add ellipsis if text overflows
                                        Text("Rating: \(hotel.rating)")
                                            .font(.subheadline)
                                            .lineLimit(1) // Limit to one line
                                            .truncationMode(.tail) // Add ellipsis if text overflows
                                        Text(hotel.description)
                                            .font(.body)
                                            .lineLimit(3) // Limit to three lines
                                            .truncationMode(.tail) // Add ellipsis if text overflows
                                            .padding(.top, 2) // Add some spacing
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(self.selectedHotelId == hotel.id ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.bottom, 10)
                            }

                            // Itinerary Section
                            Text("Itinerary")
                                .font(.title)
                                .bold()
                                .padding(.leading, 16) // Add left padding for the title
                            
                            ForEach(tripPlan.itinerary.keys.sorted {
                                if let dayNumber1 = Int($0.dropFirst(3)), let dayNumber2 = Int($1.dropFirst(3)) {
                                    return dayNumber1 < dayNumber2
                                }
                                return false
                            }, id: \.self) { day in
                                if let dayPlan = tripPlan.itinerary[day] {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Day \(day.dropFirst(3)):")
                                            .font(.title2)
                                            .padding(.bottom, 5)
                                            .bold()
                                        Text("Best Time to Visit: \(dayPlan.bestTime)")
                                            .font(.headline)
                                            .lineLimit(1) // Limit to one line
                                            .truncationMode(.tail) // Add ellipsis if text overflows
                                        ForEach(dayPlan.plan) { place in
                                            VStack(alignment: .leading) {
                                                // Adjust the image view for places
                                                if let placeImageUrl = placeImages[place.id] {
                                                    AsyncImage(url: placeImageUrl) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit() // Scale to fit the view
                                                            .frame(maxWidth: .infinity, maxHeight: 200) // Set max width and height
                                                            .clipped() // Maintain aspect ratio
                                                    } placeholder: {
                                                        ProgressView() // Show a loading indicator
                                                            .frame(maxWidth: .infinity, maxHeight: 200)
                                                    }
                                                    .padding(.horizontal, 16) // Adjust horizontal padding for the image
                                                } else {
                                                    AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit() // Scale to fit the view
                                                            .frame(maxWidth: .infinity, maxHeight: 200) // Set max width and height
                                                            .clipped() // Maintain aspect ratio
                                                    } placeholder: {
                                                        ProgressView() // Show a loading indicator
                                                            .frame(maxWidth: .infinity, maxHeight: 200)
                                                    }
                                                    .padding(.horizontal, 16) // Adjust horizontal padding for the image
                                                    .onAppear {
                                                        fetchPlaceImage(for: place) // Fetch the image when the place appears
                                                    }
                                                }
                                                
                                                Text(place.placeName)
                                                    .font(.headline)
                                                    .padding(.top, 5) // Add some spacing
                                                    .lineLimit(1) // Limit to one line
                                                    .truncationMode(.tail) // Add ellipsis if text overflows
                                                Text(place.placeDetails)
                                                    .font(.subheadline)
                                                    .lineLimit(1) // Limit to one line
                                                    .truncationMode(.tail) // Add ellipsis if text overflows
                                                Text("Ticket Pricing: \(place.ticketPricing)")
                                                    .font(.subheadline)
                                                    .lineLimit(1) // Limit to one line
                                                    .truncationMode(.tail) // Add ellipsis if text overflows
                                                Text("Time to Travel: \(place.timeToTravel)")
                                                    .font(.subheadline)
                                                    .lineLimit(1) // Limit to one line
                                                    .truncationMode(.tail) // Add ellipsis if text overflows
                                                Divider()
                                            }
                                            .padding()
                                        }

                                    }
                                    .padding()
                                }
                            }

                            // Save Trip Button
                            Button(action: saveTrip) {
                                Text("Save Trip")
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 100)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("No Hotel Selected"), message: Text("Please select a hotel before saving."), dismissButton: .default(Text("OK")))
                            }
                            .alert(isPresented: $showSuccessMessage) {
                                Alert(title: Text("Success"), message: Text("Trip has been saved successfully."), dismissButton: .default(Text("OK")))
                            }
                        }
                        .padding(.horizontal, 16) // Adjust the main padding for the scroll view
                    }
                } else {
                    Text("Loading...")
                        .onAppear {
                            parseResponse()
                        }
                }
                
                // Bottom Navigation Bar
                VStack {
                    BottomNavigationBar(selectedTab: $selectedTab)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .onChange(of: selectedTab) { newTab in
                            switch newTab {
                            case .home:
                                navigateToHome = true
                            case .liked:
                                navigateToLiked = true
                            case .profile:
                                navigateToProfile = true
                            }
                        }
                }
            }
            .navigationTitle("Trip Results")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Tab.self) { tab in
                switch tab {
                case .home:
                    HomePageView()
                case .liked:
                    Liked()
                case .profile:
                    ProfileView()
                }
            }
            .navigationBarBackButtonHidden(true) // Hide the back button
            NavigationLink(destination: HomePageView(), isActive: $navigateToHome) { EmptyView() }
            NavigationLink(destination: Liked(), isActive: $navigateToLiked) { EmptyView() }
            NavigationLink(destination: ProfileView(), isActive: $navigateToProfile) { EmptyView() }
        }
    }
    
    
    func parseResponse() {
        let cleanedJsonString = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "", with: "")
            .replacingOccurrences(of: "`", with: "")
            .replacingOccurrences(of: "json", with: "")
        
        guard let jsonData = cleanedJsonString.data(using: .utf8) else {
            print("Failed to convert string to Data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let tripPlan = try decoder.decode(TripPlan.self, from: jsonData)
            print("Parsed Response: \(tripPlan)")
            self.tripPlan = tripPlan
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    private func saveTrip() {
        guard let docId = documentIDStore.docID else {
            print("No Doc Id")
            return
        }
        
        let tripRef = db.collection("AiTrips").document(docId)
        
        tripRef.getDocument { (document, error) in
            if let document = document, document.exists {
                tripRef.updateData([
                    "isLiked": true
                ]) { error in
                    if let error = error {
                        print("Error updating trip: \(error)")
                    } else {
                        print("Trip successfully updated")
                        showSuccessMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            navigateToLiked = true
                        }
                    }
                }
            } else {
                print("Trip document does not exist")
            }
        }
    }
    private func fetchHotelImage(for hotel: Hotel) {
        guard let apiKey = ProcessInfo.processInfo.environment["GOOGLE_PLACES_KEY"] else {
            print("API Key not found")
            return
        }
        
        // Extract latitude and longitude from geoCoordinates
        let geoCoordinates = hotel.geoCoordinates
        let components = geoCoordinates.components(separatedBy: ", ")
        guard components.count == 2 else {
            print("Invalid geoCoordinates format")
            return
        }
        
        // Parse latitude
        var latitudeString = components[0].trimmingCharacters(in: .whitespaces)
        let latitudeDirection = latitudeString.suffix(1) // 'N' or 'S'
        latitudeString = latitudeString.dropLast().trimmingCharacters(in: CharacterSet(charactersIn: " °"))
        
        guard let latitude = Double(latitudeString) else {
            print("Invalid latitude value: \(latitudeString)")
            return
        }
        let parsedLatitude = (latitudeDirection == "S" ? -1 : 1) * latitude
        
        // Parse longitude
        var longitudeString = components[1].trimmingCharacters(in: .whitespaces)
        let longitudeDirection = longitudeString.suffix(1) // 'E' or 'W'
        longitudeString = longitudeString.dropLast().trimmingCharacters(in: CharacterSet(charactersIn: " °"))
        
        guard let longitude = Double(longitudeString) else {
            print("Invalid longitude value: \(longitudeString)")
            return
        }
        let parsedLongitude = (longitudeDirection == "W" ? -1 : 1) * longitude
        
        // Use parsed latitude and longitude in API request
        let textSearchUrlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(hotel.hotelName)&location=\(parsedLatitude),\(parsedLongitude)&key=\(apiKey)"
        
        guard let url = URL(string: textSearchUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let firstResult = results.first,
                   let photos = firstResult["photos"] as? [[String: Any]],
                   let photoReference = photos.first?["photo_reference"] as? String {
                    
                    let photoUrlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoReference)&key=\(String(describing: apiKey))"
                    if let photoUrl = URL(string: photoUrlString) {
                        DispatchQueue.main.async {
                            hotelImages[hotel.id] = photoUrl
                        }
                    }
                }
            } catch {
                print("Error parsing JSON for hotel image: \(error)")
            }
        }.resume()
    }
    private func fetchPlaceImage(for place: Place) {
        guard let apiKey = ProcessInfo.processInfo.environment["GOOGLE_PLACES_KEY"] else {
            print("API Key not found")
            return
        }
        
        // Extract latitude and longitude from geoCoordinates
        let geoCoordinates = place.geoCoordinates
        let components = geoCoordinates.components(separatedBy: ", ")
        guard components.count == 2 else {
            print("Invalid geoCoordinates format for place: \(place.placeName)")
            return
        }
        
        // Parse latitude
        var latitudeString = components[0].trimmingCharacters(in: .whitespaces)
        let latitudeDirection = latitudeString.suffix(1) // 'N' or 'S'
        latitudeString = latitudeString.dropLast().trimmingCharacters(in: CharacterSet(charactersIn: " °"))
        
        guard let latitude = Double(latitudeString) else {
            print("Invalid latitude value for place: \(latitudeString) in place: \(place.placeName)")
            return
        }
        let parsedLatitude = (latitudeDirection == "S" ? -1 : 1) * latitude
        
        // Parse longitude
        var longitudeString = components[1].trimmingCharacters(in: .whitespaces)
        let longitudeDirection = longitudeString.suffix(1) // 'E' or 'W'
        longitudeString = longitudeString.dropLast().trimmingCharacters(in: CharacterSet(charactersIn: " °"))
        
        guard let longitude = Double(longitudeString) else {
            print("Invalid longitude value for place: \(longitudeString) in place: \(place.placeName)")
            return
        }
        let parsedLongitude = (longitudeDirection == "W" ? -1 : 1) * longitude
        
        // Use parsed latitude and longitude in API request
        let textSearchUrlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(place.placeName)&location=\(parsedLatitude),\(parsedLongitude)&key=\(String(describing: apiKey))"
        print("Fetching image for place: \(place.placeName) at coordinates: \(parsedLatitude), \(parsedLongitude)")

        
        guard let url = URL(string: textSearchUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let firstResult = results.first,
                   let photos = firstResult["photos"] as? [[String: Any]],
                   let photoReference = photos.first?["photo_reference"] as? String {
                    
                    let photoUrlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoReference)&key=\(apiKey)"
                    if let photoUrl = URL(string: photoUrlString) {
                        DispatchQueue.main.async {
                            placeImages[place.id] = photoUrl
                        }
                    }
                }
            } catch {
                print("Error parsing JSON for place image: \(error)")
            }
        }.resume()
    }

}




