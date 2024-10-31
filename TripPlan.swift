import Foundation



struct TripPlan: Codable {
    let hotels: [Hotel]
    let itinerary: [String: DayPlan]
}

struct Hotel: Codable, Identifiable {
    let id = UUID()
    let hotelName: String
    let hotelAddress: String
    let price: String
    let hotelImageUrl: String
    let geoCoordinates: String
    let rating: String
    let description: String
}

struct DayPlan: Codable {
    let bestTime: String
    let plan: [Place]
}

struct Place: Codable, Identifiable {
    let id = UUID()
    let placeName: String
    let placeDetails: String
    let placeImageUrl: String
    let geoCoordinates: String
    let ticketPricing: String
    let timeToTravel: String
    let photoReference: String?
}



