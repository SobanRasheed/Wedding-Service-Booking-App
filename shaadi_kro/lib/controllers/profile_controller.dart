import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/firestore_service.dart';

/// Controller class that handles business logic for profile operations
/// Following MVC Architecture Pattern
class ProfileController {
  final FirestoreService _firestoreService = FirestoreService();

  /// Create a new user profile
  Future<ProfileModel> createProfile({
    required String userId,
    required String name,
    required int age,
    required String gender,
    required String maritalStatus,
    required String religion,
    required String sect,
    required String height,
    required String education,
    required String profession,
    required String income,
    required String city,
    required String country,
    required String bio,
    List<String>? photoUrls,
    String? contactNumber,
  }) async {
    try {
      debugPrint('Creating profile for user: $userId');
      
      final profile = await _firestoreService.createUserProfile(
        userId: userId,
        name: name,
        gender: gender,
        email: '', // Email is stored in Firebase Auth
      );
      
      // Update additional profile details
      await _firestoreService.updateUserProfile(userId, {
        'age': age,
        'maritalStatus': maritalStatus,
        'religion': religion,
        'sect': sect,
        'height': height,
        'education': education,
        'profession': profession,
        'income': income,
        'city': city,
        'country': country,
        'bio': bio,
        'photoUrls': photoUrls ?? [],
        'contactNumber': contactNumber,
      });
      
      final updatedProfile = await _firestoreService.getUserProfile(userId);
      
      if (updatedProfile == null) {
        throw Exception('Failed to retrieve created profile');
      }
      
      debugPrint('Profile created successfully');
      return updatedProfile;
    } catch (e) {
      debugPrint('Create profile error: $e');
      rethrow;
    }
  }

  /// Get user profile by ID
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      debugPrint('Fetching profile for user: $userId');
      return await _firestoreService.getUserProfile(userId);
    } catch (e) {
      debugPrint('Get profile error: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateProfile(String userId, Map<String, dynamic> updates) async {
    try {
      debugPrint('Updating profile for user: $userId');
      await _firestoreService.updateUserProfile(userId, updates);
      debugPrint('Profile updated successfully');
    } catch (e) {
      debugPrint('Update profile error: $e');
      rethrow;
    }
  }

  /// Delete user profile
  Future<void> deleteProfile(String userId) async {
    try {
      debugPrint('Deleting profile for user: $userId');
      await _firestoreService.deleteUserProfile(userId);
      debugPrint('Profile deleted successfully');
    } catch (e) {
      debugPrint('Delete profile error: $e');
      rethrow;
    }
  }

  /// Upload profile picture
  Future<String> uploadProfilePicture(String userId, String imagePath) async {
    try {
      debugPrint('Uploading profile picture for user: $userId');
      final url = await _firestoreService.uploadProfilePicture(userId, imagePath);
      debugPrint('Profile picture uploaded: $url');
      return url;
    } catch (e) {
      debugPrint('Upload profile picture error: $e');
      rethrow;
    }
  }

  /// Get all profiles (for browsing/matching)
  Stream<List<ProfileModel>> getAllProfiles() {
    debugPrint('Streaming all profiles');
    return _firestoreService.getAllProfiles();
  }

  /// Search profiles by filters
  Stream<List<ProfileModel>> searchProfiles({
    String? gender,
    int? minAge,
    int? maxAge,
    String? religion,
    String? city,
  }) {
    debugPrint('Searching profiles with filters');
    // TODO: Implement search functionality in FirestoreService
    return _firestoreService.getAllProfiles();
  }

  /// Like/Interest in a profile
  Future<void> sendInterest(String fromUserId, String toUserId) async {
    try {
      debugPrint('Sending interest from $fromUserId to $toUserId');
      await _firestoreService.sendLike(fromUserId, toUserId);
    } catch (e) {
      debugPrint('Send interest error: $e');
      rethrow;
    }
  }

  /// Get matched profiles
  Stream<List<ProfileModel>> getMatches(String userId) {
    debugPrint('Getting matches for user: $userId');
    // TODO: Implement matching logic - return matched profiles
    return _firestoreService.getAllProfiles();
  }
}
