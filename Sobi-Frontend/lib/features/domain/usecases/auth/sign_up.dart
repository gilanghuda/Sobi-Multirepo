import '../../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;
  SignUp(this.repository);

  Future<String> call({
    required String email,
    required String username,
    required String phone,
    required String password,
  }) {
    return repository.signUp(
      email: email,
      username: username,
      phone: phone,
      password: password,
    );
  }
}
