import 'package:flutter/material.dart';

class FormDataController {
  // controllers untuk form
  final TextEditingController nisn = TextEditingController();
  final TextEditingController namaLengkap = TextEditingController();
  String? jenisKelamin;
  String? agama;
  final TextEditingController tempat = TextEditingController();
  final TextEditingController tanggalLahir = TextEditingController();
  DateTime? tanggalLahirTerpilih;
  final TextEditingController noTelepon = TextEditingController();
  final TextEditingController nik = TextEditingController();

  final TextEditingController jalan = TextEditingController();
  final TextEditingController rt = TextEditingController();
  final TextEditingController rw = TextEditingController();
  final TextEditingController dusun = TextEditingController();
  final TextEditingController desa = TextEditingController();
  final TextEditingController kecamatan = TextEditingController();
  final TextEditingController kabupaten = TextEditingController();
  final TextEditingController provinsi = TextEditingController();
  final TextEditingController kodePos = TextEditingController();

  final TextEditingController namaAyah = TextEditingController();
  final TextEditingController namaIbu = TextEditingController();
  final TextEditingController namaWali = TextEditingController();
  final TextEditingController alamatOrtu = TextEditingController();

  // alamat ortu
  final TextEditingController jalanOrtu = TextEditingController();
  final TextEditingController rtOrtu = TextEditingController();
  final TextEditingController rwOrtu = TextEditingController();
  final TextEditingController dusunOrtu = TextEditingController();
  final TextEditingController desaOrtu = TextEditingController();
  final TextEditingController kecamatanOrtu = TextEditingController();
  final TextEditingController kabupatenOrtu = TextEditingController();
  final TextEditingController provinsiOrtu = TextEditingController();
  final TextEditingController kodePosOrtu = TextEditingController();

  // reset semua field
  void reset() {
    nisn.clear();
    namaLengkap.clear();
    jenisKelamin = null;
    agama = null;
    tempat.clear();
    tanggalLahir.clear();
    noTelepon.clear();
    nik.clear();

    jalan.clear();
    rt.clear();
    rw.clear();
    dusun.clear();
    desa.clear();
    kecamatan.clear();
    kabupaten.clear();
    provinsi.clear();
    kodePos.clear();

    namaAyah.clear();
    namaIbu.clear();
    namaWali.clear();
    alamatOrtu.clear();

    jalanOrtu.clear();
    rtOrtu.clear();
    rwOrtu.clear();
    dusunOrtu.clear();
    desaOrtu.clear();
    kecamatanOrtu.clear();
    kabupatenOrtu.clear();
    provinsiOrtu.clear();
    kodePosOrtu.clear();
  }

  void dispose() {
    nisn.dispose();
    namaLengkap.dispose();
    tempat.dispose();
    noTelepon.dispose();
    nik.dispose();

    jalan.dispose();
    rt.dispose();
    rw.dispose();
    dusun.dispose();
    desa.dispose();
    kecamatan.dispose();
    kabupaten.dispose();
    provinsi.dispose();
    kodePos.dispose();

    namaAyah.dispose();
    namaIbu.dispose();
    namaWali.dispose();
    alamatOrtu.dispose();

    jalanOrtu.dispose();
    rtOrtu.dispose();
    rwOrtu.dispose();
    dusunOrtu.dispose();
    desaOrtu.dispose();
    kecamatanOrtu.dispose();
    kabupatenOrtu.dispose();
    provinsiOrtu.dispose();
    kodePosOrtu.dispose();
  }

  // -------------- VALIDATION FUNCTIONS --------------
  String? validateNama(String? v) {
    if (v == null || v.trim().isEmpty) return 'Field ini wajib diisi';
    return null;
  }

  String? validateNisn(String? v) {
    if (v == null || v.trim().isEmpty) return 'NISN wajib diisi';
    if (v.trim().length != 10) return 'NISN harus 10 karakter';
    if (!RegExp(r'^\d+$').hasMatch(v.trim())) return 'NISN harus angka';
    return null;
  }

  String? validateJenisKelamin(String? v) {
    if (v == null || v.isEmpty) return 'Pilih jenis kelamin';
    return null;
  }

  String? validateAgama(String? v) {
    if (v == null || v.isEmpty) return 'Pilih agama';
    return null;
  }

  String? validateTanggal() {
    if (tanggalLahir == null) return 'Tanggal lahir wajib diisi';
    return null;
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'No. telepon wajib diisi';
    if (!RegExp(r'^\d+$').hasMatch(v.trim())) return 'No. telepon harus angka';
    if (v.trim().length < 12 || v.trim().length > 15) return 'No. telepon harus 12-15 digit';
    return null;
  }

  String? validateNIK(String? v) {
    if (v == null || v.trim().isEmpty) return 'NIK wajib diisi';
    if (!RegExp(r'^\d+$').hasMatch(v.trim())) return 'NIK harus angka';
    if (v.trim().length < 15 || v.trim().length > 20) return 'Panjang NIK tampak tidak benar';
    return null;
  }

  String? validateJalan(String? v) {
    if (v == null || v.trim().isEmpty) return 'Jalan wajib diisi';
    return null;
  }

  String? validateRtRw(String? v) {
    if (v == null || v.trim().isEmpty) return 'RT/RW wajib diisi';
    if (!RegExp(r'^\d+$').hasMatch(v.trim())) return 'RT/RW harus angka';
    return null;
  }
}

String? validateOrtu(String? v) {
  if (v == null || v.trim().isEmpty) return 'Field ini wajib diisi';
  return null;
}