import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models/stok.dart'; // Import model Stok

class EditStokForm extends StatefulWidget {
  final Stok stok;

  const EditStokForm({super.key, required this.stok});

  @override
  _EditStokFormState createState() => _EditStokFormState();
}

class _EditStokFormState extends State<EditStokForm> {
  final _formKey = GlobalKey<FormState>();
  late String _nama;
  late int _kuantitas;
  late String _atribut;
  late double _berat;

  @override
  void initState() {
    super.initState();
    _nama = widget.stok.name;
    _kuantitas = widget.stok.qty;
    _atribut = widget.stok.attr;
    _berat = widget.stok.weight;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Data yang akan dikirim ke API
      Stok updatedStok = Stok(
        id: widget.stok.id,
        name: _nama,
        qty: _kuantitas,
        attr: _atribut,
        weight: _berat,
      );

      // Endpoint API
      String apiUrl = 'https://api.kartel.dev/stocks/${widget.stok.id}';

      try {
        // Logging data yang akan dikirim
        print('Data yang dikirim: ${updatedStok.toJson()}');

        // Mengirim PUT request ke API
        var response = await Dio().put(
          apiUrl,
          data: updatedStok.toJson(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status! < 500; // Tangani status kode di bawah 500
            },
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          // Jika berhasil, kembali ke halaman sebelumnya
          Navigator.pop(context, true);
        } else if (response.statusCode == 422) {
          // Jika ada kesalahan validasi, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui stok: ${response.data}')),
          );
        } else {
          // Jika gagal, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal memperbarui stok: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        // Jika terjadi error, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Stok'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _nama,
                decoration: const InputDecoration(labelText: 'Nama'),
                onSaved: (value) {
                  _nama = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _kuantitas.toString(),
                decoration: const InputDecoration(labelText: 'Kuantitas'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _kuantitas = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kuantitas tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Kuantitas harus berupa angka';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _atribut,
                decoration: const InputDecoration(labelText: 'Atribut'),
                onSaved: (value) {
                  _atribut = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Atribut tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _berat.toString(),
                decoration: const InputDecoration(labelText: 'Berat'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) {
                  _berat = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Berat tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Berat harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
