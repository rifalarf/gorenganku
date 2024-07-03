import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models/stok.dart';
import 'edit_stok_form.dart';

class EditStokPage extends StatefulWidget {
  const EditStokPage({super.key});

  @override
  _EditStokPageState createState() => _EditStokPageState();
}

class _EditStokPageState extends State<EditStokPage> {
  late Future<List<Stok>> _stokList;

  @override
  void initState() {
    super.initState();
    _stokList = _fetchStok();
  }

  Future<List<Stok>> _fetchStok() async {
    String apiUrl = 'https://api.kartel.dev/stocks';
    try {
      var response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Stok.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stok');
      }
    } catch (e) {
      throw Exception('Failed to load stok: $e');
    }
  }

  Future<void> _deleteStok(String id) async {
    String apiUrl = 'https://api.kartel.dev/stocks/$id';
    try {
      var response = await Dio().delete(apiUrl);
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _stokList = _fetchStok();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal menghapus stok: ${response.statusMessage}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Future<void> _editStok(Stok stok) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditStokForm(stok: stok)),
    );

    if (result == true) {
      setState(() {
        _stokList = _fetchStok();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Stok'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<Stok>>(
        future: _stokList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada stok tersedia'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Stok stok = snapshot.data![index];
                return ListTile(
                  title: Text(stok.name),
                  subtitle: Text(
                      'Kuantitas: ${stok.qty}, Atribut: ${stok.attr}, Berat: ${stok.weight}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editStok(stok);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteStok(stok.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
