import 'package:flutter/material.dart';
import '../../domain/entities/ahli_entity.dart';
import '../../domain/usecases/chat-ahli/get_ahli.dart';
import '../../domain/usecases/chat-ahli/get_user_by_id.dart';

class AhliProvider extends ChangeNotifier {
  final GetAhli getAhliUsecase;
  final GetUserById? getUserByIdUsecase;

  List<AhliEntity> ahliList = [];
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? userById;
  bool isLoadingUserById = false;

  AhliProvider({required this.getAhliUsecase, this.getUserByIdUsecase});

  Future<void> fetchAhli() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      ahliList = await getAhliUsecase();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserById(String id) async {
    if (getUserByIdUsecase == null) return;
    isLoadingUserById = true;
    notifyListeners();
    try {
      userById = await getUserByIdUsecase!(id);
    } catch (_) {
      userById = null;
    }
    isLoadingUserById = false;
    notifyListeners();
  }
}
