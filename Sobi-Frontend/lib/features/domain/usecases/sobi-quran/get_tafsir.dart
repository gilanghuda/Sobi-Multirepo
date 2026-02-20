import '../../repositories/sobi-quran_repository.dart';
import '../../entities/tafsir_entity.dart';



class GetAyahTafsir {
  final SobiQuranRepository repository;
  GetAyahTafsir(this.repository);

  Future<AyahTafsirEntity?> call({required int surah, required int ayah}) {
    return repository.getAyahTafsir(surah: surah, ayah: ayah);
  }
}
