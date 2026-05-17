# Project Structure for Shaadi Kro Flutter App

## Directory Structure
```
shaadi_kro/
├── android/                    # Android platform files
│   └── app/
│       └── src/
│           └── main/
│               ├── java/com/example/shaadi_kro/
│               └── res/        # Android resources
├── ios/                        # iOS platform files
├── lib/                        # Main Dart code
│   ├── main.dart              # App entry point
│   ├── models/                # Data models
│   │   ├── profile_model.dart
│   │   ├── user_model.dart
│   │   └── match_model.dart
│   ├── screens/               # App screens
│   │   ├── splash_screen.dart
│   │   ├── onboarding_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── home_screen.dart
│   │   ├── search_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── matches_screen.dart
│   │   ├── chat_screen.dart
│   │   ├── settings_screen.dart
│   │   └── edit_profile_screen.dart
│   ├── widgets/               # Reusable widgets
│   │   ├── custom_app_bar.dart
│   │   ├── profile_card.dart
│   │   ├── search_filter_widget.dart
│   │   ├── bottom_nav_bar.dart
│   │   └── loading_widget.dart
│   ├── services/              # Firebase and API services
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   └── storage_service.dart
│   ├── providers/             # State management
│   │   ├── auth_provider.dart
│   │   ├── profile_provider.dart
│   │   └── search_provider.dart
│   └── utils/                 # Utilities and constants
│       ├── constants.dart
│       ├── colors.dart
│       ├── theme.dart
│       └── validators.dart
├── assets/                     # Static assets
│   ├── images/                # Image files
│   └── fonts/                 # Custom fonts
├── test/                       # Test files
├── pubspec.yaml               # Dependencies
└── README.md                  # Documentation
```

## Key Features (Based on shadiyana.pk pattern)

### 1. Authentication Flow
- Splash Screen with logo
- Onboarding screens explaining features
- Login/Register with email, phone, or social login
- Profile creation wizard

### 2. Main Screens
- **Home Screen**: Featured profiles, success stories, quick search
- **Search Screen**: Advanced filters (age, location, religion, profession, etc.)
- **Profile Screen**: Detailed profile view with photos, details, contact info
- **Matches Screen**: Liked profiles, mutual matches
- **Chat Screen**: Messaging between matched users
- **Settings Screen**: Account settings, privacy, notifications

### 3. Firebase Backend
- **Authentication**: Email/Password, Phone, Google Sign-in
- **Firestore Database**: User profiles, matches, messages
- **Storage**: Profile pictures, documents
- **Cloud Functions**: Notifications, matching algorithm

### 4. UI/UX Pattern (Following shadiyana.pk)
- Color scheme: Pink/Purple gradient theme
- Card-based profile displays
- Bottom navigation bar
- Search filters in drawer or dedicated screen
- Success stories section
- Premium membership prompts

## File Descriptions

### Models
- `profile_model.dart`: Defines profile structure (name, age, location, photos, etc.)
- `user_model.dart`: User authentication and basic info
- `match_model.dart`: Match relationships and status

### Services
- `auth_service.dart`: Firebase authentication operations
- `firestore_service.dart`: Database CRUD operations
- `storage_service.dart`: File upload/download

### Providers
- `auth_provider.dart`: Authentication state management
- `profile_provider.dart`: Profile data management
- `search_provider.dart`: Search filter state

### Utils
- `constants.dart`: App-wide constants
- `colors.dart`: Color palette definition
- `theme.dart`: ThemeData configuration
- `validators.dart`: Input validation functions
