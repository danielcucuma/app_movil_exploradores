import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../database/database_helper.dart';
import '../models/sensor_log.dart';

class BarometerScreen extends StatefulWidget {
  const BarometerScreen({super.key});

  @override
  State<BarometerScreen> createState() => _BarometerScreenState();
}

class _BarometerScreenState extends State<BarometerScreen> {
  double? _pressureValue;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      barometerEventStream().listen(
        (BarometerEvent event) {
          if (mounted) {
            setState(() {
              _pressureValue = event.pressure;
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
      if (mounted && _pressureValue == null) {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se detectaron datos del barómetro. ¿Estás en un dispositivo con sensores?')),
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
    if (_pressureValue != null) {
      final log = BarometerLog(
        presion: _pressureValue!,
        timestamp: DateTime.now().toIso8601String(),
      );
      await DatabaseHelper().insertBarometerLog(log.toMap());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lectura de barómetro guardada')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barómetro')),
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
              const Icon(Icons.speed, size: 80, color: Colors.purple),
              const SizedBox(height: 20),
              const Text(
                'Presión Atmosférica',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              const SizedBox(height: 40),
              if (_pressureValue != null)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                    border: Border.all(color: Colors.purple.shade200, width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _pressureValue!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const Text(
                        'hPa',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ],
                  ),
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
                onPressed: _pressureValue != null ? _saveLog : null,
                icon: const Icon(Icons.save),
                label: const Text('GUARDAR LECTURA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
