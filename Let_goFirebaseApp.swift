//
//  Let_goFirebaseApp.swift
//  Let'goFirebase
//
//  Created by Harmeet Singh on 11/08/24.
//



import SwiftUI
import Firebase
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      if let apikey = ProcessInfo.processInfo.environment["GOOGLE_PLACES_KEY"] {
          GMSPlacesClient.provideAPIKey(apikey)
          print("Google Places API key successfully provided.")
      } else {
          print("Google Places API key not found.")
      }

    print("Configured Firebase")
    return true
  }
    
}



@main
struct Let_goFirebaseApp: App {
    @StateObject private var tripData = TripData()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tripData)
        }
    }
}

