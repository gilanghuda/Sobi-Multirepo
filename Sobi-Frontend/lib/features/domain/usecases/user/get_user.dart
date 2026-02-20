import '../../../data/models/user_model.dart';
import '../../repositories/auth_repository.dart';

class GetUser {
  final AuthRepository repository;
  GetUser(this.repository);

  Future<UserModel> call() {
    return repository.getUser();
  }
}
