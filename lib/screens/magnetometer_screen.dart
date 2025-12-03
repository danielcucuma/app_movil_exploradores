import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../database/database_helper.dart';
import '../models/sensor_log.dart';

class MagnetometerScreen extends StatefulWidget {
  const MagnetometerScreen({super.key});

  @override
  State<MagnetometerScreen> createState() => _MagnetometerScreenState();
}

class _MagnetometerScreenState extends State<MagnetometerScreen> {
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      magnetometerEventStream().listen(
        (MagnetometerEvent event) {
          if (mounted) {
            setState(() {
              _magnetometerValues = <double>[event.x, event.y, event.z];
            });
          }
        },
        onError: (e) {
             if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error en sensor: $e')),
                );
             }
        },
        cancelOnError: true,
      ),
    );
    
    // Check if we get data within 2 seconds, otherwise show message
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _magnetometerValues == null) {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se detectaron datos del magnetómetro. ¿Estás en un dispositivo con sensores?')),
         );
      }
    });
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void _saveLog() async {
    if (_magnetometerValues != null) {
      final log = MagnetometerLog(
        x: _magnetometerValues![0],
        y: _magnetometerValues![1],
        z: _magnetometerValues![2],
        timestamp: DateTime.now().toIso8601String(),
      );
      await DatabaseHelper().insertMagnetometerLog(log.toMap());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lectura de magnetómetro guardada')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final values = _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Magnetómetro')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.explore, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Lectura Actual',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 30),
              if (values != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildValueCard('X', values[0], Colors.red),
                    _buildValueCard('Y', values[1], Colors.green),
                    _buildValueCard('Z', values[2], Colors.blue),
                  ],
                )
              else
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Esperando datos del sensor...', style: TextStyle(fontSize: 16)),
                  ],
                ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: _magnetometerValues != null ? _saveLog : null,
                icon: const Icon(Icons.save),
                label: const Text('GUARDAR LECTURA'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueCard(String axis, String value, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          children: [
            Text(
              axis,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
