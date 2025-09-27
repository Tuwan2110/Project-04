// models/alamat_model.dart

class Alamat {
  final int id;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String provinsi;
  final String kodePos;

  Alamat({
    required this.id,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
  });

  // Factory untuk convert JSON (hasil query Supabase) menjadi model Alamat
  factory Alamat.fromJson(Map<String, dynamic> json) {
    return Alamat(
      id: json['id'] as int,
      dusun: (json['dusun'] ?? '') as String,
      desa: (json['desa'] ?? '') as String,
      kecamatan: (json['kecamatan'] ?? '') as String,
      kabupaten: (json['kabupaten'] ?? '') as String,
      provinsi: (json['provinsi'] ?? '') as String,
      kodePos: (json['kode_pos'] ?? '') as String,
    );
  }
}
