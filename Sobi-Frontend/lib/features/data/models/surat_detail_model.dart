import '../../domain/entities/surat_detail_entity.dart';

class SuratAyatModel {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;

  SuratAyatModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
  });

  factory SuratAyatModel.fromJson(Map<String, dynamic> json) {
    return SuratAyatModel(
      nomorAyat: json['nomorAyat'],
      teksArab: json['teksArab'],
      teksLatin: json['teksLatin'],
      teksIndonesia: json['teksIndonesia'],
    );
  }

  SuratAyatEntity toEntity() {
    return SuratAyatEntity(
      nomorAyat: nomorAyat,
      teksArab: teksArab,
      teksLatin: teksLatin,
      teksIndonesia: teksIndonesia,
    );
  }
}

class SuratSimpleModel {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;

  SuratSimpleModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
  });

  factory SuratSimpleModel.fromJson(Map<String, dynamic> json) {
    return SuratSimpleModel(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
    );
  }

  SuratSimpleEntity toEntity() {
    return SuratSimpleEntity(
      nomor: nomor,
      nama: nama,
      namaLatin: namaLatin,
      jumlahAyat: jumlahAyat,
    );
  }
}

class SuratDetailModel {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final List<SuratAyatModel> ayat;
  final SuratSimpleModel? suratSelanjutnya;
  final SuratSimpleModel? suratSebelumnya;

  SuratDetailModel({
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

  factory SuratDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return SuratDetailModel(
      nomor: data['nomor'],
      nama: data['nama'],
      namaLatin: data['namaLatin'],
      jumlahAyat: data['jumlahAyat'],
      tempatTurun: data['tempatTurun'],
      arti: data['arti'],
      deskripsi: data['deskripsi'],
      ayat: (data['ayat'] as List)
          .map((e) => SuratAyatModel.fromJson(e))
          .toList(),
      suratSelanjutnya: (data['suratSelanjutnya'] is Map<String, dynamic>)
          ? SuratSimpleModel.fromJson(data['suratSelanjutnya'])
          : null,
      suratSebelumnya: (data['suratSebelumnya'] is Map<String, dynamic>)
          ? SuratSimpleModel.fromJson(data['suratSebelumnya'])
          : null,
    );
  }

  SuratDetailEntity toEntity() {
    return SuratDetailEntity(
      nomor: nomor,
      nama: nama,
      namaLatin: namaLatin,
      jumlahAyat: jumlahAyat,
      tempatTurun: tempatTurun,
      arti: arti,
      deskripsi: deskripsi,
      ayat: ayat.map((a) => a.toEntity()).toList(),
      suratSelanjutnya: suratSelanjutnya?.toEntity(),
      suratSebelumnya: suratSebelumnya?.toEntity(),
    );
  }
}
