import '../../domain/repositories/education_repository.dart';
import '../../domain/entities/education_entity.dart';
import '../datasources/education_datasource.dart';
import '../models/education_model.dart';

class EducationRepositoryImpl implements EducationRepository {
  final EducationDatasource datasource;
  EducationRepositoryImpl(this.datasource);

  @override
  Future<List<EducationEntity>> getEducations() async {
    final models = await datasource.getEducations();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<EducationEntity?> getEducationDetail(String id) async {
    final model = await datasource.getEducationDetail(id);
    return model?.toEntity();
  }

  @override
  Future<List<EducationEntity>> getEducationHistory() async {
    final models = await datasource.getEducationHistory();
    return models.map((m) => m.toEntity()).toList();
  }
}
