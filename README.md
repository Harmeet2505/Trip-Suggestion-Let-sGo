# Trip Suggestion App

A personalized trip planning application built with SwiftUI, utilizing Firebase Firestore, Gemini API, and Google Places API to generate customized travel itineraries based on user preferences. The app offers real-time data management, secure authentication, and image fetching for hotels and places, creating a seamless travel planning experience for iOS users.

## Features

- **Personalized Itineraries**: Automatically generate tailored travel plans based on user inputs like budget, season, and destination.
- **Firebase Integration**: Secure user authentication and real-time data storage, making it easy to save and access trip details.
- **Google Places API Integration**: Dynamic fetching of location images for hotels and places based on geocoordinates.
- **Trip Saving Functionality**: Users can save their favorite trips to view later.
- **Clean and Responsive UI**: Designed with SwiftUI, offering a sleek and intuitive user interface.

## Tech Stack

- **SwiftUI**: For creating a responsive and dynamic user interface.
- **Firebase Firestore**: For backend data storage, real-time data management, and user authentication.
- **Google Places API**: For retrieving images and location details for hotels and places.
- **Gemini API**: For generating itineraries and hotel suggestions.

## Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/Harmeet2505/trip-suggestion-app.git
    cd trip-suggestion-app
    ```

2. **Open the project in Xcode**:
    ```bash
    open TripSuggestionApp.xcodeproj
    ```

3. **Set up Firebase**:
    - Create a Firebase project and add an iOS app to it.
    - Download the `GoogleService-Info.plist` file and add it to your project in Xcode.

4. **Configure the Google Places API**:
    - Obtain an API key from the Google Cloud Console.
    - Add the key to your environment variables as `GOOGLE_PLACES_KEY`.

5. **Add the Gemini API key**:
    - Add the key to your environment variables as `GEMINI_API`.

6. **Build and run the app**:
    - Ensure a simulator or iOS device is connected, then run the app from Xcode.

## Usage

- **Create a Profile**: Sign up or log in to start planning trips.
- **Generate Trip Plans**: Enter preferences, and the app will suggest trips with hotel and place recommendations.
- **View Trip Details**: Access trip details with images and itineraries fetched in real-time.
- **Save Trips**: Save your preferred trips to access them in the "Liked" view.
- **Edit Profile**: Manage your profile and view saved trips.
