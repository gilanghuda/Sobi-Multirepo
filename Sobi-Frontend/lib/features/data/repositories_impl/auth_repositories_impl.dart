import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasources.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasources datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<String> signUp({
    required String email,
    required String username,
    required String phone,
    required String password,
  }) {
    return datasource.signup(
      email: email,
      username: username,
      phone: phone,
      password: password,
    );
  }

  @override
  Future<String> verifyOtp({required String email, required String otp}) {
    return datasource.verifyOtp(email: email, otp: otp);
  }

  @override
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) {
    return datasource.signin(email: email, password: password);
  }

  @override
  Future<String?> getToken() {
    return datasource.getToken();
  }

  @override
  Future<UserModel> getUser() {
    return datasource.getUser();
  }

  @override
  Future<String> logout() {
    return datasource.logout();
  }

  @override
  Future<String> updateUserProfile({
    required String username,
    required String gender,
    required String phoneNumber,
    required int avatar,
  }) {
    return datasource.updateUserProfile(
      username: username,
      gender: gender,
      phoneNumber: phoneNumber,
      avatar: avatar,
    );
  }
}
