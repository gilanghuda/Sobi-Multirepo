import '../../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;
  VerifyOtp(this.repository);

  Future<String> call({required String email, required String otp}) {
    return repository.verifyOtp(email: email, otp: otp);
  }
}
