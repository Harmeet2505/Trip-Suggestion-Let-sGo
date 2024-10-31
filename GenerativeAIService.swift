import Foundation
import GoogleGenerativeAI

struct Response {
    let text: String?
}

class GenerativeAIService :ObservableObject {
    private let apiKey: String
    private let config: GenerationConfig
    private let model: GenerativeModel
    @Published var chat: Chat

    init() {
        // Retrieve the API key from environment variables
        guard let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] else {
            fatalError("Add GEMINI_API_KEY as an Environment Variable in your app's scheme.")
        }
        self.apiKey = apiKey
        
        // Initialize GenerationConfig
        self.config = GenerationConfig(
            temperature: 1,
            topP: 0.95,
            topK: 64,
            maxOutputTokens: 8192,
            responseMIMEType: "application/json"
        )
        
        // Initialize GenerativeModel
        self.model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: self.apiKey
            //            generationConfig: self.config,
            //            systemInstruction: "Generate Travel plan for Location : Las vegas, for 3 days, for couple with a cheap budget. Give me a hotel options list with HotelName, HotelAddress, Price, Hotel image url, geo coordinates, rating, description and suggest itinerary with placeName, placeDetails, place image url, geo coordinates, ticket pricing, time to travel each of the location for 3 days with each day plan with best time to visit in JSON format"=
        )
        
        // Initialize Chat
        self.chat = model.startChat(history: [
            ModelContent(
                role: "user",
                parts: [
                    .text("Generate Travel plan for Location : Las vegas, for 3 days, for couple with a cheap budget. Give me a hotel options list with HotelName, HotelAddress, Price, Hotel image url, geo coordinates, rating, description and suggest itinerary with placeName, placeDetails, place image url, geo coordinates, ticket pricing, time to travel each of the location for 3 days with each day plan with best time to visit in JSON format")
                ]
            ),
            ModelContent(
                role: "model",
                parts: [
                    .text("""
                    ```json
                    {
                      "hotels": [
                        {
                          "hotelName": "The D Las Vegas",
                          "hotelAddress": "301 Fremont Street, Las Vegas, NV 89101",
                          "price": "$50-$100 per night",
                          "hotelImageUrl": "https://www.the-d.com/media/images/the-d-hotel-exterior-day.jpg",
                          "geoCoordinates": "36.1699° N, 115.1407° W",
                          "rating": "4 stars",
                          "description": "A downtown Las Vegas hotel with a retro vibe, offering affordable rooms, a casino, and a variety of dining options."
                        },
                        {
                          "hotelName": "Golden Nugget Las Vegas",
                          "hotelAddress": "129 E Fremont St, Las Vegas, NV 89101",
                          "price": "$70-$150 per night",
                          "hotelImageUrl": "https://www.goldennugget.com/las-vegas/media/images/hero-image-mobile.jpg",
                          "geoCoordinates": "36.1697° N, 115.1413° W",
                          "rating": "4.5 stars",
                          "description": "A historic hotel with a modern twist, offering luxurious rooms, a casino, multiple restaurants, and a world-famous shark tank."
                        },
                        {
                          "hotelName": "Plaza Hotel & Casino",
                          "hotelAddress": "1 Main St, Las Vegas, NV 89101",
                          "price": "$60-$120 per night",
                          "hotelImageUrl": "https://www.plazahotelcasino.com/media/images/hero-plaza-hotel-casino.jpg",
                          "geoCoordinates": "36.1699° N, 115.1403° W",
                          "rating": "4 stars",
                          "description": "A downtown hotel with a vintage feel, offering comfortable rooms, a casino, and a variety of dining and entertainment options."
                        },
                        {
                          "hotelName": "Circus Circus Hotel & Casino",
                          "hotelAddress": "2880 S Las Vegas Blvd, Las Vegas, NV 89109",
                          "price": "$40-$80 per night",
                          "hotelImageUrl": "https://www.circuscircus.com/media/images/hero-image-mobile.jpg",
                          "geoCoordinates": "36.1075° N, 115.1708° W",
                          "rating": "3.5 stars",
                          "description": "A family-friendly hotel with a circus theme, offering affordable rooms, a casino, a variety of dining options, and a free circus show."
                        }
                      ],
                      "itinerary": {
                        "day1": {
                          "bestTime": "Morning",
                          "plan": [
                            {
                              "placeName": "Fremont Street Experience",
                              "placeDetails": "A pedestrian-friendly street with a canopy of lights, live music, street performers, and casinos.",
                              "placeImageUrl": "https://www.fremontstreetexperience.com/media/images/hero-image-mobile.jpg",
                              "geoCoordinates": "36.1699° N, 115.1403° W",
                              "ticketPricing": "Free",
                              "timeToTravel": "2-3 hours"
                            },
                            {
                              "placeName": "Neon Museum",
                              "placeDetails": "A museum showcasing vintage neon signs from Las Vegas's past.",
                              "placeImageUrl": "https://www.neonmuseum.org/media/images/hero-image-mobile.jpg",
                              "geoCoordinates": "36.1709° N, 115.1373° W",
                              "ticketPricing": "$20-$30 per person",
                              "timeToTravel": "1-2 hours"
                            },
                            {
                              "placeName": "Arts District",
                              "placeDetails": "A vibrant neighborhood with art galleries, studios, and murals.",
                              "placeImageUrl": "https://www.artsdistrictlv.com/media/images/hero-image-mobile.jpg",
                              "geoCoordinates": "36.1670° N, 115.1370° W",
                              "ticketPricing": "Free",
                              "timeToTravel": "1-2 hours"
                            }
                          ]
                        },
                        "day2": {
                          "bestTime": "Afternoon/Evening",
                          "plan": [
                            {
                              "placeName": "Bellagio Conservatory & Botanical Garden",
                              "placeDetails": "A stunning display of flowers and botanicals, changing seasonally.",
                              "placeImageUrl": "https://www.bellagio.com/media/images/hero-image-mobile.jpg",
                              "geoCoordinates": "36.1156° N, 115.1723° W",
                              "ticketPricing": "Free",
                              "timeToTravel": "1-2 hours"
                            },
                            {
                              "placeName": "Fountains of Bellagio",
                              "placeDetails": "A spectacular water show with music and lights.",
                              "placeImageUrl": "https://www.bellagio.com/media/images/hero-image-mobile.jpg",
                              "geoCoordinates": "36.1156° N, 115.1723° W",
                              "ticketPricing": "Free",
                              "timeToTravel": "30-45 minutes"
                            },
                            {
                              "placeName": "The Strip",
                              "placeDetails": "A world-famous street lined with casinos, hotels, restaurants, and entertainment venues.",
                              "placeImageUrl": "https://www.visitlasvegas.com/media/images/hero-image-mobile.jpg",
                              "geoCoordinates": "36.1146° N, 115.1725° W",
                              "ticketPricing": "Free",
                              "timeToTravel": "Evening"
                            }
                          ]
                        },
                        "day3": {
                          "bestTime": "Morning",
                          "plan": [
                            {
                              "placeName": "Red Rock Canyon National Conservation Area",
                              "placeDetails": "A scenic desert landscape with hiking trails, rock formations, and panoramic views.",
                              "placeImageUrl": "https://www.nps.gov/redr/planyourvisit/media/Red_Rock_Canyon_Nevada_National_Conservation_Area.jpg",
                              "geoCoordinates": "36.0539° N, 115.2459° W",
                              "ticketPricing": "$15 per vehicle",
                              "timeToTravel": "3-4 hours"
                            },
                            {
                              "placeName": "Hoover Dam",
                              "placeDetails": "A historic dam on the Colorado River, offering tours and scenic views.",
                              "placeImageUrl": "https://www.nps.gov/hove/planyourvisit/media/Hoover_Dam.jpg",
                              "geoCoordinates": "36.0059° N, 114.9979° W",
                              "ticketPricing": "$30 per person",
                              "timeToTravel": "2-3 hours"
                            }
                          ]
                        }
                      }
                    }
                    ```
                    """)
                ]
            )
        ])
        
        func sendMessage(_ message: String) async throws -> GenerateContentResponse {
            try await chat.sendMessage(message)
        }
        
        
    }
}

