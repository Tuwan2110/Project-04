// lib/utils/connection_helper.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

void showNoConnectionDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('nointernet.jpeg', width: 200, height: 200, ),
            SizedBox(height: 16),
            Text("Koneksi Terputus", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Silakan Periksa Jaringan Anda.", style: GoogleFonts.poppins()),
          ],
        ),
      );
    },
  );
}