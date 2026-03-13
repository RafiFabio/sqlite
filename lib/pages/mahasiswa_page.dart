import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MahasiswaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Mahasiswa {
  int? id;
  String nama;
  String nim;
  String jurusan;

  Mahasiswa({
    this.id,
    required this.nama,
    required this.nim,
    required this.jurusan,
  });
}

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  List<Mahasiswa> data = [];

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();

  int? selectedIndex;
  bool isEdit = false;

  void simpanData() {
    if (namaController.text.isEmpty ||
        nimController.text.isEmpty ||
        jurusanController.text.isEmpty) {
      return;
    }

    if (isEdit) {
      data[selectedIndex!] = Mahasiswa(
        nama: namaController.text,
        nim: nimController.text,
        jurusan: jurusanController.text,
      );

      isEdit = false;
      selectedIndex = null;
    } else {
      data.add(
        Mahasiswa(
          nama: namaController.text,
          nim: nimController.text,
          jurusan: jurusanController.text,
        ),
      );
    }

    namaController.clear();
    nimController.clear();
    jurusanController.clear();

    setState(() {});
  }

  void editData(int index) {
    final mhs = data[index];

    namaController.text = mhs.nama;
    nimController.text = mhs.nim;
    jurusanController.text = mhs.jurusan;

    selectedIndex = index;
    isEdit = true;

    setState(() {});
  }

  void hapusData(int index) {
    data.removeAt(index);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Mahasiswa")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),

            TextField(
              controller: nimController,
              decoration: const InputDecoration(labelText: "NIM"),
            ),

            TextField(
              controller: jurusanController,
              decoration: const InputDecoration(labelText: "Jurusan"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: simpanData,
              child: Text(isEdit ? "Update" : "Tambah"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final mhs = data[index];

                  return Card(
                    child: ListTile(
                      title: Text(mhs.nama),
                      subtitle: Text("${mhs.nim} - ${mhs.jurusan}"),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              editData(index);
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              hapusData(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
