
import SwiftUI
import FirebaseFirestore

struct TripDetailsView: View {
    @EnvironmentObject var tripData: TripData
    
    @State private var tripPlan: TripPlan?
    @State private var selectedHotelId: UUID?
    @State private var selectedTab: Tab = .home
    @State private var navigateToHome: Bool = false
    @State private var navigateToLiked: Bool = false
    @State private var navigateToProfile: Bool = false
    @State private var showAlert: Bool = false
    @State private var showSuccessMessage: Bool = false
    @State private var db = Firestore.firestore()
    @State private var hotelImages: [UUID: URL] = [:]
    @State private var placeImages: [UUID: URL] = [:]
    
    var body: some View {
        NavigationStack {
            VStack {
                if let tripPlan = tripPlan {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            Text("Hotel")
                                .font(.title)
                                .bold()
                            
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
                                                    .scaledToFit()
                                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                                    .clipped()
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                            }
                                            .padding(.horizontal, 16)
                                        } else {
                                            AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                                    .clipped()
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                            }
                                            .padding(.horizontal, 16)
                                            .onAppear {
                                                fetchHotelImage(for: hotel)
                                            }
                                        }
                                        
                                        Text(hotel.hotelName)
                                            .font(.headline)
                                            .padding(.top, 5)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Text(hotel.hotelAddress)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Text("Price: \(hotel.price)")
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Text("Rating: \(hotel.rating)")
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Text(hotel.description)
                                            .font(.body)
                                            .lineLimit(3)
                                            .truncationMode(.tail)
                                            .padding(.top, 2)
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
                            
                            Text("Itinerary")
                                .font(.title)
                                .bold()
                                .navigationBarBackButtonHidden(true)
                            
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
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        ForEach(dayPlan.plan) { place in
                                            VStack(alignment: .leading) {
                                                
                                                if let placeImageUrl = placeImages[place.id] {
                                                    AsyncImage(url: placeImageUrl) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(maxWidth: .infinity, maxHeight: 200)
                                                            .clipped()
                                                    } placeholder: {
                                                        ProgressView()
                                                            .frame(maxWidth: .infinity, maxHeight: 200)
                                                    }
                                                    .padding(.horizontal, 16)
                                                } else {
                                                    AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(maxWidth: .infinity, maxHeight: 200)
                                                            .clipped()
                                                    } placeholder: {
                                                        ProgressView()
                                                            .frame(maxWidth: .infinity, maxHeight: 200)
                                                    }
                                                    .padding(.horizontal, 16)
                                                    .onAppear {
                                                        fetchPlaceImage(for: place)
                                                    }
                                                }
                                                
                                                Text(place.placeName)
                                                    .font(.headline)
                                                    .padding(.top, 5)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                Text(place.placeDetails)
                                                    .font(.subheadline)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                Text("Ticket Pricing: \(place.ticketPricing)")
                                                    .font(.subheadline)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                Text("Time to Travel: \(place.timeToTravel)")
                                                    .font(.subheadline)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                Divider()
                                            }
                                            .padding()
                                        }

                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    
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
                
                NavigationLink(destination: HomePageView(), isActive: $navigateToHome) {
                    EmptyView()
                }
                
                NavigationLink(destination: Liked(), isActive: $navigateToLiked) {
                    EmptyView()
                }
                
                NavigationLink(destination: ProfileView(), isActive: $navigateToProfile) {
                    EmptyView()
                }
            }
            .onAppear {
                parseResponse()
            }
        }
    }
    
    func parseResponse() {
        let cleanedJsonString = tripData.responseText.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```", with: "")
            .replacingOccurrences(of: "`", with: "")
            .replacingOccurrences(of: "json", with: "")
        
        guard let jsonData = cleanedJsonString.data(using: .utf8) else {
            print("Failed to convert string to Data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let tripPlan = try decoder.decode(TripPlan.self, from: jsonData)
            self.tripPlan = tripPlan
        } catch {
            print("Error decoding JSON: \(error)")
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
        let textSearchUrlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(hotel.hotelName)&location=\(parsedLatitude),\(parsedLongitude)&key=\(String(describing: apiKey))"
        
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
                    print(photoUrlString)
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
                    
                    let photoUrlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoReference)&key=\(String(describing: apiKey))"
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

