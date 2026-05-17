import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/profile_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection references
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _profiles => _firestore.collection('profiles');
  CollectionReference get _matches => _firestore.collection('matches');
  CollectionReference get _messages => _firestore.collection('messages');
  CollectionReference get _chats => _firestore.collection('chats');

  // User Profile Operations
  
  // Create user profile
  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String gender,
    required String email,
  }) async {
    try {
      final profileData = {
        'userId': userId,
        'name': name,
        'age': 0,
        'gender': gender,
        'maritalStatus': '',
        'religion': '',
        'sect': '',
        'height': '',
        'education': '',
        'profession': '',
        'income': '',
        'city': '',
        'country': '',
        'bio': '',
        'photoUrls': [],
        'contactNumber': null,
        'isPremium': false,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _profiles.doc(userId).set(profileData);
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<ProfileModel?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _profiles.doc(userId).get();
      
      if (doc.exists) {
        return ProfileModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      profileData['updatedAt'] = FieldValue.serverTimestamp();
      await _profiles.doc(userId).update(profileData);
    } catch (e) {
      rethrow;
    }
  }

  // Delete user profile
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _profiles.doc(userId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Search profiles with filters
  Future<List<ProfileModel>> searchProfiles({
    String? gender,
    int? minAge,
    int? maxAge,
    String? religion,
    String? city,
    String? country,
  }) async {
    try {
      Query query = _profiles;

      if (gender != null && gender.isNotEmpty) {
        query = query.where('gender', isEqualTo: gender);
      }

      if (minAge != null) {
        query = query.where('age', isGreaterThanOrEqualTo: minAge);
      }

      if (maxAge != null) {
        query = query.where('age', isLessThanOrEqualTo: maxAge);
      }

      if (religion != null && religion.isNotEmpty) {
        query = query.where('religion', isEqualTo: religion);
      }

      if (city != null && city.isNotEmpty) {
        query = query.where('city', isEqualTo: city);
      }

      final snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        return ProfileModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get all profiles (for home screen featured profiles)
  Future<List<ProfileModel>> getAllProfiles({int limit = 20}) async {
    try {
      final snapshot = await _profiles
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        return ProfileModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Match Operations
  
  // Create a like/interest
  Future<void> sendLike(String fromUserId, String toUserId) async {
    try {
      final matchData = {
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _matches.add(matchData);
    } catch (e) {
      rethrow;
    }
  }

  // Accept a like (create mutual match)
  Future<void> acceptLike(String fromUserId, String toUserId) async {
    try {
      // Update the pending match
      final querySnapshot = await _matches
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: toUserId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'status': 'matched'});
      }

      // Create reverse match
      final matchData = {
        'fromUserId': toUserId,
        'toUserId': fromUserId,
        'status': 'matched',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _matches.add(matchData);
    } catch (e) {
      rethrow;
    }
  }

  // Get matches for a user
  Future<List<String>> getMatches(String userId) async {
    try {
      final snapshot = await _matches
          .where('toUserId', isEqualTo: userId)
          .where('status', isEqualTo: 'matched')
          .get();

      return snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['fromUserId'] as String)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Check if already liked
  Future<bool> hasLiked(String fromUserId, String toUserId) async {
    try {
      final snapshot = await _matches
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: toUserId)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  // Chat Operations
  
  // Send message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final messageData = {
        'chatId': chatId,
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      };

      await _messages.add(messageData);

      // Update chat last message
      await _chats.doc(chatId).set({
        'participants': [senderId, receiverId],
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  // Get messages for a chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _messages
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get chats for a user
  Stream<QuerySnapshot> getChats(String userId) {
    return _chats
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // Mark message as read
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _messages.doc(messageId).update({'isRead': true});
    } catch (e) {
      rethrow;
    }
  }

  // Storage Operations - Profile Pictures
  
  /// Upload profile picture to Firebase Storage
  Future<String> uploadProfilePicture(String userId, String imagePath) async {
    try {
      final file = File(imagePath);
      final ref = _storage.ref().child('profile_pictures').child(userId).child('profile.jpg');
      
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete profile picture
  Future<void> deleteProfilePicture(String userId) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child(userId).child('profile.jpg');
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all profiles as a stream
  Stream<List<ProfileModel>> getAllProfiles() {
    return _profiles
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProfileModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ))
            .toList());
  }
}
