import '../entities/education_entity.dart';

abstract class EducationRepository {
  Future<List<EducationEntity>> getEducations();
  Future<EducationEntity?> getEducationDetail(String id);
  Future<List<EducationEntity>> getEducationHistory(); // tambah ini
}
