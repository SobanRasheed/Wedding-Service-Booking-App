class AppConstants {
  // App Info
  static const String appName = 'Shaadi Kro';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String profilesCollection = 'profiles';
  static const String matchesCollection = 'matches';
  static const String messagesCollection = 'messages';
  static const String chatsCollection = 'chats';
  
  // Storage Paths
  static const String profilePicturesPath = 'profile_pictures';
  static const String documentsPath = 'documents';
  
  // Routes
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String searchRoute = '/search';
  static const String profileRoute = '/profile';
  static const String matchesRoute = '/matches';
  static const String chatRoute = '/chat';
  static const String settingsRoute = '/settings';
  static const String editProfileRoute = '/edit-profile';
  
  // Profile Categories
  static const List<String> genders = ['Male', 'Female'];
  static const List<String> maritalStatuses = [
    'Never Married',
    'Divorced',
    'Widowed',
    'Awaiting Divorce'
  ];
  static const List<String> religions = [
    'Islam',
    'Christianity',
    'Hinduism',
    'Sikhism',
    'Buddhism',
    'Other'
  ];
  static const List<String> sects = [
    'Sunni',
    'Shia',
    'Ahmadi',
    'Other'
  ];
  
  // Search Filters
  static const int minAge = 18;
  static const int maxAge = 60;
  static const List<int> ageRange = List.generate(43, (i) => i + 18);
  
  // Premium Features
  static const String premiumFeatureContact = 'View Contact Information';
  static const String premiumFeatureChat = 'Unlimited Chat';
  static const String premiumFeatureFeatured = 'Featured Profile';
  
  // Messages
  static const String welcomeMessage = 'Welcome to Shaadi Kro!';
  static const String loginSuccess = 'Login successful!';
  static const String registrationSuccess = 'Registration successful!';
  static const String profileUpdated = 'Profile updated successfully!';
  static const String matchSuccess = 'It\'s a Match!';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxBioLength = 500;
  static const int maxPhotos = 6;
}
