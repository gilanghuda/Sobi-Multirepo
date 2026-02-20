import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/domain/entities/tafsir_entity.dart';
import 'package:sobi/features/presentation/provider/sobi-quran_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';

class DetailSobiQuranScreen extends StatefulWidget {
  final int suratId;
  final int? halaman; // halaman opsional

  const DetailSobiQuranScreen({required this.suratId, this.halaman, Key? key})
    : super(key: key);

  @override
  State<DetailSobiQuranScreen> createState() => _DetailSobiQuranScreenState();
}

class _DetailSobiQuranScreenState extends State<DetailSobiQuranScreen> {
  late int pageIndex;

  @override
  void initState() {
    super.initState();
    // halaman di-parameterisasi, default ke 1 jika null
    pageIndex =
        (widget.halaman != null && widget.halaman! > 0)
            ? widget.halaman! - 1
            : 0;
    debugPrint(
      '[DETAIL QURAN] initState: suratId=${widget.suratId}, halaman=${widget.halaman}, pageIndex=$pageIndex',
    );
    final provider = Provider.of<SobiQuranProvider>(context, listen: false);
    provider.fetchSuratDetail(widget.suratId);
  }

  List<List<dynamic>> _splitPerPage(List<dynamic> list, int perPage) {
    List<List<dynamic>> pages = [];
    for (var i = 0; i < list.length; i += perPage) {
      pages.add(
        list.sublist(
          i,
          (i + perPage > list.length) ? list.length : i + perPage,
        ),
      );
    }
    return pages;
  }

  // Fungsi utilitas untuk mengubah angka ke angka Arab
  String arabicNumber(int n) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((d) => arabicDigits[int.parse(d)]).join();
  }

  // Fungsi untuk menggabungkan 5 ayat dengan bulatan nomor ayat (angka Arab)
  String concatAyat(List<dynamic> ayatList) {
    return ayatList
        .map((a) => '${a.teksArab}  \u06DD${arabicNumber(a.nomorAyat)}')
        .join(' ');
  }

  void _showArtiTafsirSheet(
    BuildContext context,
    List<dynamic> ayatList,
    String? tafsir,
  ) async {
    final provider = Provider.of<SobiQuranProvider>(context, listen: false);
    final int surah = widget.suratId;
    // Hitung ayat pertama pada halaman ini (index page dimulai dari 0)
    final int ayah = (pageIndex * 5) + 1;
    await provider.fetchAyahTafsir(surah: surah, ayah: ayah);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            final ayahTafsir = provider.ayahTafsir;
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.primary_70,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Stack(
                children: [
                  // SVG background di atas
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/svg/slider_top.svg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
                      left: 18,
                      right: 18,
                      bottom: 0,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 60,
                              height: 6,
                              margin: const EdgeInsets.only(bottom: 18),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Arti Ayat",
                              style: AppTextStyles.heading_5_bold.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // List ayat dan artinya dari ayahTafsir jika ada, jika tidak fallback ke ayatList
                          ...(ayahTafsir?.items ?? ayatList).map(
                            (a) => Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          // Cek tipe dan ambil field yang sesuai
                                          a is AyahTafsirItemEntity
                                              ? (a.arab.join(' '))
                                              : (a.teksArab ?? ''),
                                          textAlign: TextAlign.right,
                                          style: AppTextStyles.heading_5_bold
                                              .copyWith(
                                                fontFamily: 'ScheherazadeNew',
                                                fontSize: 22,
                                                color: Colors.white,
                                              ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            arabicNumber(
                                              a is AyahTafsirItemEntity
                                                  ? a.ayah
                                                  : (a.nomorAyat ?? 0),
                                            ),
                                            style: AppTextStyles.body_4_bold
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    a is AyahTafsirItemEntity
                                        ? (a.indo.join(' '))
                                        : (a.teksIndonesia ?? ''),
                                    style: AppTextStyles.body_4_regular
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Tafsir",
                            style: AppTextStyles.heading_6_bold.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ayahTafsir?.tafsir ??
                                tafsir ??
                                "Keutamaan Membaca Al-Fatihah dalam Salat\n\nAbu Hurairah r.a. berkata ... (dummy tafsir)",
                            style: AppTextStyles.body_4_regular.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SobiQuranProvider>(context);
    final detail = provider.suratDetail;

    // Split ayat per halaman (5 per halaman)
    final ayatPages = detail == null ? [] : _splitPerPage(detail.ayat, 5);
    final totalPages = ayatPages.length;

    // Gunakan pageIndex dari parameter, jangan reset ke 0 jika out of range
    int displayIndex =
        totalPages > 0 ? (pageIndex.clamp(0, totalPages - 1)) : 0;
    debugPrint(
      '[DETAIL QURAN] build: pageIndex=$pageIndex, displayIndex=$displayIndex, totalPages=$totalPages',
    );
    if (pageIndex >= totalPages && totalPages > 0) {
      pageIndex = 0;
      displayIndex = totalPages - 1;
      debugPrint(
        '[DETAIL QURAN] pageIndex reset to 0, displayIndex=$displayIndex',
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                detail?.nama ?? '',
                style: AppTextStyles.heading_4_bold.copyWith(
                  color: AppColors.primary_90,
                  fontFamily: 'ScheherazadeNew',
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '${detail?.namaLatin ?? ''} (${detail?.arti ?? ''})',
                style: AppTextStyles.body_3_regular.copyWith(
                  color: AppColors.primary_90,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      body:
          detail == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    // Kotak ayat gabungan per halaman
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary_30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            ayatPages.isEmpty
                                ? const SizedBox()
                                : Center(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      concatAyat(ayatPages[displayIndex]),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.heading_4_bold
                                          .copyWith(
                                            fontFamily: 'ScheherazadeNew',
                                            fontSize: 32, // kecilkan font arab
                                            color: AppColors.primary_90,
                                            height: 2.1,
                                          ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 8), // kecilkan jarak ke navigasi
                    // Navigasi halaman (tanpa angka, hanya tombol)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:
                              pageIndex < totalPages - 1
                                  ? () {
                                    setState(() {
                                      pageIndex++;
                                    });
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary_50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // persegi
                            ),
                            elevation: 0,
                            minimumSize: const Size(40, 40), // kecil
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 18, // kecilkan icon
                          ),
                        ),
                        const SizedBox(width: 20), // kecilkan jarak antar tombol
                        ElevatedButton(
                          onPressed:
                              pageIndex > 0
                                  ? () {
                                    setState(() {
                                      pageIndex--;
                                    });
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary_50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // persegi
                            ),
                            elevation: 0,
                            minimumSize: const Size(40, 40), // kecil
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 18, // kecilkan icon
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ), // turunkan agar mepet dengan lihat tafsir
                    // Tombol slider section dengan background SVG
                    GestureDetector(
                      onTap: () {
                        _showArtiTafsirSheet(
                          context,
                          ayatPages.isEmpty ? [] : ayatPages[displayIndex],
                          null,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Kubah SVG paling belakang dan lebih tinggi
                            Positioned(
                              top: -10,
                              left: 0,
                              right: 0,
                              child: SvgPicture.asset(
                                'assets/svg/kubah.svg',
                                width: 80,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Kotak ungu dengan rounded top left & right, mentok kanan kiri bawah
                            Positioned.fill(
                              top: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary_70,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                  ),
                                ),
                              ),
                            ),
                            // Tombol putih di atas kotak, tanpa padding horizontal
                            Positioned(
                              top: 32,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "Lihat Tafsir",
                                    style: AppTextStyles.body_4_bold.copyWith(
                                      color: AppColors.primary_90,
                                    ),
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
    );
  }
}
