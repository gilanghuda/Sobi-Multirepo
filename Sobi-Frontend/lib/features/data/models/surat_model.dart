import '../../domain/entities/surat_entity.dart';

class SuratModel {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final List<int> juz;

  SuratModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.juz,
  });

  factory SuratModel.fromJson(Map<String, dynamic> json) {
    final nomor = json['nomor'] as int;
    return SuratModel(
      nomor: nomor,
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      juz: _getJuz(nomor),
    );
  }

  SuratEntity toEntity() {
    return SuratEntity(
      nomor: nomor,
      nama: nama,
      namaLatin: namaLatin,
      jumlahAyat: jumlahAyat,
      tempatTurun: tempatTurun,
      arti: arti,
      deskripsi: deskripsi,
      juz: juz,
    );
  }

  static List<int> _getJuz(int nomor) {
  switch (nomor) {
    case 1: return [1]; // Al-Fatihah
    case 2: return [1, 2, 3]; // Al-Baqarah
    case 3: return [3, 4]; // Ali Imran
    case 4: return [4, 5]; // An-Nisa
    case 5: return [6]; // Al-Maidah
    case 6: return [7, 8]; // Al-An'am
    case 7: return [8, 9]; // Al-A'raf
    case 8: return [9, 10]; // Al-Anfal
    case 9: return [10, 11]; // At-Taubah
    case 10: return [11]; // Yunus
    case 11: return [11, 12]; // Hud
    case 12: return [12, 13]; // Yusuf
    case 13: return [13]; // Ar-Ra'd
    case 14: return [13]; // Ibrahim
    case 15: return [14]; // Al-Hijr
    case 16: return [14, 15, 16]; // An-Nahl
    case 17: return [15]; // Al-Isra
    case 18: return [15, 16]; // Al-Kahfi
    case 19: return [16]; // Maryam
    case 20: return [16]; // Taha
    case 21: return [17]; // Al-Anbiya
    case 22: return [17]; // Al-Hajj
    case 23: return [18]; // Al-Mu'minun
    case 24: return [18]; // An-Nur
    case 25: return [18, 19]; // Al-Furqan
    case 26: return [19]; // Asy-Syu'ara
    case 27: return [19, 20]; // An-Naml
    case 28: return [20]; // Al-Qasas
    case 29: return [20, 21]; // Al-Ankabut
    case 30: return [21]; // Ar-Rum
    case 31: return [21]; // Luqman
    case 32: return [21]; // As-Sajdah
    case 33: return [21, 22]; // Al-Ahzab
    case 34: return [22]; // Saba
    case 35: return [22, 23]; // Fatir
    case 36: return [23]; // Yasin
    case 37: return [23]; // As-Saffat
    case 38: return [23]; // Sad
    case 39: return [23, 24]; // Az-Zumar
    case 40: return [24, 25]; // Ghafir
    case 41: return [24, 25]; // Fussilat
    case 42: return [25]; // Asy-Syura
    case 43: return [25]; // Az-Zukhruf
    case 44: return [25, 26]; // Ad-Dukhan
    case 45: return [25]; // Al-Jasiyah
    case 46: return [26]; // Al-Ahqaf
    case 47: return [26]; // Muhammad
    case 48: return [26]; // Al-Fath
    case 49: return [26]; // Al-Hujurat
    case 50: return [26]; // Qaf
    case 51: return [26, 27]; // Az-Zariyat
    case 52: return [27]; // At-Tur
    case 53: return [27]; // An-Najm
    case 54: return [27]; // Al-Qamar
    case 55: return [27]; // Ar-Rahman
    case 56: return [27]; // Al-Waqi'ah
    case 57: return [27]; // Al-Hadid
    case 58: return [28]; // Al-Mujadila
    case 59: return [28]; // Al-Hasyr
    case 60: return [28]; // Al-Mumtahanah
    case 61: return [28]; // As-Saff
    case 62: return [28]; // Al-Jumu'ah
    case 63: return [28]; // Al-Munafiqun
    case 64: return [28]; // At-Taghabun
    case 65: return [28]; // At-Talaq
    case 66: return [28]; // At-Tahrim
    case 67: return [29]; // Al-Mulk
    case 68: return [29]; // Al-Qalam
    case 69: return [29]; // Al-Haqqah
    case 70: return [29]; // Al-Ma'arij
    case 71: return [29]; // Nuh
    case 72: return [29]; // Al-Jinn
    case 73: return [29]; // Al-Muzzammil
    case 74: return [29]; // Al-Muddaththir
    case 75: return [29]; // Al-Qiyamah
    case 76: return [29]; // Al-Insan
    case 77: return [29]; // Al-Mursalat
    case 78: return [30]; // An-Naba
    case 79: return [30]; // An-Nazi'at
    case 80: return [30]; // Abasa
    case 81: return [30]; // At-Takwir
    case 82: return [30]; // Al-Infitar
    case 83: return [30]; // Al-Mutaffifin
    case 84: return [30]; // Al-Insyiqaq
    case 85: return [30]; // Al-Buruj
    case 86: return [30]; // At-Tariq
    case 87: return [30]; // Al-A'la
    case 88: return [30]; // Al-Gasyiyah
    case 89: return [30]; // Al-Fajr
    case 90: return [30]; // Al-Balad
    case 91: return [30]; // Asy-Syams
    case 92: return [30]; // Al-Lail
    case 93: return [30]; // Ad-Duha
    case 94: return [30]; // Asy-Syarh
    case 95: return [30]; // At-Tin
    case 96: return [30]; // Al-'Alaq
    case 97: return [30]; // Al-Qadr
    case 98: return [30]; // Al-Bayyina
    case 99: return [30]; // Az-Zalzalah
    case 100: return [30]; // Al-Adiyat
    case 101: return [30]; // Al-Qari'ah
    case 102: return [30]; // At-Takathur
    case 103: return [30]; // Al-Asr
    case 104: return [30]; // Al-Humazah
    case 105: return [30]; // Al-Fil
    case 106: return [30]; // Quraisy
    case 107: return [30]; // Al-Ma'un
    case 108: return [30]; // Al-Kautsar
    case 109: return [30]; // Al-Kafirun
    case 110: return [30]; // An-Nasr
    case 111: return [30]; // Al-Lahab
    case 112: return [30]; // Al-Ikhlas
    case 113: return [30]; // Al-Falaq
    case 114: return [30]; // An-Nas
    default: return [];
  }
}

}
