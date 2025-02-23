import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models/stok.dart';

class TambahStokPage extends StatefulWidget {
  @override
  _TambahStokPageState createState() => _TambahStokPageState();
}

class _TambahStokPageState extends State<TambahStokPage> {
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  int _kuantitas = 0;
  String _atribut = '';
  double _berat = 0.0;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Stok stok = Stok(
        id: '',
        name: _nama,
        qty: _kuantitas,
        attr: _atribut,
        weight: _berat,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      String apiUrl = 'https://api.kartel.dev/stocks';

      try {
        print('Data yang dikirim: ${stok.toJson()}');

        var response = await Dio().post(
          apiUrl,
          data: stok.toJson(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal menambah stok: ${response.statusMessage}')),
          );
        }
      } catch (e) {
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
        title: Text('Tambah Stok'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama'),
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
                decoration: InputDecoration(labelText: 'Kuantitas'),
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
                decoration: InputDecoration(labelText: 'Atribut'),
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
                decoration: InputDecoration(labelText: 'Berat'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
