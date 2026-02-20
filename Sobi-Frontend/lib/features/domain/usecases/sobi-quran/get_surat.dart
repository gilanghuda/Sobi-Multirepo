import '../../repositories/sobi-quran_repository.dart';
import '../../entities/surat_entity.dart';

class GetSurat {
  final SobiQuranRepository repository;
  GetSurat(this.repository);

  Future<List<SuratEntity>> call() {
    return repository.getSurat();
  }
}
