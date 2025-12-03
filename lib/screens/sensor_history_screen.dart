import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/sensor_log.dart';

class SensorHistoryScreen extends StatefulWidget {
  const SensorHistoryScreen({super.key});

  @override
  State<SensorHistoryScreen> createState() => _SensorHistoryScreenState();
}

class _SensorHistoryScreenState extends State<SensorHistoryScreen> {
  late Future<List<MagnetometerLog>> _magnetometerLogsFuture;
  late Future<List<BarometerLog>> _barometerLogsFuture;

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  void _refreshLogs() {
    setState(() {
      _magnetometerLogsFuture = DatabaseHelper().getMagnetometerLogs().then(
            (data) => data.map((e) => MagnetometerLog.fromMap(e)).toList(),
          );
      _barometerLogsFuture = DatabaseHelper().getBarometerLogs().then(
            (data) => data.map((e) => BarometerLog.fromMap(e)).toList(),
          );
    });
  }

  Widget _buildMagnetometerList() {
    return FutureBuilder<List<MagnetometerLog>>(
      future: _magnetometerLogsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay registros de Magnetómetro'));
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.green.shade100,
              width: double.infinity,
              child: const Text(
                'Historial Magnetómetro',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final log = snapshot.data![index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.explore, color: Colors.green),
                      title: Text(
                        'X:${log.x.toStringAsFixed(1)}  Y:${log.y.toStringAsFixed(1)}  Z:${log.z.toStringAsFixed(1)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        log.timestamp.split('T').join(' ').split('.').first,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBarometerList() {
    return FutureBuilder<List<BarometerLog>>(
      future: _barometerLogsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay registros de Barómetro'));
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.purple.shade100,
              width: double.infinity,
              child: const Text(
                'Historial Barómetro',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final log = snapshot.data![index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.speed, color: Colors.purple),
                      title: Text(
                        '${log.presion.toStringAsFixed(1)} hPa',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        log.timestamp.split('T').join(' ').split('.').first,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Sensores')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(
              children: [
                Expanded(child: _buildMagnetometerList()),
                const Divider(thickness: 2),
                Expanded(child: _buildBarometerList()),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(child: _buildMagnetometerList()),
                const VerticalDivider(thickness: 2),
                Expanded(child: _buildBarometerList()),
              ],
            );
          }
        },
      ),
    );
  }
}
