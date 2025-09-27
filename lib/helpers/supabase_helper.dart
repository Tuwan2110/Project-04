// helpers/supabase_helper.dart
import 'package:supabase_flutter/supabase_flutter.dart';

const String SUPABASE_URL = 'https://zxjssoqbngscdoebcars.supabase.co'; // ganti
const String SUPABASE_ANNON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp4anNzb3FibmdzY2RvZWJjYXJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwNjY1NjcsImV4cCI6MjA3MzY0MjU2N30.XxVvnR3SX1DOwRYYishBWj5pSEBNxo20YC0S1eJBHZo'; // ganti

class SupabaseHelper {
  static Future<void> init() async {
    await Supabase.initialize(
      url: SUPABASE_URL,
      anonKey: SUPABASE_ANNON_KEY,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
