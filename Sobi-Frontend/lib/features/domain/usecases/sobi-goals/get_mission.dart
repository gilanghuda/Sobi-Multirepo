import '../../repositories/sobi-goals_repository.dart';
import '../../entities/sobi-goals.dart';

class GetTodayMission {
  final SobiGoalsRepository repository;
  GetTodayMission(this.repository);

  Future<List<TodayMissionEntity>> call({required String date}) async {
    final result = await repository.getTodayMission(date: date);
    print('[usecase] getTodayMission result: $result');
    return result;
  }
}
