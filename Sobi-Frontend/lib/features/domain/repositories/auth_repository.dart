import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<String> signUp({
    required String email,
    required String username,
    required String phone,
    required String password,
  });

  Future<String> verifyOtp({required String email, required String otp});

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  });

  Future<String?> getToken();

  Future<UserModel> getUser();

  Future<String> logout();

  Future<String> updateUserProfile({
    required String username,
    required String gender,
    required String phoneNumber,
    required int avatar,
  });
}
