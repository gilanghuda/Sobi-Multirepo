import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/presentation/provider/auth_provider.dart';
import 'package:sobi/features/presentation/provider/education_provider.dart';
import 'package:sobi/features/presentation/style/colors.dart';
import 'package:sobi/features/presentation/style/typography.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int currentQuestion = 0;
  int totalPoint = 0;
  int selectedEmotion = -1; // -1 means no selection
  TextEditingController journalController = TextEditingController();

  final List<String> emotionNames = [
    'marah',
    'sedih',
    'biasa',
    'senyum',
    'bahagia_sekali',
  ];

  List<String> get emoticonWebpAssets =>
      List.generate(5, (i) => 'assets/emoji/${emotionNames[i]}.webp');

  bool isAnimatingEmotion = false;

  final List<String> emotionQuestions = [
    'Bagaimana perasaanmu hari ini?',
    'Apakah kamu sempat sholat berjamaah?',
    'Sudah membaca Al-Quran hari ini?',
    'Apakah kamu membantu orang lain hari ini?',
    'Sudah berdoa sebelum beraktivitas?',
    'Apakah kamu bersyukur hari ini?',
    'Sudah berbuat baik kepada teman?',
    'Sudah menjaga kebersihan lingkungan?',
    'Sudah belajar hal baru hari ini?',
    'Sudah meminta maaf jika berbuat salah?',
    'Sudah memaafkan orang lain?',
    'Sudah menjaga adab berbicara?',
    'Sudah menjaga waktu sholat?',
    'Sudah berterima kasih kepada orang tua?',
    'Sudah berusaha sabar hari ini?',
  ];

  final List<String> treeSvgAssets = [
    'assets/homepage/pohon.png',
    'assets/homepage/bunga/bunga (1).png',
    'assets/homepage/bunga/bunga (2).png',
    'assets/homepage/bunga/bunga (3).png',
    'assets/homepage/bunga/bunga (4).png',
    'assets/homepage/bunga/bunga (5).png',
    'assets/homepage/bunga/bunga (6).png',
    'assets/homepage/bunga/bunga (7).png',
    'assets/homepage/bunga/bunga (8).png',
    'assets/homepage/bunga/bunga (9).png',
    'assets/homepage/bunga/bunga (10).png',
    'assets/homepage/bunga/bunga (11).png',
    'assets/homepage/bunga/bunga (12).png',
    'assets/homepage/bunga/bunga (13).png',
    'assets/homepage/bunga/bunga (14).png',
    'assets/homepage/bunga/bunga (15).png',
    'assets/homepage/bunga/bunga (16).png',
    'assets/homepage/bunga/bunga (17).png',
    'assets/homepage/bunga/bunga (18).png',
    'assets/homepage/bunga/bunga (19).png',
    'assets/homepage/bunga/bunga (20).png',
    'assets/homepage/bunga/bunga (21).png',
    'assets/homepage/bunga/bunga (22).png',
    'assets/homepage/bunga/bunga (23).png',
    'assets/homepage/bunga/bunga (24).png',
    'assets/homepage/bunga/bunga (25).png',
    'assets/homepage/bunga/bunga (26).png',
    'assets/homepage/bunga/bunga (27).png',
    'assets/homepage/bunga/bunga (28).png',
    'assets/homepage/bunga/bunga (29).png',
    'assets/homepage/bunga/bunga (30).png',
    'assets/homepage/bunga/bunga (31).png',
    'assets/homepage/bunga/bunga (32).png',
    'assets/homepage/bunga/bunga (33).png',
    'assets/homepage/bunga/bunga (34).png',
    'assets/homepage/bunga/bunga (35).png',
    'assets/homepage/bunga/bunga (36).png',
    'assets/homepage/bunga/bunga (37).png',
    'assets/homepage/bunga/bunga (38).png',
    'assets/homepage/bunga/bunga (39).png',
    'assets/homepage/bunga/bunga (40).png',
    'assets/homepage/bunga/bunga (41).png',
    'assets/homepage/bunga/bunga (42).png',
    'assets/homepage/bunga/bunga (43).png',
    'assets/homepage/bunga/bunga (44).png',
    'assets/homepage/bunga/bunga (45).png',
    'assets/homepage/bunga/bunga (46).png',
    'assets/homepage/bunga/bunga (47).png',
  ];

  bool isFabMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _loadCache();
  }

  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentQuestion = prefs.getInt('homepage_currentQuestion') ?? 0;
      totalPoint = prefs.getInt('homepage_totalPoint') ?? 0;
      journalController.text = prefs.getString('homepage_journal') ?? '';
    });
  }

  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('homepage_currentQuestion', currentQuestion);
    await prefs.setInt('homepage_totalPoint', totalPoint);
    await prefs.setString('homepage_journal', journalController.text);
  }

  void _onEmotionSelected(int index) async {
    if (selectedEmotion == -1 && currentQuestion < emotionQuestions.length) {
      setState(() {
        selectedEmotion = index;
        isAnimatingEmotion = true;
      });

      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() {
        isAnimatingEmotion = false;
        totalPoint += (index + 1);
      });
      await _saveCache();

      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        if (currentQuestion < emotionQuestions.length - 1) {
          currentQuestion++;
          selectedEmotion = -1;
        }
      });
      await _saveCache();
    }
  }

  void _toggleFabMenu() {
    setState(() {
      isFabMenuOpen = !isFabMenuOpen;
    });
  }

  void _goToSobiAi() {
    context.push('/sobi-ai');
    setState(() {
      isFabMenuOpen = false;
    });
  }

  void _goToChatAhli() {
    context.push('/chat-ahli');
    setState(() {
      isFabMenuOpen = false;
    });
  }

  void _goToChatAnonim() {
    context.push('/chat-anonim');
    setState(() {
      isFabMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.user == null && authProvider.token != null) {
      authProvider.fetchUser();
    }
    final screenWidth = MediaQuery.of(context).size.width;

    // Ambil 5 edukasi dari provider
    final educationProvider = Provider.of<EducationProvider>(
      context,
      listen: false,
    );
    final educations = educationProvider.educations.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(screenWidth, authProvider),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Slider Section: tampilkan 5 edukasi dari SobiTime
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      height: 122,
                      // Hapus background ungu
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        // color: AppColors.primary_10, // dihapus
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(educations.length, (i) {
                            final edu = educations[i];
                            final thumbnail = getYoutubeThumbnail(edu.videoUrl);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  context.push('/education-detail/${edu.id}');
                                },
                                child: Container(
                                  width:
                                      screenWidth -
                                      64, // card width sama dengan komponen di bawahnya
                                  height: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          thumbnail,
                                          width: screenWidth - 48,
                                          height: 160,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => Container(
                                                color: AppColors.default_30,
                                                width: screenWidth - 48,
                                                height: 160,
                                              ),
                                        ),
                                      ),
                                      // Judul dan tombol "Buka"
                                      Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Tampilkan judul edukasi
                                            
                                            const SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'Buka',
                                                  style: AppTextStyles
                                                      .body_4_bold
                                                      .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  // Pertanyaan
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanam Amal Hari Ini',
                          style: AppTextStyles.heading_4_bold.copyWith(
                            color: AppColors.primary_90,
                          ),
                        ),
                        Text(
                          (selectedEmotion != -1 &&
                                  currentQuestion ==
                                      emotionQuestions.length - 1)
                              ? 'Kamu sudah melakukan kerja bagus hari ini, kembali hijrah untuk besok'
                              : emotionQuestions[currentQuestion],
                          style: AppTextStyles.body_3_medium.copyWith(
                            color: AppColors.primary_90,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Emoticon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(emotionNames.length, (index) {
                            final isAnswered =
                                selectedEmotion != -1 ||
                                (currentQuestion ==
                                        emotionQuestions.length - 1 &&
                                    selectedEmotion != -1);
                            final isSelected = selectedEmotion == index;
                            final isAnimating =
                                isSelected && isAnimatingEmotion;
                            double targetSize;
                            if (isAnimatingEmotion) {
                              targetSize = isAnimating ? 80 : 36;
                            } else {
                              targetSize = 56;
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: GestureDetector(
                                onTap:
                                    isAnswered || isAnimatingEmotion
                                        ? null
                                        : () => _onEmotionSelected(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOutCubic,
                                  width: targetSize,
                                  height: targetSize,
                                  child: _EmotionAnimatedImage(
                                    key: ValueKey(
                                      '${emotionNames[index]}-$isSelected-$isAnimatingEmotion-$currentQuestion',
                                    ),
                                    emotion: emotionNames[index],
                                    isSelected: isSelected,
                                    isAnimating: isAnimating,
                                    size: targetSize,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        // Pohon
                        Center(
                          child: Container(
                            width: screenWidth * 0.85,
                            height: screenWidth * 0.65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.primary_30,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.default_30.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (totalPoint == 0)
                                  _AnimatedFlower(
                                    asset: treeSvgAssets[0],
                                    width: screenWidth * 0.7,
                                    height: screenWidth * 0.6,
                                    delayMs: 0,
                                  ),
                                if (totalPoint > 0)
                                  ...List.generate(
                                    totalPoint.clamp(
                                          0,
                                          treeSvgAssets.length - 1,
                                        ) +
                                        1,
                                    (i) => _AnimatedFlower(
                                      asset: treeSvgAssets[i],
                                      width: screenWidth * 0.7,
                                      height: screenWidth * 0.6,
                                      delayMs: i * 200,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Jurnal
                        Text(
                          'Jurnal Hari Ini',
                          style: AppTextStyles.heading_6_bold.copyWith(
                            color: AppColors.primary_90,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.default_10,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary_30),
                          ),
                          child: TextField(
                            controller: journalController,
                            maxLines: 5,
                            style: AppTextStyles.body_3_regular.copyWith(
                              color: AppColors.primary_90,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type here...',
                              hintStyle: AppTextStyles.body_3_regular.copyWith(
                                color: AppColors.default_90,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            onChanged: (val) {
                              _saveCache();
                            },
                          ),
                        ),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth, AuthProvider authProvider) {
    final username = authProvider.user?.username ?? '...';
    final avatar = authProvider.user?.avatar ?? 1;
    final avatarAsset = 'assets/profil/Profil $avatar.png';
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary_50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 28, right: 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      avatarAsset,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Assalammualaikum,',
                        style: AppTextStyles.body_5_regular.copyWith(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        username,
                        style: AppTextStyles.heading_6_bold.copyWith(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedFlower extends StatefulWidget {
  final String asset;
  final double width;
  final double height;
  final int delayMs;

  const _AnimatedFlower({
    required this.asset,
    required this.width,
    required this.height,
    required this.delayMs,
    super.key,
  });

  @override
  State<_AnimatedFlower> createState() => _AnimatedFlowerState();
}

class _AnimatedFlowerState extends State<_AnimatedFlower>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    // Ubah durasi fade animasi pohon jika ingin lebih lama
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // ini untuk animasi pohon
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Image.asset(
        widget.asset,
        fit: BoxFit.contain,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}

class _EmotionAnimatedImage extends StatefulWidget {
  final String emotion;
  final bool isSelected;
  final bool isAnimating;
  final double size;

  const _EmotionAnimatedImage({
    required this.emotion,
    required this.isSelected,
    required this.isAnimating,
    required this.size,
    super.key,
  });

  @override
  State<_EmotionAnimatedImage> createState() => _EmotionAnimatedImageState();
}

class _EmotionAnimatedImageState extends State<_EmotionAnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _completedCount = 0;
  static const int _loopCount = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(_onStatusChanged);
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _completedCount++;
      if (_completedCount < _loopCount) {
        _controller
          ..reset()
          ..forward();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void didUpdateWidget(covariant _EmotionAnimatedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && widget.isAnimating) {
      _completedCount = 0;
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelected && widget.isAnimating) {
      return Lottie.asset(
        'assets/lottie/${widget.emotion}.json',
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        controller: _controller,
        repeat: false,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration * 3
            ..reset()
            ..forward();
        },
      );
    } else {
      return Image.asset(
        'assets/emoji/${widget.emotion}.webp',
        key: UniqueKey(),
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
      );
    }
  }
}

// Tambahkan fungsi thumbnail youtube jika belum ada
String getYoutubeThumbnail(String url) {
  Uri uri = Uri.parse(url);
  if (uri.host.contains('youtu.be')) {
    return "https://img.youtube.com/vi/${uri.pathSegments.first}/hqdefault.jpg";
  } else {
    return "https://img.youtube.com/vi/${uri.queryParameters['v']}/hqdefault.jpg";
  }
}
