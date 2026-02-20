import 'package:flutter/material.dart';
import '../../domain/entities/surat_entity.dart';
import '../../domain/entities/surat_detail_entity.dart';
import '../../domain/entities/tafsir_entity.dart';
import '../../domain/entities/quran_recommendation_entity.dart';
import '../../domain/usecases/sobi-quran/get_surat.dart';
import '../../domain/usecases/sobi-quran/get_surat_detail.dart';
import '../../domain/usecases/sobi-quran/get_tafsir.dart';
import '../../domain/usecases/sobi-quran/get_quran_recommendation.dart';

class SobiQuranProvider extends ChangeNotifier {
  final GetSurat getSuratUsecase;
  final GetSuratDetail? getSuratDetailUsecase;
  final GetAyahTafsir? getAyahTafsirUsecase;
  final GetQuranRecommendation? getQuranRecommendationUsecase;

  List<SuratEntity> suratList = [];
  SuratDetailEntity? suratDetail;
  AyahTafsirEntity? ayahTafsir;
  QuranRecommendationEntity? quranRecommendation;
  bool isLoading = false;
  String? error;

  SobiQuranProvider({
    required this.getSuratUsecase,
    this.getSuratDetailUsecase,
    this.getAyahTafsirUsecase,
    this.getQuranRecommendationUsecase,
  });

  Future<void> fetchSurat() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      suratList = await getSuratUsecase();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSuratDetail(int nomor) async {
    if (getSuratDetailUsecase == null) return;
    isLoading = true;
    error = null;
    print('[PROVIDER] fetchSuratDetail request nomor=$nomor');
    notifyListeners();
    try {
      suratDetail = await getSuratDetailUsecase!(nomor);
      print('[PROVIDER] fetchSuratDetail response: ${suratDetail?.namaLatin}');
      error = null;
    } catch (e) {
      error = e.toString();
      print('[PROVIDER] fetchSuratDetail error: $error');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAyahTafsir({required int surah, required int ayah}) async {
    if (getAyahTafsirUsecase == null) return;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      ayahTafsir = await getAyahTafsirUsecase!(surah: surah, ayah: ayah);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchQuranRecommendation({required String question}) async {
    if (getQuranRecommendationUsecase == null) return;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      quranRecommendation = await getQuranRecommendationUsecase!(
        question: question,
      );
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
