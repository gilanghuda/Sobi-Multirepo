import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sobi/features/presentation/provider/education_provider.dart';
import 'package:sobi/features/presentation/router/app_routes.dart';
import 'package:sobi/features/presentation/screens/homepage/chat_curhat/curhat_chat_screen.dart';
import 'package:sobi/features/presentation/screens/homepage/chat_curhat/curhat_matchmaking_screen.dart';
import 'package:sobi/features/presentation/screens/homepage/navbar_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/verif_screen.dart';
import '../../../splash_screen.dart';
import '../screens/homepage/homepage_screen.dart';
import '../screens/sobi-quran/sobi_quran_screen.dart';
import '../screens/sobi-quran/detail-sobi-quran_screens.dart';
import '../screens/sobi-goals/sobi_goals_screen.dart';
import '../screens/sobi-belajar/sobi_time_screen.dart';
import '../screens/sobi-belajar/sobi_time_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/profile/profile_view_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/faq_screen.dart';
import '../screens/profile/about_screen.dart';
import '../screens/homepage/chat_ai/sobi_ai_screen.dart';
import '../screens/homepage/chat_ahli/chat_ahli_screen.dart';
import '../screens/homepage/chat_curhat/chat_anonim_screen.dart';
import '../screens/homepage/chat_curhat/pendengar_curhat_screen.dart';
import '../screens/homepage/chat_screen.dart';
import '../screens/homepage/chat_ahli/detail_pembayaran_screen.dart';
import '../screens/homepage/chat_ahli/pembayaran_loading_screen.dart';
import '../screens/homepage/chat_ahli/ahli_chat_list_screen.dart';
import '../screens/homepage/chat_ahli/ahli_chat_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

// ValueNotifier untuk status login
final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);

// Fungsi untuk cek status login dari cache
Future<void> checkLoginStatus() async {
  final storage = const FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token'); // perbaiki key
  print('[DEBUG checkLoginStatus] token=$token');
  isLoggedInNotifier.value = token != null && token.isNotEmpty;
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: isLoggedInNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      // Log untuk debug
      print(
        'DEBUG redirect: isLoggedIn=${isLoggedInNotifier.value}, subloc=${state.subloc}',
      );
      final isSplash = state.subloc == AppRoutes.splash;
      final isLogin = state.subloc == AppRoutes.login;
      final isRegister = state.subloc == AppRoutes.register;
      final isVerify = state.subloc.startsWith(AppRoutes.verif);

      final isLoggedIn = isLoggedInNotifier.value;

      if (isLoggedIn) {
        // Jika sudah login, cegah balik ke login/register/splash/verify
        if (isLogin || isRegister || isSplash || isVerify) {
          print('Redirecting to: ${AppRoutes.navbar}');
          return AppRoutes.navbar;
        }
        return null;
      } else {
        // Jika belum login, hanya boleh ke login/register/verify/splash
        if (!isLogin && !isRegister && !isVerify && !isSplash) {
          print('Redirecting to: ${AppRoutes.login}');
          return AppRoutes.login;
        }
        return null;
      }
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const AnimatedSplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          print('DEBUG app_router: register screen');
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.verif + '/:email',
        builder: (context, state) {
          final email = state.params['email'] ?? '';
          print('DEBUG app_router: verif_screen email=$email');
          return VerifScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.homepage,
        builder: (context, state) => const HomepageScreen(),
      ),
      GoRoute(
        path: AppRoutes.sobiQuran,
        builder: (context, state) => const SobiQuranScreen(),
      ),
      GoRoute(
        path: AppRoutes.sobiGoals,
        builder: (context, state) => const SobiGoalsScreen(),
      ),
      GoRoute(
        path: AppRoutes.sobiTime,
        builder: (context, state) => const SobiTimeScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.navbar,
        builder: (context, state) => const NavbarScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.view_profile,
        builder: (context, state) => const ProfileViewScreen(),
      ),
      GoRoute(
        path: AppRoutes.edit_profile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        builder: (context, state) => const FAQScreen(),
      ),
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: AppRoutes.sobiAi,
        builder: (context, state) => const SobiAiScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatAhli,
        builder: (context, state) => const ChatAhliScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatAnonim,
        builder: (context, state) => const ChatAnonimScreen(),
      ),
      GoRoute(
        path: AppRoutes.pendengarCurhat,
        builder: (context, state) => const PendengarCurhatScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatRoom,
        builder: (context, state) {
          final role = state.params['role'] ?? 'pencerita';
          final extra = state.extra as Map<String, dynamic>?;
          final roomId = extra?['roomId'] as String?;
          final ahli = extra?['ahli'] as Map<String, dynamic>?;
          return ChatScreen(role: role, roomId: roomId, ahli: ahli);
        },
      ),
      GoRoute(
        path: AppRoutes.detailPembayaran,
        builder: (context, state) {
          final ahli = state.extra as Map<String, dynamic>?;
          return DetailPembayaranScreen(ahli: ahli);
        },
      ),
      GoRoute(
        path: '/education-detail/:id',
        builder: (context, state) {
          final id = state.params['id'] ?? '';
          // Jangan fetch di router, biar screen yang fetch
          return SobiTimeDetailScreen(educationId: id);
        },
      ),
      GoRoute(
        path: '/sobi-quran-detail/:id',
        builder: (context, state) {
          final id = int.tryParse(state.params['id'] ?? '') ?? 1;
          // Ambil query parameter halaman dari URL
          final halamanStr = state.queryParams['halaman'];
          final halaman =
              halamanStr != null ? int.tryParse(halamanStr) ?? 1 : 1;
          return DetailSobiQuranScreen(suratId: id, halaman: halaman);
        },
      ),
      GoRoute(
        path: AppRoutes.pembayaranLoading,
        builder: (context, state) {
          final ahli = state.extra as Map<String, dynamic>?;
          return PembayaranLoadingScreen(ahli: ahli);
        },
      ),
      GoRoute(
        path: AppRoutes.pembayaranBerhasil,
        builder: (context, state) {
          final ahli = state.extra as Map<String, dynamic>?;
          return PembayaranBerhasilScreen(ahli: ahli);
        },
      ),
      GoRoute(
        path: '/ahli-chat-list',
        builder: (context, state) => const AhliChatListScreen(),
      ),
      GoRoute(
        path: '/ahli-chat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final roomId = extra?['roomId'] as String? ?? '';
          final otherUserId = extra?['otherUserId'] as String? ?? '';
          return AhliChatScreen(roomId: roomId, otherUserId: otherUserId);
        },
      ),
      GoRoute(
        path: '/curhat-matchmaking',
        builder: (context, state) => const CurhatMatchmakingScreen(),
      ),
      GoRoute(
        path: '/curhat-chat-room',
        builder: (context, state) => const CurhatChatScreen(),
      ),
    ],
    // GoRoute(
    //   // path: AppRoutes.homepage,
    //   // builder: (context, state) => const HomePage(),
    // ),

    // GoRoute(
    //   path: AppRoutes.activity,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const ActivityScreen();
    //   },
    // ),
    //       GoRoute(
    //         path: AppRoutes.notification,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const NotificationScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.profile,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const ProfileScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.homepage,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const HomeScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.forgotPassword,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const ForgotPassScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.resetPassword,
    //         builder: (BuildContext context, GoRouterState state) {
    //           final email = state.extra as String;
    //           return ResetPasswordScreen(email: email);
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.laporekBar,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const LaporekBar();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.admin,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const AdminScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.beritaAdmin,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const BeritaAdminScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.laporanAdmin,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const LaporanAdminScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.detailLaporanAdmin,
    //         builder: (BuildContext context, GoRouterState state) {
    //           final laporan = state.extra as Laporan;
    //           return DetailLaporanAdminScreen(laporan: laporan);
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.detailStatus,
    //         builder: (BuildContext context, GoRouterState state) {
    //           final laporan = state.extra as Laporan;
    //           return DetailStatusScreen(laporan: laporan);
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.panggilanOption,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const PanggilanOptionScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.pantauMalang,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const PantauMalangScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.ketentuanKebijakan,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const KetentuanKebijakanScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.gantiPassword,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const GantiPasswordScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: '/deskripsiStatus',
    //         builder: (context, state) {
    //           final extra = state.extra as Map<String, dynamic>;
    //           return DeskripsiStatusScreen(
    //             imageUrl: extra['imageUrl'],
    //             date: extra['date'],
    //             description: extra['description'],
    //             status: extra['status'],
    //           );
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.popUpUlasan,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const PopUpUlasanScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.popUpAlamat,
    //         builder: (context, state) {
    //           return const PopUpAlamatScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.popUpPanggilan,
    //         builder: (BuildContext context, GoRouterState state) {
    //           final args = state.extra as Map<String, dynamic>;
    //           return PopUpPanggilan(
    //             imagePath: args['imagePath'],
    //             title: args['title'],
    //             phoneNumber: args['phoneNumber'],
    //           );
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.adminPantauMalang,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const AdminPantauMalangScreen();
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.detailBerita,
    //         builder: (context, state) {
    //           final berita = state.extra as Berita;
    //           return DetailBeritaScreen(berita: berita);
    //         },
    //       ),
    //       GoRoute(
    //         path: AppRoutes.editProfile,
    //         builder: (BuildContext context, GoRouterState state) {
    //           return const EditProfileScreen();
    //         },
    //       ),

    //     errorBuilder: (context, state) {
    //       print('Page not found: ${state.subloc}');
    //       return Scaffold(body: Center(child: Text('Page not found')));
    // },
  );
}



      //         path: AppRoutes.popUpPanggilan,
      //         name: 'popUpPanggilan',
      //         builder: (BuildContext context, GoRouterState state) {
      //           final args = state.extra as Map<String, dynamic>;
      //           return PopUpPanggilan(
      //             imagePath: args['imagePath'],
      //             title: args['title'],
      //             phoneNumber: args['phoneNumber'],
      //           );
      //         },
      //       ),
      //       GoRoute(
      //         path: AppRoutes.adminPantauMalang,
      //         name: 'adminPantauMalang',
      //         builder: (BuildContext context, GoRouterState state) {
      //           print('Navigating to AdminPantauMalangScreen');
      //           return const AdminPantauMalangScreen();
      //         },
      //       ),
      //       GoRoute(
      //         path: AppRoutes.detailBerita,
      //         builder: (context, state) {
      //           final berita = state.extra as Berita;
      //           return DetailBeritaScreen(berita: berita);
      //         },
      //       ),
      //       GoRoute(
      //         path: AppRoutes.editProfile,
      //         name: 'editProfile',
      //         builder: (BuildContext context, GoRouterState state) {
      //           return const EditProfileScreen();
      //         },
      //       ),

    //     errorBuilder: (context, state) {
    //       print('Page not found: ${state.subloc}');
    //       return Scaffold(body: Center(child: Text('Page not found')));
    // },