import '../../repositories/sobi-quran_repository.dart';
import '../../entities/surat_detail_entity.dart';

class GetSuratDetail {
  final SobiQuranRepository repository;
  GetSuratDetail(this.repository);

  Future<SuratDetailEntity?> call(int nomor) {
    return repository.getSuratDetail(nomor);
  }
}
