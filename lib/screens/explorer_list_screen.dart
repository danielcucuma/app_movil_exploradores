import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/explorer.dart';

class ExplorerListScreen extends StatefulWidget {
  const ExplorerListScreen({super.key});

  @override
  State<ExplorerListScreen> createState() => _ExplorerListScreenState();
}

class _ExplorerListScreenState extends State<ExplorerListScreen> {
  late Future<List<Map<String, dynamic>>> _explorersFuture;

  @override
  void initState() {
    super.initState();
    _refreshExplorers();
  }

  void _refreshExplorers() {
    setState(() {
      _explorersFuture = DatabaseHelper().getExplorers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Exploradores')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _explorersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay registros.'));
          }

          final explorers = snapshot.data!.map((e) => Explorer.fromMap(e)).toList();

          return ListView.builder(
            itemCount: explorers.length,
            itemBuilder: (context, index) {
              final explorer = explorers[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(explorer.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lugar: ${explorer.lugar}'),
                      Text('Equipo ID: ${explorer.equipoId}'),
                      Text('Tel: ${explorer.telefono}'),
                      Text('Fecha: ${explorer.fecha}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
