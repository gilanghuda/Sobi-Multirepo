import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/presentation/provider/education_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';

// Fungsi ambil thumbnail dari url YouTube
String getYoutubeThumbnail(String url) {
  Uri uri = Uri.parse(url);
  if (uri.host.contains('youtu.be')) {
    return "https://img.youtube.com/vi/${uri.pathSegments.first}/hqdefault.jpg";
  } else {
    return "https://img.youtube.com/vi/${uri.queryParameters['v']}/hqdefault.jpg";
  }
}

class SobiTimeDetailScreen extends StatefulWidget {
  final String educationId;
  const SobiTimeDetailScreen({required this.educationId, Key? key})
    : super(key: key);

  @override
  State<SobiTimeDetailScreen> createState() => _SobiTimeDetailScreenState();
}

class _SobiTimeDetailScreenState extends State<SobiTimeDetailScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<EducationProvider>(context, listen: false);
      await provider.fetchEducationDetail(widget.educationId);
      final edu = provider.educationDetail;
      if (edu != null) {
        final videoId = YoutubePlayer.convertUrlToId(edu.videoUrl);
        setState(() {
          _controller = YoutubePlayerController(
            initialVideoId: videoId ?? '',
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EducationProvider>(context);
    final edu = provider.educationDetail;
    if (provider.isLoading || edu == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Format tanggal
    final createdAt = DateFormat('d MMMM yyyy').format(edu.createdAt);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            edu.title,
            style: AppTextStyles.heading_6_bold.copyWith(
              color: AppColors.primary_90,
              fontSize: 16, // kecilkan font
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video player (tidak dalam scroll)
            if (_controller != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                ),
              ),
            const SizedBox(height: 18),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subjudul
                    Text(
                      edu.subtitle,
                      style: AppTextStyles.body_3_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Waktu dibuat
                    Text(
                      createdAt,
                      style: AppTextStyles.body_5_regular.copyWith(
                        color: AppColors.default_90,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Row author & duration
                    Row(
                      children: [
                        // Author
                        Image.asset(
                          'assets/icons/detail_time.png',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          edu.author,
                          style: AppTextStyles.body_4_regular.copyWith(
                            color: AppColors.primary_50,
                          ),
                        ),
                        const SizedBox(width: 18),
                        // Duration
                        Image.asset(
                          'assets/icons/durasi.png',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          edu.duration,
                          style: AppTextStyles.body_4_regular.copyWith(
                            color: AppColors.primary_50,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Deskripsi
                    Text(
                      'Deskripsi',
                      style: AppTextStyles.body_3_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      edu.description,
                      style: AppTextStyles.body_4_regular.copyWith(
                        color: AppColors.primary_90,
                      ),
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
