# MVC Architecture - Shaadi Kro App

## Overview

This project follows the **MVC (Model-View-Controller)** architectural pattern to ensure clean separation of concerns, maintainability, and scalability.

```
lib/
├── main.dart                    # App entry point
├── models/                      # MODEL LAYER
│   └── profile_model.dart       # Data models representing business entities
├── views/                       # VIEW LAYER (Screens & Widgets)
│   ├── screens/                 # Full-screen views
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── home_screen.dart
│   └── widgets/                 # Reusable UI components
│       ├── bottom_nav_bar.dart
│       └── profile_card.dart
├── controllers/                 # CONTROLLER LAYER
│   ├── auth_controller.dart     # Handles authentication business logic
│   └── profile_controller.dart  # Handles profile operations business logic
├── services/                    # Service Layer (Data Access)
│   ├── auth_service.dart        # Firebase Authentication operations
│   └── firestore_service.dart   # Firestore database operations
├── providers/                   # State Management (Provider package)
│   └── auth_provider.dart       # Connects Controllers to Views
└── utils/                       # Utilities
    ├── colors.dart
    ├── constants.dart
    └── theme.dart
```

## MVC Components

### 1. MODEL LAYER (`lib/models/`)

**Purpose**: Represents data structures and business entities.

**Files**:
- `profile_model.dart` - User profile data model

**Responsibilities**:
- Define data structures
- Handle serialization/deserialization (to/from Firestore)
- Business entity representation

**Example**:
```dart
class ProfileModel {
  final String id;
  final String userId;
  final String name;
  final int age;
  // ... other fields
  
  ProfileModel({required this.id, required this.userId, ...});
  
  factory ProfileModel.fromFirestore(Map<String, dynamic> data, String id) {
    // Convert Firestore data to model
  }
  
  Map<String, dynamic> toFirestore() {
    // Convert model to Firestore data
  }
}
```

---

### 2. VIEW LAYER (`lib/screens/` and `lib/widgets/`)

**Purpose**: Handles UI presentation and user interaction.

**Files**:
- **Screens** (Full-page views):
  - `splash_screen.dart` - App loading screen
  - `login_screen.dart` - User login UI
  - `register_screen.dart` - User registration UI
  - `home_screen.dart` - Main app interface

- **Widgets** (Reusable components):
  - `bottom_nav_bar.dart` - Navigation bar component
  - `profile_card.dart` - Profile display card

**Responsibilities**:
- Display data to users
- Capture user input
- Trigger controller actions
- Update UI based on state changes

**Key Principle**: Views should NOT contain business logic. They only:
- Display data from models
- Call controller methods on user actions
- Show loading states and errors

**Example**:
```dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authController = AuthController();
  
  Future<void> _handleLogin() async {
    try {
      // Call controller method
      final user = await _authController.signInWithEmail(email, password);
      // Navigate on success
      Navigator.pushReplacement(context, ...);
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(...);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Build UI only
    return Scaffold(...);
  }
}
```

---

### 3. CONTROLLER LAYER (`lib/controllers/`)

**Purpose**: Contains business logic and acts as intermediary between Views and Models/Services.

**Files**:
- `auth_controller.dart` - Authentication business logic
- `profile_controller.dart` - Profile management business logic

**Responsibilities**:
- Process user input from views
- Interact with models and services
- Implement business rules
- Handle error handling and validation
- Return processed data to views

**Key Principle**: Controllers contain ALL business logic. They:
- Receive requests from views
- Validate input
- Call appropriate services
- Return results to views
- Handle errors

**Example**:
```dart
class AuthController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  
  /// Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }
      
      // Call service
      final user = await _authService.signInWithEmail(email, password);
      
      // Log success
      debugPrint('User signed in: ${user?.email}');
      
      return user;
    } catch (e) {
      // Handle and log error
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }
}
```

---

### 4. SERVICE LAYER (`lib/services/`)

**Purpose**: Handles data access and external API calls.

**Files**:
- `auth_service.dart` - Firebase Authentication API calls
- `firestore_service.dart` - Firestore database operations (text data only)

**Responsibilities**:
- Direct interaction with Firebase services
- CRUD operations for text-based data
- Data persistence in Firestore
- NO image/video storage (simplified for semester project)

**Key Principle**: Services are dumb data access layers. They:
- Execute Firebase operations
- Return raw data
- Don't contain business logic
- Are called by controllers

**Note**: This project does NOT use Firebase Storage. All profile data is text-based stored in Firestore only. No images or videos are uploaded from user devices.

**Example**:
```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }
}
```

---

## Data Flow

```
┌─────────────┐
│    VIEW     │  (User clicks login button)
│  (Screen)   │
└──────┬──────┘
       │ Calls method
       ▼
┌─────────────┐
│  CONTROLLER │  (Validates input, applies business logic)
└──────┬──────┘
       │ Requests data
       ▼
┌─────────────┐
│   SERVICE   │  (Calls Firebase API)
└──────┬──────┘
       │ Returns data
       ▼
┌─────────────┐
│    MODEL    │  (Data structure)
└──────┬──────┘
       │ Returns up the chain
       ▼
┌─────────────┐
│  CONTROLLER │  (Processes result)
└──────┬──────┘
       │ Returns to view
       ▼
┌─────────────┐
│    VIEW     │  (Updates UI / Navigates)
└─────────────┘
```

---

## Benefits of MVC in This Project

1. **Separation of Concerns**
   - UI code is separate from business logic
   - Easy to locate and modify specific functionality

2. **Testability**
   - Controllers can be unit tested independently
   - Services can be mocked for testing

3. **Maintainability**
   - Changes to UI don't affect business logic
   - Changes to Firebase implementation don't affect views

4. **Reusability**
   - Services can be used by multiple controllers
   - Widgets can be reused across screens

5. **Scalability**
   - Easy to add new features
   - Clear structure for team collaboration

---

## State Management

This project uses the **Provider** package for state management, which works seamlessly with MVC:

- **Providers** act as a bridge between Controllers and Views
- They notify views when data changes
- Enable reactive UI updates

**Example**:
```dart
// Provider connects Controller to View
class AuthProvider with ChangeNotifier {
  final AuthController _controller = AuthController();
  
  bool _isLoading = false;
  
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Notify views
    
    try {
      await _controller.signInWithEmail(email, password);
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

## Adding New Features

When adding a new feature, follow the MVC pattern:

1. **Model**: Create data model if needed (`lib/models/`)
2. **Service**: Add service methods for data access (`lib/services/`)
3. **Controller**: Create controller with business logic (`lib/controllers/`)
4. **View**: Create screens/widgets for UI (`lib/screens/`, `lib/widgets/`)
5. **Provider** (optional): Add provider for state management if needed

---

## Best Practices

✅ **DO**:
- Keep views thin (UI only)
- Put all business logic in controllers
- Use services only for data access
- Follow single responsibility principle
- Use models for data transfer

❌ **DON'T**:
- Put business logic in views
- Call services directly from views
- Mix UI code with business logic
- Create god classes that do everything

---

## For Semester Project Presentation

When presenting this project:

1. **Explain the architecture**: Show how MVC separates concerns
2. **Demonstrate data flow**: Trace a user action through all layers
3. **Highlight benefits**: Explain why MVC makes the code maintainable
4. **Show code organization**: Point out the clear folder structure
5. **Discuss scalability**: Explain how new features can be added easily

This architecture demonstrates professional software engineering practices! 🎓
