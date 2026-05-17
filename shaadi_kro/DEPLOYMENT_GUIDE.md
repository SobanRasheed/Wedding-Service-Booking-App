DEPLOYMENT GUIDE - Shaadi Kro App
===================================

This guide provides step-by-step instructions to deploy your Flutter app to Google Play Store.

PREREQUISITES
-------------
1. Flutter SDK installed (3.0.0+)
2. Android Studio or VS Code
3. Google Play Console Developer Account ($25 one-time fee)
4. Firebase Project created
5. Keystore file for signing

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

STEP 3: GENERATE KEYSTORE
--------------------------

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

STEP 4: CONFIGURE SIGNING
--------------------------

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

STEP 6: BUILD RELEASE
---------------------

1. Clean and get dependencies
   ```bash
   flutter clean
   flutter pub get
   ```

2. Build APK (for testing)
   ```bash
   flutter build apk --release
   ```
   Output: build/app/outputs/flutter-apk/app-release.apk

3. Build App Bundle (for Play Store - RECOMMENDED)
   ```bash
   flutter build appbundle --release
   ```
   Output: build/app/outputs/bundle/release/app-release.aab

STEP 7: GOOGLE PLAY CONSOLE SETUP
----------------------------------

1. Create Google Play Console Account
   - Go to https://play.google.com/console
   - Pay $25 registration fee
   - Complete developer profile

2. Create New App
   - Click "Create app"
   - App name: Shaadi Kro
   - Default language: English (United States)
   - App or game: App
   - Free or paid: Free (or Paid)
   - Accept policies

3. Set Up App Content
   
   a. Privacy Policy
      - Create a privacy policy page (use generator tools)
      - Host on website or use free hosting
      - Add URL in Play Console
   
   b. App Access
      - Select "All or some functionality is restricted"
      - Provide demo credentials if needed
   
   c. Ads
      - Select "No" if no ads
   
   d. Content Rating
      - Complete questionnaire
      - Expected rating: Teen or Mature
   
   e. Target Audience
      - Select age ranges
      - This is a dating app, so 18+
   
   f. News App
      - Select "No"
   
   g. COVID-19 Contact Tracing
      - Select "No"
   
   h. Data Safety
      - Complete data collection disclosure
      - Be honest about data collected

4. App Details
   
   a. Short Description (80 chars)
      "Find your perfect life partner with Shaadi Kro - trusted matrimony app"
   
   b. Full Description (4000 chars)
      Write detailed description highlighting features
   
   c. App Icon
      512x512 PNG, 32-bit
   
   d. Feature Graphic
      1024x500 PNG/JPEG
   
   e. Screenshots
      - Phone: At least 2 screenshots (1080x1920 or higher)
      - 7-inch tablet: Optional
      - 10-inch tablet: Optional
   
   f. Promotional Video (optional)
      YouTube URL

5. Pricing & Distribution
   - Select countries
   - Choose Free or Paid
   - Accept distribution agreement

6. Upload Release
   
   a. Go to Production
   b. Click "Create new release"
   c. Upload app-release.aab
   d. Add release notes
   e. Click "Next"
   f. Review and start rollout to production

STEP 8: POST-LAUNCH
-------------------

1. Monitor Performance
   - Check Play Console for crashes
   - Monitor user reviews
   - Track downloads

2. Firebase Monitoring
   - Enable Crashlytics
   - Set up Analytics events
   - Monitor performance

3. Updates
   - Increment versionCode and versionName
   - Build new release
   - Upload to Play Console

TROUBLESHOOTING
---------------

Common Issues:

1. Build fails with "Google services not found"
   - Ensure google-services.json is in android/app/
   - Check package name matches

2. APK too large
   - Use App Bundle instead of APK
   - Enable R8 shrinking
   - Optimize images

3. Rejected by Play Store
   - Read rejection reason carefully
   - Fix issues mentioned
   - Resubmit

4. Firebase connection issues
   - Check internet permissions in AndroidManifest.xml
   - Verify google-services.json configuration

CONTACT SUPPORT
---------------
For additional help:
- Flutter Docs: https://docs.flutter.dev
- Firebase Docs: https://firebase.google.com/docs
- Play Console Help: https://support.google.com/googleplay/android-developer

Good luck with your app launch! 🚀
