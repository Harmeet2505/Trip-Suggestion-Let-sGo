//
//  LikedTripViewModel.swift
//  Trip Suggestion Let'sGo
//
//  Created by Harmeet Singh on 17/09/24.
//

import Foundation
import FirebaseFirestore

class LikedTripsViewModel: ObservableObject {
    @Published var likedTrips: [LikedTrip] = []
    
    private var db = Firestore.firestore()
    
    func fetchLikedTrips() {
        db.collection("AiTrips").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching liked trips: \(error)")
                return
            }
            
            self.likedTrips = snapshot?.documents.compactMap { document in
                let data = document.data()
                guard let destinationName = data["destinatio"] as? String,
                      let tripDuration = data["tripDuration"] as? String,
                      let tripCompanion = data["tripCompanion"] as? String,
                      let hotelImageURL = data["hotelImageURL"] as? String else {
                    return nil
                }
                return LikedTrip(id: document.documentID, destinationName: destinationName, tripDuration: tripDuration, tripCompanion: tripCompanion, hotelImageURL: hotelImageURL)
            } ?? []
        }
    }
}
