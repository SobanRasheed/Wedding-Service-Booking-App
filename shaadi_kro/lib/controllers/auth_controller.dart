import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

/// Controller class that handles business logic between Views (Screens) and Models/Services
/// Following MVC Architecture Pattern
class AuthController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // Get current user
  User? get currentUser => _authService.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  /// Sign in with email and password
  /// Returns: User object on success, null on failure
  /// Throws: FirebaseAuthException on error
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final user = await _authService.signInWithEmail(email, password);
      
      if (user != null) {
        debugPrint('User signed in successfully: ${user.email}');
      }
      
      return user;
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  /// Sign up with email and password
  /// Returns: User object on success, null on failure
  /// Throws: FirebaseAuthException on error
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String gender,
  }) async {
    try {
      final user = await _authService.signUpWithEmail(email, password);
      
      if (user != null) {
        // Create user profile in Firestore
        await _firestoreService.createUserProfile(
          userId: user.uid,
          name: name,
          gender: gender,
          email: email,
        );
        debugPrint('User registered successfully: ${user.email}');
      }
      
      return user;
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  /// Sign in with Google
  /// Returns: User object on success, null on failure or user cancellation
  /// Throws: FirebaseAuthException on error
  Future<User?> signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      
      if (user != null) {
        debugPrint('Google sign-in successful: ${user.email}');
        
        // Check if profile exists, if not create one
        var profile = await _firestoreService.getUserProfile(user.uid);
        if (profile == null) {
          await _firestoreService.createUserProfile(
            userId: user.uid,
            name: user.displayName ?? '',
            gender: '', // Need to ask user later
            email: user.email ?? '',
          );
          debugPrint('New Google user profile created');
        }
      }
      
      return user;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  /// Reset password for given email
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      debugPrint('Password reset email sent to: $email');
    } catch (e) {
      debugPrint('Password reset error: $e');
      rethrow;
    }
  }

  /// Update user profile data
  Future<void> updateProfile(String userId, Map<String, dynamic> profileData) async {
    try {
      await _firestoreService.updateUserProfile(userId, profileData);
      debugPrint('Profile updated successfully for user: $userId');
    } catch (e) {
      debugPrint('Profile update error: $e');
      rethrow;
    }
  }

  /// Get user profile from Firestore
  Future<ProfileModel?> getUserProfile(String userId) async {
    try {
      return await _firestoreService.getUserProfile(userId);
    } catch (e) {
      debugPrint('Get profile error: $e');
      rethrow;
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      if (currentUser != null) {
        await _firestoreService.deleteUserProfile(currentUser!.uid);
        await _authService.deleteAccount();
        debugPrint('Account deleted successfully');
      }
    } catch (e) {
      debugPrint('Delete account error: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  bool get isLoggedIn => currentUser != null;

  /// Get current user's UID
  String? get currentUserId => currentUser?.uid;
}
