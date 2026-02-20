import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/presentation/provider/education_provider.dart';
import 'package:go_router/go_router.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';
import 'sobi_time_detail_screen.dart';

// Fungsi untuk ambil thumbnail dari url YouTube
String getYoutubeThumbnail(String url) {
  Uri uri = Uri.parse(url);
  if (uri.host.contains('youtu.be')) {
    return "https://img.youtube.com/vi/${uri.pathSegments.first}/hqdefault.jpg";
  } else {
    return "https://img.youtube.com/vi/${uri.queryParameters['v']}/hqdefault.jpg";
  }
}

class SobiTimeScreen extends StatefulWidget {
  const SobiTimeScreen({super.key});

  @override
  State<SobiTimeScreen> createState() => _SobiTimeScreenState();
}

class _SobiTimeScreenState extends State<SobiTimeScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('[SCREEN] initState: call fetchEducations');
      final provider = Provider.of<EducationProvider>(context, listen: false);
      await provider.fetchEducations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EducationProvider>(context);
    final educations = provider.educations;
    final isLoading = provider.isLoading;

    // Filter edukasi berdasarkan judul yang mengandung searchText
    final filteredEducations =
        educations.where((edu) {
          return edu.title.toLowerCase().contains(searchText.toLowerCase());
        }).toList();

    // Debug: print list education di screen
    print('[SCREEN] educations: ${educations.map((e) => e.id).toList()}');
    print(
      '[SCREEN] filteredEducations: ${filteredEducations.map((e) => e.id).toList()}',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edukasi',
          style: AppTextStyles.heading_5_bold.copyWith(
            color: AppColors.primary_90,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primary_10,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'search text',
                  hintStyle: AppTextStyles.body_3_regular.copyWith(
                    color: AppColors.default_70,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.default_70),
                ),
                onChanged: (val) {
                  setState(() {
                    searchText = val;
                  });
                },
              ),
            ),
            // Grid video & photo
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: filteredEducations.length,
                        itemBuilder: (context, index) {
                          final edu = filteredEducations[index];
                          final thumbnail = getYoutubeThumbnail(edu.videoUrl);
                          return GestureDetector(
                            onTap: () {
                              context.push('/education-detail/${edu.id}');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.default_30,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        thumbnail,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => Container(
                                              color: AppColors.default_30,
                                            ),
                                      ),
                                    ),
                                  ),
                                  // Judul dengan background putih transparan di bawah
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.85),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            edu.title,
                                            style: AppTextStyles.body_3_bold
                                                .copyWith(
                                                  color: AppColors.primary_90,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            edu.subtitle,
                                            style: AppTextStyles.body_5_regular
                                                .copyWith(
                                                  color: AppColors.default_90,
                                                ),
                                            maxLines: 1,
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
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
