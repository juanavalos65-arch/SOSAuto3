import 'package:flutter/material.dart';

void main() => runApp(const SOSAutoApp());

class SOSAutoApp extends StatelessWidget {
  const SOSAutoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOSAuto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOSAuto - Emergencia Vial'), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.car_crash, size: 100, color: Colors.red),
              const SizedBox(height: 20),
              const Text('SOSAuto3', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Asistencia en carretera 24/7', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60), backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () {},
                icon: const Icon(Icons.phone),
                label: const Text('LLAMAR EMERGENCIA', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
                onPressed: () {},
                icon: const Icon(Icons.location_on),
                label: const Text('COMPARTIR UBICACIÓN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
