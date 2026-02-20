import '../../repositories/education_repository.dart';
import '../../entities/education_entity.dart';

class GetEducationDetail {
  final EducationRepository repository;
  GetEducationDetail(this.repository);

  Future<EducationEntity?> call(String id) {
    return repository.getEducationDetail(id);
  }
}
