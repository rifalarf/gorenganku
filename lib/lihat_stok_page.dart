import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models/stok.dart';

class LihatStokPage extends StatefulWidget {
  @override
  _LihatStokPageState createState() => _LihatStokPageState();
}

class _LihatStokPageState extends State<LihatStokPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lihat Stok'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<Stok>>(
        future: _stokList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada stok tersedia'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Stok stok = snapshot.data![index];
                return ListTile(
                  title: Text(stok.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Kuantitas: ${stok.qty}\nAtribut: ${stok.attr}\nBerat: ${stok.weight}\nPembuat: ${stok.issuer}\n'),
                      Text('Created At: ${stok.createdAt}'),
                      Text('Updated At: ${stok.updatedAt}'),
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
