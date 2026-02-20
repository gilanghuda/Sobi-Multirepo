import 'package:flutter/material.dart';
import '../../domain/entities/education_entity.dart';
import '../../domain/usecases/education/get_educations.dart';
import '../../domain/usecases/education/get_education_detail.dart';
import '../../domain/usecases/education/get_education_history.dart';

class EducationProvider extends ChangeNotifier {
  final GetEducations getEducationsUsecase;
  final GetEducationDetail getEducationDetailUsecase;
  final GetEducationHistory? getEducationHistoryUsecase;

  List<EducationEntity> educations = [];
  List<EducationEntity> educationHistory = []; // tambah ini
  EducationEntity? educationDetail;
  bool isLoading = false;
  String? error;

  EducationProvider({
    required this.getEducationsUsecase,
    required this.getEducationDetailUsecase,
    this.getEducationHistoryUsecase,
  });

  Future<void> fetchEducations() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      print('[PROVIDER] fetchEducations request');
      educations = await getEducationsUsecase();
      print(
        '[PROVIDER] fetchEducations response: ${educations.map((e) => e.id).toList()}',
      );
      error = null;
    } catch (e) {
      error = e.toString();
      print('[PROVIDER] fetchEducations error: $error');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchEducationDetail(String id) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      print('[PROVIDER] fetchEducationDetail request id=$id');
      educationDetail = await getEducationDetailUsecase(id);
      print('[PROVIDER] fetchEducationDetail response: ${educationDetail?.id}');
      error = null;
    } catch (e) {
      error = e.toString();
      print('[PROVIDER] fetchEducationDetail error: $error');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchEducationHistory() async {
    if (getEducationHistoryUsecase == null) return;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      print('[PROVIDER] fetchEducationHistory request');
      educationHistory = await getEducationHistoryUsecase!();
      print(
        '[PROVIDER] fetchEducationHistory response: ${educationHistory.map((e) => e.id).toList()}',
      );
      for (var i = 0; i < educationHistory.length; i++) {
        print('[PROVIDER] history[$i]: ${educationHistory[i]}');
      }
      error = null;
    } catch (e) {
      error = e.toString();
      print('[PROVIDER] fetchEducationHistory error: $error');
    }
    isLoading = false;
    notifyListeners();
  }
}
