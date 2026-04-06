# Naricare - Menstrual Health Companion 🌙

Naricare is a premium, feature-rich menstrual health companion designed to empower users with tracking, insights, and healthcare resources. Built with **Flutter** and powered by a **Serverless Firebase Architecture**, it offers a seamless blend of aesthetic design and robust real-time data synchronization.


## ✨ Features

- **Period & Cycle Tracking**: Precision tracking with an intuitive calendar view powered by `table_calendar`.
- **Health Analytics**: Visual representation of health patterns and trends using `fl_chart`.
- **Resource Locator**: Integrated mapping to find nearby hospitals and clinics using `flutter_map`, `geolocator`, and the Overpass API.
- **On-Demand Wellness Shop**: Access to curated health and hygiene products with a secure checkout flow.
- **Multilingual Support**: Fully localized experience supporting English, Hindi, and Gujarati.
- **Real-Time Data Sync**: Powered by **Cloud Firestore**, ensuring your health data is encrypted and accessible across devices instantly.

## 🛠️ Tech Stack

### Frontend
- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **UI & Icons**: Google Fonts, Material Symbols, Cupertino Icons
- **Key Packages**: `table_calendar`, `fl_chart`, `flutter_map`, `geolocator`, `http`, `shared_preferences`

### Backend (Serverless)
- **Authentication**: [Firebase Auth](https://firebase.google.com/products/auth) (Email/Password)
- **Database**: [Cloud Firestore](https://firebase.google.com/products/firestore) (Document-based NoSQL)
- **Hosting**: Firebase Hosting (for web/distribution)

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.11.0 or higher)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- A Firebase Project (setup at [Firebase Console](https://console.firebase.google.com/))

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/naricare.git
   cd naricare
   ```

2. **Firebase Configuration**:
   - Initialize FlutterFire in the project:
     ```bash
     dart pub global activate flutterfire_cli
     flutterfire configure
     ```
   - This will generate the necessary `firebase_options.dart` file in your `lib` folder.

3. **Install Dependencies**:
   ```bash
   # Install Flutter packages
   flutter pub get
   ```

4. **Run the Application**:
   ```bash
   # Run on your preferred device
   flutter run
   ```

## 📂 Project Structure

```text
├── lib/                  # Flutter application source (l10n, models, providers, screens, services, widgets)
├── android/              # Android specific configuration
├── ios/                  # iOS specific configuration
├── assets/               # Project assets (images, logos)
├── test/                 # Unit and widget tests
├── firebase.json         # Firebase project configuration
├── pubspec.yaml          # Flutter dependencies and assets
└── README.md             # Project documentation
```

## 🛡️ License
Distributed under the MIT License. See `LICENSE` for more information.

---
*Built with ❤️ for a healthier tomorrow.*
