import '../../repositories/education_repository.dart';
import '../../entities/education_entity.dart';

class GetEducations {
  final EducationRepository repository;
  GetEducations(this.repository);

  Future<List<EducationEntity>> call() {
    return repository.getEducations();
  }
}
