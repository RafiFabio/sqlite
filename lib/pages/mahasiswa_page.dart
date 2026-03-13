import 'package:flutter/material.dart';
import '../services/mahasiswa_service.dart';
import '../models/mahasiswa.dart';

void main() {
  runApp(MaterialApp(home: MahasiswaPage()));
}

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({Key? key}) : super(key: key);

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  final MahasiswaService service = MahasiswaService();

  List<Mahasiswa> data = [];

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();

  int? selectedId;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final result = await service.getAll();

    setState(() {
      data = result;
    });
  }

  void simpanData() async {
    final mahasiswa = Mahasiswa(
      id: selectedId,
      nama: namaController.text,
      nim: nimController.text,
      jurusan: jurusanController.text,
    );

    if (isEdit) {
      await service.update(mahasiswa);
    } else {
      await service.tambah(mahasiswa);
    }

    loadData();

    namaController.clear();
    nimController.clear();
    jurusanController.clear();

    isEdit = false;
    selectedId = null;
  }

  void hapusMahasiswa(int id) async {
    await service.hapus(id);

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Mahasiswa")),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: "Nama"),
            ),

            TextField(
              controller: nimController,
              decoration: InputDecoration(labelText: "NIM"),
            ),

            TextField(
              controller: jurusanController,
              decoration: InputDecoration(labelText: "Jurusan"),
            ),

            SizedBox(height: 10),

            ElevatedButton(onPressed: simpanData, child: Text("Simpan")),

            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final mhs = data[index];

                  return ListTile(
                    title: Text(mhs.nama),
                    subtitle: Text("${mhs.nim} - ${mhs.jurusan}"),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),

                          onPressed: () {
                            namaController.text = mhs.nama;
                            nimController.text = mhs.nim;
                            jurusanController.text = mhs.jurusan;

                            selectedId = mhs.id;
                            isEdit = true;
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.delete),

                          onPressed: () {
                            hapusMahasiswa(mhs.id!);
                          },
                        ),
                      ],
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
