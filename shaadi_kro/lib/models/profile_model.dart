import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String gender;
  final String maritalStatus;
  final String religion;
  final String sect;
  final String height;
  final String education;
  final String profession;
  final String income;
  final String city;
  final String country;
  final String bio;
  final List<String> photoUrls;
  final String? contactNumber;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.religion,
    required this.sect,
    required this.height,
    required this.education,
    required this.profession,
    required this.income,
    required this.city,
    required this.country,
    required this.bio,
    required this.photoUrls,
    this.contactNumber,
    this.isPremium = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProfileModel(
      id: id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      maritalStatus: data['maritalStatus'] ?? '',
      religion: data['religion'] ?? '',
      sect: data['sect'] ?? '',
      height: data['height'] ?? '',
      education: data['education'] ?? '',
      profession: data['profession'] ?? '',
      income: data['income'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      bio: data['bio'] ?? '',
      photoUrls: List<String>.from(data['photoUrls'] ?? []),
      contactNumber: data['contactNumber'],
      isPremium: data['isPremium'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender,
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
      'photoUrls': photoUrls,
      'contactNumber': contactNumber,
      'isPremium': isPremium,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
