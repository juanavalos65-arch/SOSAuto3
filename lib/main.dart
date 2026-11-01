import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const SOSAutoApp());
}

class SOSAutoApp extends StatelessWidget {
  const SOSAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'S.O.S.Auto',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://applay65.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S.O.S.Auto | Applay65',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
      ),
      body: IndexedStack(
        index: _index,
        children: [
          WebViewWidget(controller: _controller), // 0: S.O.S.
          const PautasScreen(), // 1: Pautas
          const TarifasScreen(), // 2: Tarifas
          const PagarScreen(), // 3: QR Limpio
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.car_crash), label: 'S.O.S.'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Pautas'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Tarifas'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Pagar'),
        ],
      ),
    );
  }
}

// PANTALLA PAUTAS
class PautasScreen extends StatelessWidget {
  const PautasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Pautantes Oficiales S.O.S.Auto',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('Desde Sincelejo para América - Applay65',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 15),
        _card('Grúas Sincelejo 24H', 'Llega en 15 min'),
        _card('Taller El Costeño', '-20% con S.O.S.Auto'),
        _card('Seguros Bolívar', 'Asegura tu carro en 5 min'),
        _card('Llantería La Sabana', 'Montada gratis'),
      ],
    );
  }

  Widget _card(String t, String d) => Card(
          child: ListTile(
        leading: const Icon(Icons.verified, color: Colors.green),
        title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(d, style: const TextStyle(fontSize: 12)),
      ));
}

// PANTALLA TARIFAS CON COMISION WOMPI + IMPUESTO
class TarifasScreen extends StatelessWidget {
  const TarifasScreen({super.key});

  double calcularTotal(double base) {
    double comisionWompi = base * 0.029 + 900; // Wompi 2.9% + $900
    double iva = comisionWompi * 0.19;
    double impuestoPais = base * 0.05;
    return base + comisionWompi + iva + impuestoPais;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Tarifas Justas Applay65',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('BASE + Wompi + Impuesto lo paga el pautante',
            style: TextStyle(fontSize: 11, color: Colors.red)),
        const SizedBox(height: 16),
        _tarifa('LOCAL', 60000),
        _tarifa('REGIONAL', 150000),
        _tarifa('NACIONAL', 350000),
        _tarifaUSD('CONTINENTAL', 120),
      ],
    );
  }

  Widget _tarifa(String nivel, double base) {
    double total = calcularTotal(base);
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nivel,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                  Text('Base: \$${base.toStringAsFixed(0)} COP'),
                  Text(
                      'Total a pagar: \$${total.toStringAsFixed(0)} COP (con comisión)',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  const Text('Tú recibes base limpia',
                      style: TextStyle(fontSize: 10, color: Colors.green)),
                ])));
  }

  Widget _tarifaUSD(String nivel, double base) {
    double total = base * 1.08;
    return Card(
        color: Colors.red.shade50,
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nivel,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                  Text('Base: \$$base USD'),
                  Text('Total: \$${total.toStringAsFixed(2)} USD',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ])));
  }
}

// PANTALLA PAGAR - QR LIMPIO SIN DATOS VISIBLES
class PagarScreen extends StatelessWidget {
  const PagarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DATOS REALES DENTRO DEL QR, NO VISIBLES EN PANTALLA
    // Nequi: 3116479280 - Llave: 71663024
    String qrData = "https://checkout.wompi.co/l/71663024";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Pagar Pauta - QR Wompi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
              ],
            ),
            child: Column(
              children: [
                const Text('Escanea para pagar con Wompi',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 20),
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 260,
                  gapless: false,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Abre tu app Wompi y escanea el código para completar el pago',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
