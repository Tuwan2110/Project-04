import 'package:connectivity_plus/connectivity_plus.dart';
import '../helpers/supabase_helper.dart';
import '../models/alamat_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlamatController {
  final SupabaseClient _client = SupabaseHelper.client;

  // cek koneksi internet
  Future<bool> hasInternet() async {
    final c = await Connectivity().checkConnectivity();
    return c != ConnectivityResult.none;
  }

  // search dusun (autocomplete)
  Future<List<Alamat>> searchDusun(String q) async {
    if (q.trim().isEmpty) return [];
    if (!await hasInternet()) throw Exception('Tidak ada koneksi internet');
    try {
      final res = await _client
          .from('alamat')
          .select()
          .ilike('dusun', '%$q%')
          .limit(30);
      final list = (res as List)
          .map((e) => Alamat.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return list;
    } on PostgrestException catch (e) {
      throw Exception('Supabase error: ${e.message}');
    } catch (e) {
      throw Exception('Error mencari dusun: $e');
    }
  }

  // ambil detail alamat
  Future<Alamat?> getDetailByDusun(String dusun) async {
    if (!await hasInternet()) throw Exception('Tidak ada koneksi internet');
    try {
      final res = await _client
          .from('alamat')
          .select('id, dusun, desa, kecamatan, kabupaten, provinsi, kode_pos')
          .ilike('dusun', dusun)
          .limit(1)
          .maybeSingle();
      if (res == null) return null;
      return Alamat.fromJson(Map<String, dynamic>.from(res));
    } on PostgrestException catch (e) {
      throw Exception('Supabase error: ${e.message}');
    } catch (e) {
      throw Exception('Gagal ambil detail alamat: $e');
    }
  }

  // ambil alamat by id
  Future<Alamat?> getById(int id) async {
    if (!await hasInternet()) throw Exception('Tidak ada koneksi internet');
    try {
      final res = await _client.from('alamat').select().eq('id', id).maybeSingle();
      if (res == null) return null;
      return Alamat.fromJson(Map<String, dynamic>.from(res));
    } catch (e) {
      throw Exception('Gagal ambil alamat by id: $e');
    }
  }
}