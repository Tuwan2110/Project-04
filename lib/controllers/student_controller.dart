import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/supabase_helper.dart';
import '../models/student_models.dart';
import 'data_alamat.dart';

class StudentController {
  final SupabaseClient _client = SupabaseHelper.client;
  final AlamatController alamatController = AlamatController();

  // create
  Future<void> createStudent(Siswa s) async {
    if (!await alamatController.hasInternet()) throw Exception('Tidak ada koneksi internet');
    try {
      await _client.from('siswa').insert([s.toJson()]);
    } on PostgrestException catch (e) {
      throw Exception('Supabase error saat menyimpan: ${e.message}');
    } catch (e) {
      throw Exception('Gagal menyimpan data siswa: $e');
    }
  }

  // read all (join alamat)
  Future<List<Siswa>> getAllStudents() async {
    if (!await alamatController.hasInternet()) throw Exception('Tidak ada koneksi internet');
    try {
      final res = await _client
          .from('siswa')
          .select('*, alamat_siswa:alamat_id(id, dusun, desa, kecamatan, kabupaten, provinsi, kode_pos), alamat_ortu:alamat_ortu_id(id, dusun, desa, kecamatan, kabupaten, provinsi, kode_pos)');
      final list = (res as List)
          .map((e) => Siswa.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return list;
    } on PostgrestException catch (e) {
      throw Exception('Supabase error saat mengambil data: ${e.message}');
    } catch (e) {
      throw Exception('Gagal mengambil data siswa: $e');
    }
  }

  // update
  Future<void> updateStudent(int id, Siswa s) async {
    if (!await alamatController.hasInternet()) throw Exception('Tidak ada koneksi internet');
    try {
      await _client.from('siswa').update(s.toJson()).eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Supabase error saat update: ${e.message}');
    } catch (e) {
      throw Exception('Gagal update data: $e');
    }
  }

  // delete
  Future<void> deleteStudent(int id) async {
    if (!await alamatController.hasInternet()) throw Exception('Tidak ada koneksi internet');
    try {
      await _client.from('siswa').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Supabase error saat delete: ${e.message}');
    } catch (e) {
      throw Exception('Gagal menghapus data: $e');
    }
  }
}