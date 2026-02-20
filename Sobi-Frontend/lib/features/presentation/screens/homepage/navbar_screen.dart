import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/datasources/auth_datasources.dart';
import '../../provider/auth_provider.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';
import 'homepage_screen.dart';
import '../sobi-quran/sobi_quran_screen.dart';
import '../sobi-goals/sobi_goals_screen.dart';
import '../sobi-belajar/sobi_time_screen.dart';
import '../profile/profile_screen.dart';

// Global controller
class NavbarController {
  static final currentIndex = ValueNotifier<int>(0);
}

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  bool isChatMenuOpen = false;

  void _toggleChatMenu() {
    setState(() {
      isChatMenuOpen = !isChatMenuOpen;
    });
  }

  void _goToSobiAi(BuildContext context) {
    setState(() => isChatMenuOpen = false);
    context.push('/sobi-ai');
  }

  void _goToChatAhli(BuildContext context) {
    setState(() => isChatMenuOpen = false);
    context.push('/chat-ahli');
  }

  void _goToChatAnonim(BuildContext context) {
    setState(() => isChatMenuOpen = false);
    context.push('/chat-anonim');
  }

  final List<Widget> pages = const [
    HomepageScreen(),
    SobiQuranScreen(),
    SobiGoalsScreen(),
    SobiTimeScreen(),
    ProfileScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Fetch user jika user masih null dan token ada
    if (authProvider.user == null && authProvider.token != null) {
      authProvider.fetchUser();
    }
    _debugNavbarStorage();
  }

  Future<void> _debugNavbarStorage() async {
    final authDs = AuthDatasources();
    await authDs.debugPrintStorage();
    final cachedUser = await authDs.getCachedUser();
    print('DEBUG [NavbarScreen] cached user: $cachedUser');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    // Ambil user profile jika belum ada
    if (authProvider.user == null && authProvider.token != null) {
      authProvider.fetchUser();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final navbarHeight = screenHeight * 0.10;
    final floatingSize = screenWidth * 0.16;
    final chatMenuSize = screenWidth * 0.16;

    return ValueListenableBuilder<int>(
      valueListenable: NavbarController.currentIndex,
      builder: (context, page, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: Stack(
            children: [
              // Page content
              IndexedStack(index: page, children: pages),

              // Custom Navbar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: navbarHeight,
                  color: AppColors.primary_90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: navbarHeight * 0.55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Homepage
                            _NavbarIconButton(
                              asset:
                                  page == 0
                                      ? 'assets/icons/home_active.svg'
                                      : 'assets/icons/home.svg',
                              active: page == 0,
                              onTap:
                                  () => NavbarController.currentIndex.value = 0,
                            ),
                            // Sobi Quran
                            _NavbarIconButton(
                              asset:
                                  page == 1
                                      ? 'assets/icons/quran_active.svg'
                                      : 'assets/icons/quran.svg',
                              active: page == 1,
                              onTap:
                                  () => NavbarController.currentIndex.value = 1,
                            ),
                            // Spacer untuk floating button
                            SizedBox(width: floatingSize),
                            // Sobi Time
                            _NavbarIconButton(
                              asset:
                                  page == 3
                                      ? 'assets/icons/time_active.svg'
                                      : 'assets/icons/time.svg',
                              active: page == 3,
                              onTap:
                                  () => NavbarController.currentIndex.value = 3,
                            ),
                            // Profile
                            _NavbarIconButton(
                              asset:
                                  page == 4
                                      ? 'assets/icons/profile_active.svg'
                                      : 'assets/icons/profile.svg',
                              active: page == 4,
                              onTap:
                                  () => NavbarController.currentIndex.value = 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating Button (Goals)
              Positioned(
                left: (screenWidth / 2) - (floatingSize / 2),
                bottom: navbarHeight / 2,
                child: Material(
                  color: Colors.transparent,
                  elevation: 8,
                  shape: const CircleBorder(),
                  child: GestureDetector(
                    onTap: () => NavbarController.currentIndex.value = 2,
                    child: Container(
                      width: floatingSize,
                      height: floatingSize,
                      decoration: BoxDecoration(
                        color: AppColors.primary_10,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          page == 2
                              ? 'assets/icons/goals_active.svg'
                              : 'assets/icons/goals.svg',
                          width: floatingSize * 0.56,
                          height: floatingSize * 0.56,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Floating Button (Homepage Chat Menu)
              if (page == 0)
                Positioned(
                  right: 24,
                  bottom: navbarHeight + 24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Menu buttons (show only if open)
                      if (isChatMenuOpen) ...[
                        _ChatMenuButton(
                          iconAsset: 'assets/svg/sobi_curhat.svg', // chat anonim
                          color: AppColors.secondary_10,
                          onTap: () => _goToChatAnonim(context),
                          size: chatMenuSize*0.8,
                        ),
                        const SizedBox(height: 12),
                        _ChatMenuButton(
                          iconAsset: 'assets/svg/sobi_ai.svg', // chat ahli
                          color: AppColors.secondary_10,
                          onTap: () async {
                            final authDs = AuthDatasources();
                            final cachedUser = await authDs.getCachedUser();
                            final userRole = cachedUser?.userRole;
                            if (userRole == 'ahli') {
                              context.push('/ahli-chat-list');
                            } else {
                              _goToChatAhli(context);
                            }
                          },
                          size: chatMenuSize*0.8,
                        ),
                        const SizedBox(height: 12),
                        _ChatMenuButton(
                          iconAsset: 'assets/svg/sobi_ahli.svg', // sobi ai
                          color: AppColors.secondary_10,
                          onTap: () => _goToSobiAi(context),
                          size: chatMenuSize*0.8,
                        ),
                        const SizedBox(height: 12),
                      ],
                      // Main chat menu button
                      Material(
                        color: Colors.transparent,
                        elevation: 8,
                        shape: const CircleBorder(),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(chatMenuSize / 2),
                          onTap: _toggleChatMenu,
                          child: Container(
                            width: chatMenuSize,
                            height: chatMenuSize,
                            decoration: BoxDecoration(
                              color: AppColors.primary_50,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svg/chat.svg', // tombol utama chat menu
                                width: chatMenuSize * 0.55,
                                height: chatMenuSize * 0.55,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NavbarIconButton extends StatelessWidget {
  final String asset;
  final bool active;
  final VoidCallback onTap;

  const _NavbarIconButton({
    required this.asset,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.07; // 7% dari lebar layar

    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(
          active ? Colors.white : AppColors.default_90,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

// Tombol bulat menu chat
class _ChatMenuButton extends StatelessWidget {
  final String iconAsset;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const _ChatMenuButton({
    required this.iconAsset,
    required this.color,
    required this.onTap,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 4,
      shape: const CircleBorder(),
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              iconAsset,
              width: size * 0.55,
              height: size * 0.55,
              colorFilter: const ColorFilter.mode(
                AppColors.primary_90,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

