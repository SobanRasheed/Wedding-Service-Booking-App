DEPLOYMENT GUIDE - Shaadi Kro App (Semester Project)
=====================================================

MVC ARCHITECTURE IMPLEMENTATION
-------------------------------

This project follows the MVC (Model-View-Controller) architectural pattern.
See MVC_ARCHITECTURE.md for detailed documentation.

Project Structure:
- models/      → Data structures (ProfileModel, etc.)
- views/       → UI layer (screens/, widgets/)
- controllers/ → Business logic (AuthController, ProfileController)
- services/    → Data access (AuthService, FirestoreService)
- providers/   → State management bridge

IMPORTANT: This is a SEMESTER PROJECT and is NOT intended for Google Play Store deployment.
Build APK files for LOCAL TESTING AND DEMONSTRATION PURPOSES ONLY.

PREREQUISITES
-------------
1. Flutter SDK installed (3.0.0+)
2. Android Studio or VS Code
3. Firebase Project created
4. Android device or emulator for testing

NOTE: No Google Play Console account or keystore signing required for semester project!

STEP 1: FIREBASE SETUP
----------------------

1. Create Firebase Project
   - Go to https://console.firebase.google.com/
   - Click "Add project"
   - Name: "Shaadi Kro"
   - Enable Google Analytics (recommended)
   - Click "Create project"

2. Add Android App to Firebase
   - In Firebase Console, click "Add app" > Android
   - Package name: com.example.shaadi_kro
   - App nickname: Shaadi Kro
   - Download google-services.json
   - Place it in: android/app/google-services.json

3. Enable Firebase Services
   
   a. Authentication:
      - Go to Authentication > Sign-in method
      - Enable Email/Password
      - Enable Google Sign-in
   
   b. Firestore Database:
      - Go to Firestore Database
      - Click "Create database"
      - Choose "Production mode"
      - Select location (us-central recommended)
   
   c. Storage:
      - Go to Storage
      - Click "Get started"
      - Use default security rules

4. Update Firestore Security Rules
   - Go to Firestore Database > Rules
   - Replace with the rules from README.md

5. Update Storage Security Rules
   - Go to Storage > Rules
   - Replace with:
   
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /profile_pictures/{userId}/{allPaths=**} {
         allow read: if true;
         allow write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }

STEP 2: ANDROID CONFIGURATION
------------------------------

1. Update android/app/build.gradle

   android {
       compileSdkVersion 34
       
       defaultConfig {
           applicationId "com.example.shaadi_kro"
           minSdkVersion 21
           targetSdkVersion 34
           versionCode 1
           versionName "1.0.0"
           multiDexEnabled true
       }
       
       buildTypes {
           release {
               signingConfig signingConfigs.debug
               minifyEnabled true
               proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
           }
       }
   }

   dependencies {
       // Add at the bottom
       implementation platform('com.google.firebase:firebase-bom:32.7.0')
       implementation 'com.google.firebase:firebase-analytics'
   }

2. Update android/build.gradle

   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }

3. Update android/settings.gradle

   dependencyResolutionManagement {
       repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
   }

STEP 3: GENERATE KEYSTORE (OPTIONAL - SKIP FOR SEMESTER PROJECT)
-----------------------------------------------------------------

NOTE: For semester project, you can SKIP this step entirely!
      The debug signing configuration is sufficient for testing and demonstration.

If you still want to generate a keystore for learning purposes:

1. Generate Upload Key
   
   On Mac/Linux:
   ```bash
   keytool -genkey -v -keystore ~/shaadi-kro-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias shaadi_kro
   ```
   
   On Windows:
   ```cmd
   keytool -genkey -v -keystore %USERPROFILE%\shaadi-kro-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias shaadi_kro
   ```

2. Backup your keystore securely! You'll need it for every update.

STEP 4: CONFIGURE SIGNING (OPTIONAL - SKIP FOR SEMESTER PROJECT)
-----------------------------------------------------------------

NOTE: Skip this step for semester project!
      Your app will use the default debug signing which works perfectly for testing.

If you completed Step 3 and want to configure signing:

1. Create android/key.properties (DO NOT COMMIT TO GIT)

   storePassword=<your-store-password>
   keyPassword=<your-key-password>
   keyAlias=shaadi_kro
   storeFile=/absolute/path/to/shaadi-kro-key.jks

2. Update android/app/build.gradle signing config

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
               proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
           }
       }
   }

STEP 5: UPDATE APP METADATA
----------------------------

1. Update pubspec.yaml version
   version: 1.0.0+1

2. Update app icon
   
   Add to pubspec.yaml:
   dev_dependencies:
     flutter_launcher_icons: ^0.13.1
   
   Create flutter_launcher_icons.yaml:
   flutter_launcher_icons:
     android: true
     image_path: "assets/images/icon.png"
   
   Run:
   flutter pub get
   dart run flutter_launcher_icons

3. Update app name in android/app/src/main/AndroidManifest.xml
   <application android:label="Shaadi Kro" ...>

STEP 6: BUILD RELEASE APK FOR TESTING
--------------------------------------

1. Clean and get dependencies
   ```bash
   flutter clean
   flutter pub get
   ```

2. Build Debug APK (for development testing)
   ```bash
   flutter build apk --debug
   ```
   Output: build/app/outputs/flutter-apk/app-debug.apk
   
   OR

3. Build Release APK (for final demo/presentation)
   ```bash
   flutter build apk --release
   ```
   Output: build/app/outputs/flutter-apk/app-release.apk

4. Install on Device/Emulator
   - Connect your Android device via USB (enable USB debugging)
   - Or start an Android emulator from Android Studio
   - Run: `flutter run`
   - Or manually install the APK: `adb install build/app/outputs/flutter-apk/app-release.apk`

NOTE: For semester project, you do NOT need to build App Bundle (.aab) or upload to Play Store!

STEP 7: TESTING & DEMONSTRATION
--------------------------------

1. Test on Emulator
   - Open Android Studio
   - Go to AVD Manager
   - Create/start a virtual device
   - Run: `flutter run`

2. Test on Physical Device
   - Enable Developer Options on your Android phone
   - Enable USB Debugging
   - Connect via USB
   - Run: `flutter run`

3. Share APK with Instructor/Classmates
   - Send the app-release.apk file
   - They can install it manually on their devices
   - No Play Store needed!

4. Prepare for Demo/Presentation
   - Test all features beforehand
   - Ensure Firebase is working
   - Have backup screenshots/videos ready

OPTIONAL: If you want to distribute to multiple testers without Play Store:
- Use Firebase App Distribution (free for up to 10,000 app installations)
- Or simply share the APK file directly

TROUBLESHOOTING
---------------

Common Issues:

1. Build fails with "Google services not found"
   - Ensure google-services.json is in android/app/
   - Check package name matches

2. APK too large
   - This is normal for Flutter apps
   - For semester project, size doesn't matter

3. App crashes on startup
   - Check Firebase configuration
   - Ensure internet connection
   - Check logcat for errors: `adb logcat`

4. Firebase connection issues
   - Check internet permissions in AndroidManifest.xml
   - Verify google-services.json configuration

CONTACT SUPPORT
---------------
For additional help:
- Flutter Docs: https://docs.flutter.dev
- Firebase Docs: https://firebase.google.com/docs
- Your course instructor/professor

Good luck with your semester project presentation! 🎓🚀
