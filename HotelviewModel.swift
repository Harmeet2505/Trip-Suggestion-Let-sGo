//
//  HotelviewModel.swift
//  Trip Suggestion Let'sGo
//
//  Created by Harmeet Singh on 21/09/24.


//

import SwiftUI
import Combine

class PlaceImageViewModel: ObservableObject {
    @Published var placeImage: UIImage? = nil
    private var cancellable: AnyCancellable?
    
    let googleAPIKey = "YOUR_GOOGLE_API_KEY"
    
    // Function to fetch place details (to get photo_reference)
    func fetchPlaceDetails(placeId: String) {
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId)&fields=photos&key=\(googleAPIKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PlaceDetailsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching place details: \(error)")
                }
            }, receiveValue: { [weak self] response in
                if let photoReference = response.result.photos.first?.photo_reference {
                    self?.fetchPlacePhoto(photoReference: photoReference)
                }
            })
    }
    
    // Function to fetch the image using photo_reference
    func fetchPlacePhoto(photoReference: String) {
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoReference)&key=\(googleAPIKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid Photo URL")
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.placeImage = image
            }
    }
}
struct PlaceDetailsResponse: Codable {
    let result: PlaceResult
}

struct PlaceResult: Codable {
    let photos: [PlacePhoto]
}

struct PlacePhoto: Codable {
    let photo_reference: String
}

