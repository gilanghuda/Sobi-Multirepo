import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sobi/features/presentation/screens/homepage/navbar_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'package:sobi/features/presentation/provider/education_provider.dart';
import '../../provider/sobi-goals_provider.dart'; // <-- Tambahkan import ini

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _historyFetched = false;

  void _goToNavbar(int index) {
    NavbarController.currentIndex.value = index;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch hanya sekali saat widget pertama kali build
    if (!_historyFetched) {
      final educationProvider = Provider.of<EducationProvider>(
        context,
        listen: false,
      );
      print('[SCREEN] call fetchEducationHistory');
      educationProvider.fetchEducationHistory();
      _historyFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.user == null && authProvider.token != null) {
      authProvider.fetchUser();
    }
    final username = authProvider.user?.username ?? '...';
    final avatar = authProvider.user?.avatar ?? 1;
    final avatarAsset = 'assets/profil/Profil $avatar.png';
    final screenWidth = MediaQuery.of(context).size.width;
    final bentoHeight = 160.0;
    final profilePicSize = 100.0;
    final educationProvider = Provider.of<EducationProvider>(context);
    final history = educationProvider.educationHistory.take(3).toList();

    // Ambil data goals
    final sobiGoalsProvider = Provider.of<SobiGoalsProvider>(context);
    final goalStatus = sobiGoalsProvider.goalStatus;
    final todayMissions = sobiGoalsProvider.todayMissions;
    final missionData = (todayMissions.isNotEmpty) ? todayMissions.first : null;
    final mission =
        (missionData != null && missionData.missions.isNotEmpty)
            ? missionData.missions.first
            : null;
    double progress =
        mission?.progress.completionPercentage != null
            ? (mission!.progress.completionPercentage! / 100)
            : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. ScrollView (isi utama)
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 300),
                  Text(
                    'Capaian Ibadah',
                    style: AppTextStyles.heading_5_bold.copyWith(
                      color: AppColors.primary_90,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Bento Layout
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        // Card Hijrah (60%)
                        Expanded(
                          flex: 6,
                          child:
                              goalStatus == null
                                  ? GestureDetector(
                                    onTap: () {
                                     NavbarController.currentIndex.value = 2;
                                              context.go('/navbar');
                                    },
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6DAF0),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.primary_30,
                                                  width: 2,
                                                  style: BorderStyle.solid,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: AppColors.primary_50,
                                                size: 32,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              "Mulai Hijrah",
                                              style: AppTextStyles.body_4_bold
                                                  .copyWith(
                                                    color: AppColors.primary_90,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  : Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6DAF0),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 18),
                                        CircularPercentIndicator(
                                          radius: 60.0,
                                          lineWidth: 10.0,
                                          percent: progress,
                                          progressColor: AppColors.primary_70,
                                          backgroundColor: AppColors.primary_30
                                              .withOpacity(0.3),
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          center: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${(progress * 100).toInt()}%",
                                                style: AppTextStyles
                                                    .heading_5_bold
                                                    .copyWith(
                                                      color:
                                                          AppColors.primary_90,
                                                      fontSize: 22,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Yuk,\nlengkapi\nprogresmu",
                                                textAlign: TextAlign.center,
                                                style: AppTextStyles.body_6_bold
                                                    .copyWith(
                                                      color:
                                                          AppColors.primary_90,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: 130,
                                          height: 24,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              NavbarController.currentIndex.value = 2;
                                              context.go('/navbar');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary_90,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 24,
                                                  ),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              "Target Hijrah",
                                              style: AppTextStyles.body_5_bold
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                        ),
                        const SizedBox(width: 14),
                        // Card Bacaan (40%)
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.primary_10,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 18.0,
                                    bottom: 6,
                                  ),
                                  child: Text(
                                    'Terakhir dibaca',
                                    style: AppTextStyles.body_5_regular
                                        .copyWith(color: AppColors.primary_90),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  height: 2,
                                  color: AppColors.primary_30,
                                  margin: const EdgeInsets.only(bottom: 10),
                                ),
                                Icon(
                                  Icons.menu_book,
                                  color: AppColors.primary_90,
                                  size: 36,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Al-Ma'idah : 48",
                                  style: AppTextStyles.body_4_bold.copyWith(
                                    color: AppColors.primary_90,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 18.0),
                                  child: SizedBox(
                                    width: 130,
                                    height: 24,
                                    child: ElevatedButton(
                                      onPressed: () => _goToNavbar(1),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary_90,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 24,
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        "Lanjutkan",
                                        style: AppTextStyles.body_5_bold
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Riwayat Belajar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Riwayat Belajar',
                        style: AppTextStyles.heading_6_bold.copyWith(
                          color: AppColors.primary_90,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Card List dari educationProvider.history
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        for (var i = 0; i < history.length; i++) ...[
                          _RiwayatCard(
                            image: getYoutubeThumbnail(history[i].videoUrl),
                            title: history[i].title,
                            desc: history[i].description,
                            date: DateFormat(
                              'd MMM yyyy',
                            ).format(history[i].createdAt),
                            onTap: () {
                              // Gunakan go_router push ke sobi time detail
                              context.push(
                                '/education-detail/${history[i].id}',
                              );
                            },
                          ),
                          if (i < history.length - 1)
                            const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
          // 2. SVG profil background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/svg/profil_background.svg',
              width: screenWidth,
              fit: BoxFit.cover,
            ),
          ),
          // 3. Foto profil + tombol edit
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: profilePicSize / 2,
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            profilePicSize / 2,
                          ),
                          child: Image.asset(
                            avatarAsset,
                            width: profilePicSize * 0.7,
                            height: profilePicSize * 0.7,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.edit_profile);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary_30,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  username,
                  style: AppTextStyles.heading_5_bold.copyWith(
                    color: AppColors.default_10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // 4. Tombol setting di pojok kanan atas
          // Pindahkan ke urutan paling akhir agar tidak tertutup widget lain!
          Positioned(
            top: 38,
            right: 28,
            child: Builder(
              builder:
                  (context) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print('[DEBUG] Settings button tapped');
                      if (GoRouter.of(context).location != AppRoutes.settings) {
                        print('[DEBUG] Navigating to settings...');
                        context.push(AppRoutes.settings);
                      }
                    },
                    child: SvgPicture.asset(
                  'assets/icons/setting.svg',
                  width: 28,
                  height: 28,
                  // colorFilter: const ColorFilter.mode(
                  //   Colors.black,
                  //   BlendMode.srcIn,
                  // ),
                ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final String date;
  final VoidCallback? onTap;

  const _RiwayatCard({
    required this.image,
    required this.title,
    required this.desc,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primary_30, width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary_10.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 8),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: Image.network(
                image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      color: AppColors.default_30,
                      width: 60,
                      height: 60,
                    ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.body_3_bold.copyWith(
                              color: AppColors.primary_90,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          date,
                          style: AppTextStyles.body_5_regular.copyWith(
                            color: AppColors.default_90,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: AppTextStyles.body_5_regular.copyWith(
                        color: AppColors.primary_90,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Fungsi ambil thumbnail dari url YouTube
String getYoutubeThumbnail(String url) {
  Uri uri = Uri.parse(url);
  if (uri.host.contains('youtu.be')) {
    return "https://img.youtube.com/vi/${uri.pathSegments.first}/hqdefault.jpg";
  } else {
    return "https://img.youtube.com/vi/${uri.queryParameters['v']}/hqdefault.jpg";
  }
}
  