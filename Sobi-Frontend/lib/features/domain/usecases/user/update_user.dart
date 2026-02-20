import '../../repositories/auth_repository.dart';

class UpdateUser {
  final AuthRepository repository;
  UpdateUser(this.repository);

  Future<String> call({
    required String username,
    required String gender,
    required String phoneNumber,
    required int avatar,
  }) {
    return repository.updateUserProfile(
      username: username,
      gender: gender,
      phoneNumber: phoneNumber,
      avatar: avatar,
    );
  }
}
