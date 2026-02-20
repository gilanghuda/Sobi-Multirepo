import '../../domain/entities/ahli_entity.dart';

class AhliModel {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String gender;
  final String avatar;
  final bool verified;
  final String userRole;
  final String createdAt;
  final String updatedAt;
  final String price;
  final String openTime;
  final String category;
  final String rating;

  AhliModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.avatar,
    required this.verified,
    required this.userRole,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
    required this.openTime,
    required this.category,
    required this.rating,
  });

  factory AhliModel.fromJson(Map<String, dynamic> json) {
    return AhliModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      gender: json['gender'] ?? '',
      avatar: json['avatar']?.toString() ?? '',
      verified: json['verified'] ?? false,
      userRole: json['user_role'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      price: json['price']?.toString() ?? '20000', // dummy jika null
      openTime: json['open_time'] ?? '14.00-14.20', // dummy jika null
      category: json['category'] ?? 'Ahli Agama', // dummy jika null
      rating: json['rating']?.toString() ?? '4.6', // dummy jika null
    );
  }

  AhliEntity toEntity() {
    return AhliEntity(
      id: id,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      gender: gender,
      avatar: avatar,
      verified: verified,
      userRole: userRole,
      createdAt: createdAt,
      updatedAt: updatedAt,
      price: price,
      openTime: openTime,
      category: category,
      rating: rating,
    );
  }
}
