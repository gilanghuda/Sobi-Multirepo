class TafsirAyatEntity {
  final int ayat;
  final String teks;

  TafsirAyatEntity({required this.ayat, required this.teks});
}



class AyahTafsirItemEntity {
  final int ayah;
  final List<String> arab;
  final List<String> indo;

  AyahTafsirItemEntity({
    required this.ayah,
    required this.arab,
    required this.indo,
  });
}

class AyahTafsirEntity {
  final int surah;
  final String surahName;
  final List<AyahTafsirItemEntity> items;
  final String tafsir;

  AyahTafsirEntity({
    required this.surah,
    required this.surahName,
    required this.items,
    required this.tafsir,
  });
}
