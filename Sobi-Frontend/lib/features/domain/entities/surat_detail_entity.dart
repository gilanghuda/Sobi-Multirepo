class SuratAyatEntity {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;

  SuratAyatEntity({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
  });
}

class SuratDetailEntity {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final List<SuratAyatEntity> ayat;
  final SuratSimpleEntity? suratSelanjutnya;
  final SuratSimpleEntity? suratSebelumnya;

  SuratDetailEntity({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.ayat,
    this.suratSelanjutnya,
    this.suratSebelumnya,
  });
}

class SuratSimpleEntity {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;

  SuratSimpleEntity({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
  });
}
