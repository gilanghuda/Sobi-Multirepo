// Tambahkan field sesuai kebutuhan jika API sudah mendukung get user.

class UserModel {
  final String id;
  final String? username;
  final String email;
  final String? gender;
  final int? avatar;
  final bool? verified;
  final String? userRole;
  final String? phoneNumber;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    this.username,
    required this.email,
    this.gender,
    this.avatar,
    this.verified,
    this.userRole,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'],
      email: json['email'] ?? '',
      gender: json['gender'],
      avatar:
          json['avatar'] is int
              ? json['avatar']
              : int.tryParse(json['avatar']?.toString() ?? ''),
      verified: json['verified'],
      userRole: json['user_role'],
      phoneNumber: json['phone_number'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'gender': gender,
      'avatar': avatar,
      'verified': verified,
      'user_role': userRole,
      'phone_number': phoneNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, email: $email, gender: $gender, avatar: $avatar, verified: $verified, user_role: $userRole, phone_number: $phoneNumber, created_at: $createdAt, updated_at: $updatedAt}';
  }
}
