# Shaadi Kro - Flutter Matrimony App

A Flutter multi-screen Android app inspired by shadiyana.pk with Firebase backend.

## 📱 Features

- **User Authentication**: Email/Password and Google Sign-in
- **Profile Management**: Create, view, and edit user profiles
- **Search & Filters**: Advanced search with age, location, religion filters
- **Matching System**: Like profiles and create mutual matches
- **Real-time Chat**: Messaging between matched users
- **Premium Features**: Upgrade to unlock exclusive features
- **Success Stories**: View successful matches from the platform

## 🏗️ Project Structure

```
shaadi_kro/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   └── profile_model.dart
│   ├── screens/                  # App screens
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── home_screen.dart
│   ├── services/                 # Firebase services
│   │   ├── auth_service.dart
│   │   └── firestore_service.dart
│   ├── providers/                # State management
│   │   └── auth_provider.dart
│   ├── widgets/                  # Reusable widgets
│   │   ├── profile_card.dart
│   │   └── bottom_nav_bar.dart
│   └── utils/                    # Utilities
│       ├── colors.dart
│       ├── theme.dart
│       └── constants.dart
├── assets/                       # Images and fonts
├── android/                      # Android configuration
├── pubspec.yaml                  # Dependencies
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Firebase account
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd shaadi_kro
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   a. Go to [Firebase Console](https://console.firebase.google.com/)
   
   b. Create a new project named "Shaadi Kro"
   
   c. Add an Android app:
      - Package name: `com.example.shaadi_kro`
      - Download `google-services.json`
      - Place it in `android/app/google-services.json`
   
   d. Enable Firebase services:
      - **Authentication**: Enable Email/Password and Google Sign-in
      - **Firestore Database**: Create database in production mode
      - **Storage**: Enable for profile pictures
   
   e. Install Firebase CLI (optional):
      ```bash
      npm install -g firebase-tools
      firebase login
      ```

4. **Configure Android**
   
   Update `android/app/build.gradle`:
   ```gradle
   android {
       defaultConfig {
           applicationId "com.example.shaadi_kro"
           minSdkVersion 21
           targetSdkVersion 34
       }
   }
   ```

5. **Add placeholder assets**
   ```bash
   mkdir -p assets/images
   mkdir -p assets/fonts
   # Add your logo and custom font files here
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 🔥 Firebase Configuration

### Firestore Collections

1. **profiles**
   ```javascript
   {
     userId: string,
     name: string,
     age: number,
     gender: string,
     maritalStatus: string,
     religion: string,
     sect: string,
     height: string,
     education: string,
     profession: string,
     income: string,
     city: string,
     country: string,
     bio: string,
     photoUrls: array,
     contactNumber: string,
     isPremium: boolean,
     createdAt: timestamp,
     updatedAt: timestamp
   }
   ```

2. **matches**
   ```javascript
   {
     fromUserId: string,
     toUserId: string,
     status: string, // 'pending' or 'matched'
     createdAt: timestamp
   }
   ```

3. **messages**
   ```javascript
   {
     chatId: string,
     senderId: string,
     receiverId: string,
     message: string,
     timestamp: timestamp,
     isRead: boolean
   }
   ```

4. **chats**
   ```javascript
   {
     participants: array,
     lastMessage: string,
     lastMessageTime: timestamp,
     updatedAt: timestamp
   }
   ```

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /profiles/{profileId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    match /matches/{matchId} {
      allow read, write: if request.auth != null;
    }
    
    match /messages/{messageId} {
      allow read, write: if request.auth != null;
    }
    
    match /chats/{chatId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 📦 Dependencies

- **firebase_core**: Firebase initialization
- **firebase_auth**: User authentication
- **cloud_firestore**: Database
- **firebase_storage**: File storage
- **provider**: State management
- **google_fonts**: Custom fonts
- **cached_network_image**: Image caching
- **carousel_slider**: Image carousels
- **image_picker**: Photo selection
- **url_launcher**: Launch URLs

## 🎨 UI Design

The app follows the design pattern of shadiyana.pk with:

- **Color Scheme**: Pink (#E91E63) and Purple (#9C27B0) gradient
- **Typography**: Poppins font family
- **Components**: 
  - Card-based profile displays
  - Bottom navigation bar
  - Gradient headers
  - Premium badges
  - Success stories section

## 🛠️ Development

### Running in Debug Mode
```bash
flutter run --debug
```

### Building APK
```bash
flutter build apk --release
```

### Building App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

## 📤 Deployment

### Step-by-Step Deployment Guide

#### 1. Prepare for Release

a. **Update app version** in `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+build_number
```

b. **Update app icon**:
```bash
flutter pub add flutter_launcher_icons
```
Create `flutter_launcher_icons.yaml`:
```yaml
flutter_icons:
  android: true
  image_path: "assets/images/icon.png"
```
Run: `flutter pub run flutter_launcher_icons:main`

c. **Update app name** in `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Shaadi Kro"
    ...>
```

#### 2. Generate Keystore

```bash
keytool -genkey -v -keystore ~/shaadi-kro-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias shaadi_kro
```

#### 3. Configure Signing

Create `android/key.properties`:
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=shaadi_kro
storeFile=/path/to/shaadi-kro-key.jks
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### 4. Build Release APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

#### 5. Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release
```

Bundle location: `build/app/outputs/bundle/release/app-release.aab`

#### 6. Google Play Console Setup

a. Go to [Google Play Console](https://play.google.com/console/)

b. Create a new app

c. Fill in app details:
   - App name: Shaadi Kro
   - Short description
   - Full description
   - Screenshots (phone, tablet, 7-inch tablet)
   - Feature graphic
   - App icon
   - Privacy policy URL

d. Content rating questionnaire

e. Pricing and distribution

f. Upload the app bundle (`app-release.aab`)

g. Submit for review

#### 7. Firebase Production Setup

a. **Enable Production Mode** for Firestore

b. **Set up Cloud Functions** (optional):
```bash
npm install -g firebase-tools
firebase init functions
```

c. **Configure Firebase Storage Rules**:
```javascript
rules_version = '2';
storage.googleapis.com/{bucket} {
  match /profile_pictures/{userId}/{allPaths=**} {
    allow read: if true;
    allow write: if request.auth != null && request.auth.uid == userId;
  }
}
```

d. **Enable Firebase App Check** (recommended)

#### 8. Monitoring & Analytics

a. Enable **Firebase Analytics**

b. Set up **Firebase Crashlytics** for crash reporting

c. Monitor performance with **Firebase Performance Monitoring**

## 🔐 Security Best Practices

1. **Never commit sensitive files**:
   - `google-services.json` (add to .gitignore)
   - `key.properties`
   - Keystore files

2. **Use environment variables** for API keys

3. **Implement proper Firestore security rules**

4. **Enable App Check** to prevent unauthorized access

5. **Regular security audits**

## 📝 Additional Screens to Implement

The following screens are planned but not yet implemented:

- Search Screen with advanced filters
- Profile Detail Screen
- Matches Screen
- Chat Screen
- Settings Screen
- Edit Profile Screen
- Premium Subscription Screen
- Onboarding Screens

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## 📞 Support

For support, email support@shaadikro.com or open an issue in the repository.

---

**Note**: This app is inspired by shadiyana.pk but is a separate implementation with different branding.
