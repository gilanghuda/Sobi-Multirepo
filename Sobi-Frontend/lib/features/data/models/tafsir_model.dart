import '../../domain/entities/tafsir_entity.dart';

class TafsirAyatModel {
  final int ayat;
  final String teks;

  TafsirAyatModel({required this.ayat, required this.teks});

  factory TafsirAyatModel.fromJson(Map<String, dynamic> json) {
    return TafsirAyatModel(ayat: json['ayat'], teks: json['teks']);
  }

  TafsirAyatEntity toEntity() {
    return TafsirAyatEntity(ayat: ayat, teks: teks);
  }
}





class AyahTafsirItemModel {
  final int ayah;
  final List<String> arab;
  final List<String> indo;

  AyahTafsirItemModel({
    required this.ayah,
    required this.arab,
    required this.indo,
  });

  factory AyahTafsirItemModel.fromJson(Map<String, dynamic> json) {
    return AyahTafsirItemModel(
      ayah: json['ayah'],
      arab: (json['arab'] as List).map((e) => e.toString()).toList(),
      indo: (json['indo'] as List).map((e) => e.toString()).toList(),
    );
  }

  AyahTafsirItemEntity toEntity() {
    return AyahTafsirItemEntity(ayah: ayah, arab: arab, indo: indo);
  }
}

class AyahTafsirModel {
  final int surah;
  final String surahName;
  final List<AyahTafsirItemModel> items;
  final String tafsir;

  AyahTafsirModel({
    required this.surah,
    required this.surahName,
    required this.items,
    required this.tafsir,
  });

  factory AyahTafsirModel.fromJson(Map<String, dynamic> json) {
    return AyahTafsirModel(
      surah: json['surah'],
      surahName: json['surah_name'],
      items:
          (json['items'] as List)
              .map((e) => AyahTafsirItemModel.fromJson(e))
              .toList(),
      tafsir: json['tafsir'] ?? '',
    );
  }

  AyahTafsirEntity toEntity() {
    return AyahTafsirEntity(
      surah: surah,
      surahName: surahName,
      items: items.map((e) => e.toEntity()).toList(),
      tafsir: tafsir,
    );
  }
}
