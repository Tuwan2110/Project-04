import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../controllers/form_data_controllers.dart';
import '../controllers/data_alamat.dart';
import '../controllers/student_controller.dart';
import '../models/student_models.dart';
import '../models/alamat_models.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateDataScreen extends StatefulWidget {
  const CreateDataScreen({super.key});

  @override
  State<CreateDataScreen> createState() => _CreateDataScreenState();
}

class _CreateDataScreenState extends State<CreateDataScreen> {
  final formCtrl = FormDataController();
  final alamatCtrl = AlamatController();
  final studentCtrl = StudentController();

  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _pickTanggal() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 16),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        formCtrl.tanggalLahirTerpilih = picked;
        formCtrl.tanggalLahir.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _onSelectDusun(Alamat a) async {
    setState(() => _loading = true);
    try {
      formCtrl.dusun.text = a.dusun ?? '';
      formCtrl.desa.text = a.desa ?? '';
      formCtrl.kecamatan.text = a.kecamatan ?? '';
      formCtrl.kabupaten.text = a.kabupaten ?? '';
      formCtrl.provinsi.text = a.provinsi ?? '';
      formCtrl.kodePos.text = a.kodePos ?? '';
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _onSelectDusunOrtu(Alamat a) async {
    setState(() => _loading = true);
    try {
      formCtrl.dusunOrtu.text = a.dusun ?? '';
      formCtrl.desaOrtu.text = a.desa ?? '';
      formCtrl.kecamatanOrtu.text = a.kecamatan ?? '';
      formCtrl.kabupatenOrtu.text = a.kabupaten ?? '';
      formCtrl.provinsiOrtu.text = a.provinsi ?? '';
      formCtrl.kodePosOrtu.text = a.kodePos ?? '';
    } finally {
      setState(() => _loading = false);
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      final vNama = formCtrl.validateNama(formCtrl.namaLengkap.text);
      final vNisn = formCtrl.validateNisn(formCtrl.nisn.text);
      final vJK = formCtrl.validateJenisKelamin(formCtrl.jenisKelamin);
      final vAgama = formCtrl.validateAgama(formCtrl.agama);
      final vTanggal = formCtrl.validateTanggal();
      final vPhone = formCtrl.validatePhone(formCtrl.noTelepon.text);
      final vNIK = formCtrl.validateNIK(formCtrl.nik.text);
      final errors = [
        vNama,
        vNisn,
        vJK,
        vAgama,
        vTanggal,
        vPhone,
        vNIK,
      ].where((e) => e != null);
      if (errors.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errors.first!)));
        return false;
      }
    }

    if (_currentStep == 1) {
      final vJalan = formCtrl.validateJalan(formCtrl.jalan.text);
      final vRt = formCtrl.validateRtRw(formCtrl.rt.text);
      final vRw = formCtrl.validateRtRw(formCtrl.rw.text);
      if (vJalan != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(vJalan)));
        return false;
      }
      if (vRt != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(vRt)));
        return false;
      }
      if (vRw != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(vRw)));
        return false;
      }
    }

    if (_currentStep == 2) {
      final vAyah = formCtrl.validateNama(formCtrl.namaAyah.text);
      final vIbu = formCtrl.validateNama(formCtrl.namaIbu.text);
      if (vAyah != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(vAyah)));
        return false;
      }
      if (vIbu != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(vIbu)));
        return false;
      }
    }
    return true;
  }

  Future<void> _submit() async {
    if (!_validateCurrentStep()) return;
    setState(() => _loading = true);
    try {
      int? alamatId;
      int? alamatOrtuId;

      try {
        final list = await alamatCtrl.searchDusun(formCtrl.dusun.text);
        if (list.isNotEmpty) alamatId = list.first.id;
      } catch (_) {}

      try {
        final listOrtu = await alamatCtrl.searchDusun(formCtrl.dusunOrtu.text);
        if (listOrtu.isNotEmpty) alamatOrtuId = listOrtu.first.id;
      } catch (_) {}

      final s = Siswa(
        nisn: formCtrl.nisn.text.trim(),
        namaLengkap: formCtrl.namaLengkap.text.trim().toUpperCase(),
        jenisKelamin: formCtrl.jenisKelamin ?? '',
        agama: formCtrl.agama ?? '',
        tempat: formCtrl.tempat.text,
        tanggalLahir: formCtrl.tanggalLahirTerpilih ?? DateTime(2000),
        noTelepon: formCtrl.noTelepon.text.trim(),
        nik: formCtrl.nik.text.trim(),
        alamatId: alamatId,
        namaAyah: formCtrl.namaAyah.text.trim().toUpperCase(),
        namaIbu: formCtrl.namaIbu.text.trim().toUpperCase(),
        namaWali: formCtrl.namaWali.text.trim().toUpperCase(),
        jalan: formCtrl.jalan.text.trim(),
        rt: formCtrl.rt.text.trim(),
        rw: formCtrl.rw.text.trim(),
        alamatOrtuId: alamatOrtuId,
        jalanOrtu: formCtrl.jalanOrtu.text.trim(),
        rtOrtu: formCtrl.rtOrtu.text.trim(),
        rwOrtu: formCtrl.rwOrtu.text.trim(),
      );

      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Simpan data siswa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Simpan'),
            ),
          ],
        ),
      );
      if (ok != true) {
        setState(() => _loading = false);
        return;
      }

      await studentCtrl.createStudent(s);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan')));
      formCtrl.reset();
      setState(() => _currentStep = 0);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.deepPurpleAccent),
      cursorColor: Colors.deepPurpleAccent,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        labelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
        filled: true,
        fillColor: Colors.green[50],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color:Colors.deepPurpleAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1),
        ),
      ),
    );
  }

  @override
  void dispose() {
    formCtrl.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: const [
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
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  "Tambah Data Siswa",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.deepPurpleAccent,
                ),
              ),
              child: Stepper(
                type: StepperType.horizontal, // Change to horizontal
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 2) {
                    if (_validateCurrentStep())
                      setState(() => _currentStep += 1);
                  } else {
                    _submit();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) setState(() => _currentStep -= 1);
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: details.onStepCancel,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Batal",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.deepPurpleAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _currentStep == 2 ? "Simpan" : "Lanjut",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                steps: [
                  // Step 0
                  Step(
                    title: Text(
                      'Data Siswa',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildTextField(
                            controller: formCtrl.nisn,
                            label: "NISN",
                            icon: Icons.badge,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.namaLengkap,
                            label: "Nama Lengkap",
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: formCtrl.jenisKelamin,
                            items: ['Laki-laki', 'Perempuan']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: GoogleFonts.poppins(
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => formCtrl.jenisKelamin = v),
                            decoration: InputDecoration(
                              labelText: "Jenis Kelamin",
                              labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                              prefixIcon: const Icon(
                                Icons.wc,
                                color: Colors.deepPurpleAccent,
                              ),
                              filled: true,
                              fillColor: Colors.green[50],
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.deepPurpleAccent,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.deepPurpleAccent,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: formCtrl.agama,
                            items:
                                [
                                      'Islam',
                                      'Kristen Protestan',
                                      'Katolik',
                                      'Hindu',
                                      'Buddha',
                                      'Konghucu',
                                      'Lainnya',
                                    ]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: GoogleFonts.poppins(
                                            color: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) =>
                                setState(() => formCtrl.agama = v),
                            decoration: InputDecoration(
                              labelText: "Agama",
                              labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                              prefixIcon: const Icon(
                                Icons.self_improvement,
                                color: Colors.deepPurpleAccent,
                              ),
                              filled: true,
                              fillColor: Colors.green[50],
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.deepPurpleAccent,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.deepPurpleAccent,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                  controller: formCtrl.tempat,
                                  label: "Tempat",
                                  icon: Icons.home,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: _pickTanggal,
                                  child: AbsorbPointer(
                                    child: buildTextField(
                                      controller: formCtrl.tanggalLahir,
                                      label: "Tanggal Lahir",
                                      icon: Icons.calendar_today,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.noTelepon,
                            label: "No. Telepon/HP",
                            icon: Icons.smartphone,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.nik,
                            label: "NIK",
                            icon: Icons.badge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Step 1
                  Step(
                    title: Text(
                      'Alamat',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    isActive: _currentStep >= 1,
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildTextField(
                            controller: formCtrl.jalan,
                            label: "Jalan",
                            icon: Icons.home,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                  controller: formCtrl.rt,
                                  label: "RT",
                                  icon: Icons.numbers,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: buildTextField(
                                  controller: formCtrl.rw,
                                  label: "RW",
                                  icon: Icons.numbers,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // Dusun Autocomplete
                          TypeAheadField<Alamat>(
                            builder: (context, controller, focusNode) {
                              controller.text = formCtrl.dusun.text;
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: GoogleFonts.poppins(
                                  color:  Colors.deepPurpleAccent,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Dusun",
                                  labelStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.place,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  filled: true,
                                  fillColor: Colors.green[50],
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.deepPurpleAccent,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.deepPurpleAccent,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                onChanged: (val) => formCtrl.dusun.text = val,
                              );
                            },
                            suggestionsCallback: (pattern) async {
                              return await alamatCtrl.searchDusun(pattern);
                            },
                            itemBuilder: (context, suggestion) => ListTile(
                              title: Text(suggestion.dusun ?? ''),
                              subtitle: Text(
                                '${suggestion.desa}, ${suggestion.kecamatan}, ${suggestion.kabupaten}',
                              ),
                            ),
                            onSelected: (suggestion) =>
                                _onSelectDusun(suggestion),
                            decorationBuilder: (context, child) => Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: child,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.desa,
                            label: "Desa",
                            icon: Icons.house,
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.kecamatan,
                            label: "Kecamatan",
                            icon: Icons.holiday_village,
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.kabupaten,
                            label: "Kabupaten",
                            icon: Icons.location_city,
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.provinsi,
                            label: "Provinsi",
                            icon: Icons.public,
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.kodePos,
                            label: "Kode Pos",
                            icon: Icons.markunread_mailbox,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Step 2
                  Step(
                    title: Text(
                      'Orang Tua',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    isActive: _currentStep >= 2,
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildTextField(
                            controller: formCtrl.namaAyah,
                            label: "Nama Ayah",
                            icon: Icons.man,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.namaIbu,
                            label: "Nama Ibu",
                            icon: Icons.woman,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.namaWali,
                            label: "Nama Wali (opsional)",
                            icon: Icons.family_restroom,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.jalanOrtu,
                            label: "Jalan Ortu",
                            icon: Icons.home,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                  controller: formCtrl.rtOrtu,
                                  label: "RT Ortu",
                                  icon: Icons.numbers,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: buildTextField(
                                  controller: formCtrl.rwOrtu,
                                  label: "RW Ortu",
                                  icon: Icons.numbers,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // Dusun Ortu Autocomplete
                          TypeAheadField<Alamat>(
                            builder: (context, controller, focusNode) {
                              controller.text = formCtrl.dusunOrtu.text;
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: GoogleFonts.poppins(
                                  color:  Colors.deepPurpleAccent,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Dusun Ortu",
                                  labelStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.place,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  filled: true,
                                  fillColor: Colors.green[50],
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.deepPurpleAccent,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.deepPurpleAccent,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                onChanged: (val) =>
                                    formCtrl.dusunOrtu.text = val,
                              );
                            },
                            suggestionsCallback: (pattern) async =>
                                await alamatCtrl.searchDusun(pattern),
                            itemBuilder: (context, suggestion) => ListTile(
                              title: Text(suggestion.dusun ?? ''),
                              subtitle: Text(
                                '${suggestion.desa}, ${suggestion.kecamatan}, ${suggestion.kabupaten}',
                              ),
                            ),
                            onSelected: (suggestion) =>
                                _onSelectDusunOrtu(suggestion),
                            decorationBuilder: (context, child) => Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: child,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.desaOrtu,
                            label: "Desa Ortu",
                            icon: Icons.house,
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.kecamatanOrtu,
                            label: "Kecamatan Ortu",
                            icon: Icons.holiday_village,
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.kabupatenOrtu,
                            label: "Kabupaten Ortu",
                            icon: Icons.location_city,
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.provinsiOrtu,
                            label: "Provinsi Ortu",
                            icon: Icons.public,
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                          buildTextField(
                            controller: formCtrl.kodePosOrtu,
                            label: "Kode Pos Ortu",
                            icon: Icons.markunread_mailbox,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
