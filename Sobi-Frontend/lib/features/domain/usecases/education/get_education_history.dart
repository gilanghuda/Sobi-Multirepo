import '../../repositories/education_repository.dart';
import '../../entities/education_entity.dart';

class GetEducationHistory {
  final EducationRepository repository;
  GetEducationHistory(this.repository);

  Future<List<EducationEntity>> call() {
    return repository.getEducationHistory();
  }
}
