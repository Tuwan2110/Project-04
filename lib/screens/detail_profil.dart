// screens/detail_siswa_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/student_models.dart';

class DetailSiswaScreen extends StatelessWidget {
  final Siswa siswa;

  const DetailSiswaScreen({super.key, required this.siswa});

  String getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0];
    return parts[0][0] + parts[1][0];
  }

  Widget infoCard(String title, String? value) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Color(0xFF2196F3), width: 1.5), 
        ),
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2196F3))), 
              SizedBox(height: 4),
              Text(value ?? '-', style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3), 
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text("Detail Siswa", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white)),
                SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF2196F3), 
                    child: Text(
                      getInitials(siswa.namaLengkap),
                      style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Info Siswa
                  infoCard("Nama Lengkap", siswa.namaLengkap),
                  infoCard("NISN", siswa.nisn),
                  infoCard("Jenis Kelamin", siswa.jenisKelamin),
                  infoCard("Agama", siswa.agama),
                  infoCard("Tanggal Lahir", siswa.tanggalLahir?.toString()),
                  infoCard("No Telepon", siswa.noTelepon),
                  infoCard("NIK", siswa.nik),
                  infoCard(
                    "Alamat",
                    "${siswa.jalan}, RT ${siswa.rt}, RW ${siswa.rw}",
                  ),
                  SizedBox(height: 16),
                  // Info Orang Tua
                  infoCard("Nama Ayah", siswa.namaAyah),
                  infoCard("Nama Ibu", siswa.namaIbu),
                  infoCard("Nama Wali", siswa.namaWali),
                  infoCard(
                    "Alamat Orang Tua",
                    "${siswa.jalanOrtu}, RT ${siswa.rtOrtu}, RW ${siswa.rwOrtu}",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}