import 'package:flutter/material.dart';
import 'package:project04tuwan/screens/get_data_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zxjssoqbngscdoebcars.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp4anNzb3FibmdzY2RvZWJjYXJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwNjY1NjcsImV4cCI6MjA3MzY0MjU2N30.XxVvnR3SX1DOwRYYishBWj5pSEBNxo20YC0S1eJBHZo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tampilan UI',
      debugShowCheckedModeBanner: false,
      home: const GetDataScreen(),
    );
  }
}