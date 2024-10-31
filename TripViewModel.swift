//
//  TripViewModel.swift
//  Trip Suggestion Let'sGo
//
//  Created by Harmeet Singh on 17/09/24.
//



import FirebaseFirestore
import Foundation

class TripViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    
    private var db = Firestore.firestore()
    
    func fetchTrips() {
        db.collection("AiTrips")
            .order(by: "createdAt", descending: true) 
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.trips = querySnapshot?.documents.compactMap {
                        try? $0.data(as: Trip.self)
                    } ?? []
                }
            }
    }
}
