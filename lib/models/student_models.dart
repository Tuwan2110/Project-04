// models/student_model.dart
import 'alamat_models.dart';

class Siswa {
  final int? id;
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String tempat;
  final DateTime tanggalLahir;
  final String noTelepon;
  final String nik;

  // alamat_id relasi ke tabel alamat
  final int? alamatId;
  final Alamat? alamat; // optional jika query join

  // orang tua di dalam tabel siswa (sesuai keputusanmu)
  final String namaAyah;
  final String namaIbu;
  final String? namaWali;

  // optional additional address fields
  final String? jalan;
  final String? rt;
  final String? rw;

  final int? alamatOrtuId; // FK alamat ortu
  final Alamat? alamatOrtu;
  final String jalanOrtu;
  final String rtOrtu;
  final String rwOrtu;

  Siswa({
    this.id,
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.agama,
    required this.tempat,
    required this.tanggalLahir,
    required this.noTelepon,
    required this.nik,
    this.alamatId,
    this.alamat,
    required this.namaAyah,
    required this.namaIbu,
    this.namaWali,
    this.alamatOrtu,
    this.jalan,
    this.rt,
    this.rw,
    this.alamatOrtuId,
    required this.jalanOrtu,
    required this.rtOrtu,
    required this.rwOrtu,
  });

  // untuk insert/update ke DB
  Map<String, dynamic> toJson() => {
        'nisn': nisn,
        'nama_lengkap': namaLengkap,
        'jenis_kelamin': jenisKelamin,
        'agama': agama,
        'tanggal_lahir': tanggalLahir.toIso8601String().split('T')[0],
        'no_telepon': noTelepon,
        'nik': nik,
        'alamat_id': alamatId,
        'nama_ayah': namaAyah,
        'nama_ibu': namaIbu,
        'nama_wali': namaWali,
        'jalan': jalan,
        'rt': rt,
        'rw': rw,
        'alamat_ortu_id': alamatOrtuId,
        'jalan_ortu': jalanOrtu,
        'rt_ortu': rtOrtu,
        'rw_ortu': rwOrtu,
      };

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id'] as int?,
      nisn: json['nisn'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      agama: json['agama'] ?? '',
      tempat: json['tempat'] ?? '',
      tanggalLahir: json['tanggal_lahir'] != null ? DateTime.parse(json['tanggal_lahir']) : DateTime(2000),
      noTelepon: json['no_telepon'] ?? '',
      nik: json['nik'] ?? '',
      alamatId: json['alamat_id'] as int?,
      alamat: json['alamat'] != null ? Alamat.fromJson(Map<String, dynamic>.from(json['alamat'])) : null,
      namaAyah: json['nama_ayah'] ?? '',
      namaIbu: json['nama_ibu'] ?? '',
      namaWali: json['nama_wali'] as String?,
      jalan: json['jalan'] as String?,
      rt: json['rt'] as String?,
      rw: json['rw'] as String?,
      alamatOrtuId: json['alamat_ortu_id'] as int?,
      jalanOrtu: json['jalan_ortu'] ?? '',
      rtOrtu: json['rt_ortu'] ?? '',
      rwOrtu: json['rw_ortu'] ?? '',
    );
  }
}
