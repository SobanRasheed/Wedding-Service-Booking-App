import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  
  User? _currentUser;
  ProfileModel? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  ProfileModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  // Email/Password Sign In
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentUser = await _authService.signInWithEmail(email, password);
      
      if (_currentUser != null) {
        _userProfile = await _firestoreService.getUserProfile(_currentUser!.uid);
      }

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Email/Password Sign Up
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String gender,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentUser = await _authService.signUpWithEmail(email, password);
      
      if (_currentUser != null) {
        // Create user profile
        await _firestoreService.createUserProfile(
          userId: _currentUser!.uid,
          name: name,
          gender: gender,
          email: email,
        );
        _userProfile = await _firestoreService.getUserProfile(_currentUser!.uid);
      }

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentUser = await _authService.signInWithGoogle();
      
      if (_currentUser != null) {
        // Check if profile exists, if not create one
        _userProfile = await _firestoreService.getUserProfile(_currentUser!.uid);
        if (_userProfile == null) {
          await _firestoreService.createUserProfile(
            userId: _currentUser!.uid,
            name: _currentUser!.displayName ?? '',
            gender: '', // Need to ask user
            email: _currentUser!.email ?? '',
          );
          _userProfile = await _firestoreService.getUserProfile(_currentUser!.uid);
        }
      }

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    _userProfile = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.resetPassword(email);

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update Profile
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_currentUser != null) {
        await _firestoreService.updateUserProfile(_currentUser!.uid, profileData);
        _userProfile = await _firestoreService.getUserProfile(_currentUser!.uid);
      }

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear Error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
