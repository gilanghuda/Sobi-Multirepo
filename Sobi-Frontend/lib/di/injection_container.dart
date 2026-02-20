import 'package:get_it/get_it.dart';
import 'package:sobi/features/domain/usecases/sobi-goals/post_summaries.dart';
import 'package:sobi/features/domain/usecases/user/update_user.dart';
import '../features/data/datasources/auth_datasources.dart';
import '../features/data/repositories_impl/auth_repositories_impl.dart';
import '../features/domain/repositories/auth_repository.dart';
import '../features/domain/usecases/auth/sign_in.dart';
import '../features/domain/usecases/auth/sign_up.dart';
import '../features/domain/usecases/auth/verify_otp.dart';
import '../features/domain/usecases/auth/logout.dart';
import '../features/domain/usecases/user/get_user.dart';
import '../features/presentation/provider/auth_provider.dart';
import '../features/data/datasources/sobi-goals_datasources.dart';
import '../features/data/repositories_impl/sobi-goals_repository_impl.dart';
import '../features/domain/repositories/sobi-goals_repository.dart';
import '../features/domain/usecases/sobi-goals/create_goals.dart';
import '../features/domain/usecases/sobi-goals/get_mission.dart';
import '../features/domain/usecases/sobi-goals/post_task_user.dart';
import '../features/domain/usecases/sobi-goals/get_summaries.dart';
import '../features/presentation/provider/sobi-goals_provider.dart';
import '../features/data/datasources/education_datasource.dart';
import '../features/data/repositories_impl/education_repository_impl.dart';
import '../features/domain/repositories/education_repository.dart';
import '../features/domain/usecases/education/get_educations.dart';
import '../features/domain/usecases/education/get_education_detail.dart';
import '../features/domain/usecases/education/get_education_history.dart';
import '../features/presentation/provider/education_provider.dart';
import '../features/data/datasources/sobi-quran_datasources.dart';
import '../features/data/repositories_impl/sobi-quran_repository_impl.dart';
import '../features/domain/repositories/sobi-quran_repository.dart';
import '../features/domain/usecases/sobi-quran/get_surat.dart';
import '../features/domain/usecases/sobi-quran/get_surat_detail.dart';
import '../features/domain/usecases/sobi-quran/get_tafsir.dart';
import '../features/domain/usecases/sobi-quran/get_quran_recommendation.dart';
import '../features/presentation/provider/sobi-quran_provider.dart';
import '../features/data/datasources/ahli_datasources.dart';
import '../features/data/repositories_impl/chat-ahli_repositories_impl.dart';
import '../features/domain/repositories/chat-ahli_repository.dart';
import '../features/domain/usecases/chat-ahli/get_ahli.dart';
import '../features/domain/usecases/chat-ahli/get_user_by_id.dart';
import '../features/presentation/provider/ahli_provider.dart';
import '../features/data/datasources/chat_datasources.dart';
import '../features/data/repositories_impl/chat_repositories_impl.dart';
import '../features/domain/repositories/chat_repository.dart';
import '../features/domain/usecases/chat/create_room_chat.dart';
import '../features/domain/usecases/chat/get_rooms_chat.dart';
import '../features/domain/usecases/chat/get_recent_chat.dart';
import '../features/domain/usecases/chat/get_room_messages.dart';
import '../features/domain/usecases/chat/post_message_chat.dart';
import '../features/domain/usecases/chat/send_bot_message.dart';
import '../features/presentation/provider/chat_provider.dart';
import '../features/data/datasources/curhat_sobi_ws_datasource.dart';
import '../features/data/repositories_impl/curhat_sobi_ws_repository_impl.dart';
import '../features/domain/repositories/curhat_sobi_ws_repository.dart';
import '../features/domain/usecases/curhat_sobi/connect_ws.dart';
import '../features/domain/usecases/curhat_sobi/find_match.dart';
import '../features/presentation/provider/curhat_sobi_ws_provider.dart';

final sl = GetIt.instance;

void setupDependencyInjection() {
  // Data source
  sl.registerLazySingleton<AuthDatasources>(() => AuthDatasources());

  // Repository: DAFTARKAN SEBAGAI AuthRepository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Usecases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl())); // <--- Tambahkan ini

  // Provider
  sl.registerFactory(
    () => AuthProvider(
      signInUsecase: sl(),
      signUpUsecase: sl(),
      verifyOtpUsecase: sl(),
      logoutUsecase: sl(),
      getUserUsecase: sl(),
      updateUserUsecase: sl(), // <--- Pastikan ini ada
    ),
  );

  // Sobi Goals
  sl.registerLazySingleton<SobiGoalsDatasource>(() => SobiGoalsDatasource());
  sl.registerLazySingleton<SobiGoalsRepository>(
    () => SobiGoalsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CreateGoals(sl()));
  sl.registerLazySingleton(() => GetTodayMission(sl()));
  sl.registerLazySingleton(() => CompleteTask(sl()));
  sl.registerLazySingleton(() => GetSummaries(sl()));
  sl.registerLazySingleton(() => PostSummaries(sl()));
  sl.registerFactory(
    () => SobiGoalsProvider(
      createGoalsUsecase: sl(),
      getTodayMissionUsecase: sl(),
      completeTaskUsecase: sl(),
      getSummariesUsecase: sl(),
      postSummariesUsecase: sl(),
      datasource: sl(),
    ),
  );

  // Education
  sl.registerLazySingleton<EducationDatasource>(() => EducationDatasource());
  sl.registerLazySingleton<EducationRepository>(
    () => EducationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetEducations(sl()));
  sl.registerLazySingleton(() => GetEducationDetail(sl()));
  sl.registerLazySingleton(() => GetEducationHistory(sl()));
  sl.registerFactory(
    () => EducationProvider(
      getEducationsUsecase: sl(),
      getEducationDetailUsecase: sl(),
      getEducationHistoryUsecase: sl(), // tambahkan ini
    ),
  );

  // Sobi Quran
  sl.registerLazySingleton<SobiQuranDatasource>(() => SobiQuranDatasource());
  sl.registerLazySingleton<SobiQuranRepository>(
    () => SobiQuranRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetSurat(sl()));
  sl.registerLazySingleton(() => GetSuratDetail(sl()));
  sl.registerLazySingleton(() => GetAyahTafsir(sl()));
  sl.registerLazySingleton(() => GetQuranRecommendation(sl()));
  sl.registerFactory(
    () => SobiQuranProvider(
      getSuratUsecase: sl(),
      getSuratDetailUsecase: sl(),
      getAyahTafsirUsecase: sl(),
      getQuranRecommendationUsecase: sl(),
    ),
  );

  // Ahli (Expert)
  sl.registerLazySingleton<AhliDatasource>(() => AhliDatasource());
  sl.registerLazySingleton<ChatAhliRepository>(
    () => ChatAhliRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetAhli(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));
  sl.registerFactory(
    () => AhliProvider(
      getAhliUsecase: sl(),
      getUserByIdUsecase: sl(), // tambahkan ini
    ),
  );

  // Chat
  sl.registerLazySingleton<ChatDatasource>(() => ChatDatasource());
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CreateRoomChat(sl()));
  sl.registerLazySingleton(() => GetRoomsChat(sl()));
  sl.registerLazySingleton(() => GetRecentChat(sl()));
  sl.registerLazySingleton(() => GetRoomMessages(sl()));
  sl.registerLazySingleton(() => PostMessageChat(sl()));
  sl.registerLazySingleton(() => SendBotMessage(sl()));
  sl.registerFactory(
    () => ChatProvider(
      createRoomChatUsecase: sl(),
      getRoomsChatUsecase: sl(),
      getRecentChatUsecase: sl(),
      getRoomMessagesUsecase: sl(),
      postMessageChatUsecase: sl(),
      sendBotMessageUsecase: sl(), // <-- tambahkan ini
    ),
  );

  // Curhat Sobi WS
  sl.registerLazySingleton<CurhatSobiWsDatasource>(
    () => CurhatSobiWsDatasource(),
  );
  sl.registerLazySingleton<CurhatSobiWsRepository>(
    () => CurhatSobiWsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => ConnectCurhatSobiWS(sl()));
  sl.registerLazySingleton(() => FindCurhatSobiMatch(sl()));
  sl.registerFactory(
    () => CurhatSobiWsProvider(
      token: '', // Token harus diisi manual saat inisialisasi provider di UI
      connectWsUsecase: sl(),
      findMatchUsecase: sl(),
    ),
  );
}
