// Tambahkan field sesuai kebutuhan jika API sudah mendukung get user.

class User {
  final String id;
  final String username;
  final String email;
  final String gender;
  final int avatar; // Mengubah tipe menjadi int
  final bool verified;
  final String userRole;
  final String? phoneNumber; // Mengubah menjadi nullable
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.gender,
    required this.avatar, // Mengubah tipe menjadi int
    required this.verified,
    required this.userRole,
    this.phoneNumber, // Mengubah menjadi opsional
    required this.createdAt,
    required this.updatedAt,
  });
}
