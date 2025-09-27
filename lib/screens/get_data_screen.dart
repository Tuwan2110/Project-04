import 'package:flutter/material.dart';
import '../controllers/student_controller.dart';
import '../models/student_models.dart';
import 'create_data_screen.dart';
import 'no_internet_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_data_screen.dart';

class GetDataScreen extends StatefulWidget {
  const GetDataScreen({super.key});

  @override
  State<GetDataScreen> createState() => _GetDataScreenState();
}

class _GetDataScreenState extends State<GetDataScreen> {
  final StudentController ctrl = StudentController();
  bool _loading = false;
  List<Siswa> list = [];
  bool _hasError = false;
  List<Siswa> allStudents = [];

  late final Connectivity _connectivity;
  late final Stream<List<ConnectivityResult>> _connectivityStream;
  bool _isDialogVisible = false;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _hasError = false;
    });
    try {
      final students = await ctrl.getAllStudents();
      setState(() {
        allStudents = students;
        list = students;
        _hasError = list.isEmpty;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        list = [];
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _confirmDelete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Hapus Data', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        content: Text('Yakin ingin menghapus data ini?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(c, true),
            child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await ctrl.deleteStudent(id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data dihapus')));
        await _load();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _load();

    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;

    _connectivityStream.listen(
      (List<ConnectivityResult> results) {
        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
        if (result == ConnectivityResult.none && !_isDialogVisible) {
          _isDialogVisible = true;
          showNoConnectionDialog(context);
        } else if (result != ConnectivityResult.none && _isDialogVisible) {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          _isDialogVisible = false;
        }
      },
    );
  }

  List<Siswa> searchStudents(String query, List<Siswa> allStudents) {
    if (query.isEmpty) return allStudents;
    final q = query.toLowerCase();
    return allStudents.where((s) {
      return (s.namaLengkap.toLowerCase().contains(q)) || (s.nisn.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            "Daftar Siswa",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: TextField(
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Cari Nama atau NISN",
                  hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onChanged: (value) {
                  setState(() {
                    list = searchStudents(value, allStudents);
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Tidak ada data', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _load,
                        icon: Icon(Icons.refresh, color: Colors.white),
                        label: Text('Coba lagi', style: GoogleFonts.poppins(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final s = list[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Card besar dengan gaya berbeda
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Foto kecil atau ikon di kiri
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.deepPurple,
                                    child: Icon(Icons.person, color: Colors.white, size: 30),
                                  ),
                                  SizedBox(width: 20),
                                  // Data utama
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          s.namaLengkap,
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'NISN: ${s.nisn}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // Tombol di bawah
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditDataScreen(siswa: s))),
                                    icon: Icon(Icons.edit, size: 20, color: Colors.white),
                                    label: Text('Edit', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    onPressed: () => _confirmDelete(s.id!),
                                    icon: Icon(Icons.delete, size: 20, color: Colors.white),
                                    label: Text('Hapus', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateDataScreen())),
        backgroundColor: Colors.deepPurpleAccent,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Tambah Siswa', style: GoogleFonts.poppins(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}