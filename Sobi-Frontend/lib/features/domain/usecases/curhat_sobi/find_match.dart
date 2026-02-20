import '../../repositories/curhat_sobi_ws_repository.dart';

class FindCurhatSobiMatch {
  final CurhatSobiWsRepository repository;
  FindCurhatSobiMatch(this.repository);

  Future<Map<String, dynamic>?> call({
    required String token,
    required String role,
    required String category,
  }) {
    // Pastikan repository mengembalikan response dari datasource
    return repository.findMatch(token: token, role: role, category: category);
  }
}
