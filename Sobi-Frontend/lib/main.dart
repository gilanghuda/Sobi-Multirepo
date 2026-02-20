import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/presentation/provider/ahli_provider.dart';
import 'package:sobi/features/presentation/provider/chat_provider.dart';
import 'package:sobi/features/presentation/provider/curhat_sobi_ws_provider.dart';
import 'package:sobi/features/presentation/provider/education_provider.dart';
import 'package:sobi/features/presentation/provider/sobi-quran_provider.dart';
import 'features/presentation/router/app_router.dart';
import 'di/injection_container.dart';
import 'features/presentation/provider/auth_provider.dart';
import 'features/presentation/provider/sobi-goals_provider.dart';
import 'features/data/datasources/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load(); // <-- pastikan .env sudah di-load
  setupDependencyInjection();
  await checkLoginStatus(); // <-- tambahkan ini sebelum runApp
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<SobiGoalsProvider>()),
        ChangeNotifierProvider(create: (_) => sl<EducationProvider>()),
        ChangeNotifierProvider(create: (_) => sl<SobiQuranProvider>()),
        ChangeNotifierProvider(create: (_) => sl<AhliProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ChatProvider>()),
         ChangeNotifierProvider(create: (_) => sl<CurhatSobiWsProvider>()),
        // ...provider lain...
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SoBi',
      routerConfig: AppRouter.router,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Ini halaman utama 🚀")));
  }
}
