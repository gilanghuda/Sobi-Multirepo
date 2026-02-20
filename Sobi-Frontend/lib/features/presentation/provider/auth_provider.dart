import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sobi/features/presentation/router/app_router.dart';
import 'dart:convert';
import '../../data/models/user_model.dart';
import '../../data/datasources/auth_datasources.dart';
import '../../domain/usecases/auth/sign_in.dart';
import '../../domain/usecases/auth/sign_up.dart';
import '../../domain/usecases/auth/verify_otp.dart';
import '../../domain/usecases/auth/logout.dart';
import '../../domain/usecases/user/get_user.dart';
import '../../domain/usecases/user/update_user.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;
  String? token;
  String? error;
  bool isLoading = false;

  final SignIn signInUsecase;
  final SignUp signUpUsecase;
  final VerifyOtp verifyOtpUsecase;
  final Logout logoutUsecase;
  final GetUser getUserUsecase;
  final UpdateUser updateUserUsecase;

  final AuthDatasources authDatasources = AuthDatasources();

  AuthProvider({
    required this.signInUsecase,
    required this.signUpUsecase,
    required this.verifyOtpUsecase,
    required this.logoutUsecase,
    required this.getUserUsecase,
    required this.updateUserUsecase,
  }) {
    _initUserFromCacheOrApi();
  }

  Future<void> _initUserFromCacheOrApi() async {
    final token = await authDatasources.getToken();
    if (token != null && token.isNotEmpty) {
      // Fetch user dari API dan update cache
      user = await authDatasources.fetchAndCacheUser();
      if (user == null) {
        // fallback ke cache jika API gagal
        user = await authDatasources.getCachedUser();
      }
      this.token = token;
      notifyListeners();
    } else {
      user = null;
      this.token = null;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final result = await signInUsecase(email: email, password: password);
      if (result['token'] != null) {
        token = result['token'];
        user = result['user'];
        error = null;
        await checkLoginStatus();
        notifyListeners();
      } else {
        // Ambil error dari backend jika ada
        if (result['error'] != null && result['error'].toString().isNotEmpty) {
          error = result['error'].toString();
        } else if (result['message'] != null &&
            result['message'].toString().isNotEmpty) {
          error = result['message'].toString();
        } else {
          error = 'Login gagal';
        }
        notifyListeners();
      }
    } catch (e) {
      // Coba parsing error dari Dio jika berbentuk response backend
      try {
        if (e is DioError && e.response?.data != null) {
          final data = e.response?.data;
          if (data is Map && data['error'] != null) {
            error = data['error'].toString();
          } else if (data is Map && data['message'] != null) {
            error = data['message'].toString();
          } else {
            error = e.toString();
          }
        } else {
          error = e.toString();
        }
      } catch (_) {
        error = e.toString();
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signUp(
    String email,
    String username,
    String phone,
    String password,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await signUpUsecase(
        email: email,
        username: username,
        phone: phone,
        password: password,
      );
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> verifyOtp(String email, String otp) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await verifyOtpUsecase(email: email, otp: otp);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      user = await authDatasources.fetchAndCacheUser();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await logoutUsecase();
      user = null;
      token = null;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserProfile({
    required String username,
    required String gender,
    required String phoneNumber,
    required int avatar,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final message = await updateUserUsecase.call(
        username: username,
        gender: gender,
        phoneNumber: phoneNumber,
        avatar: avatar,
      );
      print('[DEBUG updateUserProfile] result: $message');
      await fetchUser();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
