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
        scaffoldBackgroundColor: Colors.white,
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
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {},
          onPageFinished: (url) {},
        ),
      )
      ..loadRequest(Uri.parse('https://applay65.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S.O.S.Auto | Applay65',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _index,
        children: [
          WebViewWidget(controller: _controller), // 0
          const PautasScreen(), // 1
          const TarifasScreen(), // 2
          const PagarScreen(), // 3 - QR
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
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Tarifas'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Pagar'),
        ],
      ),
    );
  }
}

// PANTALLA 1: PAUTAS
class PautasScreen extends StatelessWidget {
  const PautasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Pautantes Oficiales S.O.S.Auto',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        const Text('Desde Sincelejo para toda América',
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 15),
        _pautaCard('Grúas Sincelejo 24H', 'Llega en 15 min - Servicio #1',
            Icons.local_shipping),
        _pautaCard('Taller El Costeño', '-20% en latonería con S.O.S.Auto',
            Icons.build),
        _pautaCard('Seguros Bolívar - Costa', 'Asegura tu carro en 5 min',
            Icons.security),
        _pautaCard('Llantería La Sabana', 'Montada gratis en Sincelejo',
            Icons.tire_repair),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50)),
          onPressed: () {},
          child: const Text('¿QUIERES PAUTAR? Ver Tarifas',
              style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  Widget _pautaCard(String titulo, String desc, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.red, size: 35),
        title: Text(titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.verified, color: Colors.green),
      ),
    );
  }
}

// PANTALLA 2: TARIFAS JUSTAS
class TarifasScreen extends StatelessWidget {
  const TarifasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Tarifas Justas - Applay65',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('Calculadas por alcance real e impresiones',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 16),
        _tarifa('LOCAL', 'Sincelejo, Corozal, Sampués', '\$60.000 COP / semana',
            '~3.000 vistas/semana. Ideal talleres y grúas.', Colors.yellow.shade100),
        _tarifa('REGIONAL', 'Toda la Costa Caribe', '\$150.000 COP / semana',
            '~10.000 vistas/semana. Concesionarios y repuestos.', Colors.white),
        _tarifa('NACIONAL', 'Toda Colombia', '\$350.000 COP / semana',
            '~30.000 vistas/semana. Seguros y marcas.', Colors.white),
        _tarifa('CONTINENTAL', 'América (Applay65)', '\$120 USD / semana',
            'Banner en todas nuestras apps. Marcas grandes.', Colors.red.shade50),
      ],
    );
  }

  Widget _tarifa(String nivel, String alcance, String precio, String desc, Color color) {
    return Card(
      color: color,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nivel,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red)),
            Text(alcance,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(precio,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(desc,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

// PANTALLA 3: PAGAR CON QR
class PagarScreen extends StatelessWidget {
  const PagarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CAMBIA TU NUMERO DE NEQUI AQUI
    String datosPago =
        "PAGO PAUTA S.O.S.Auto - Applay65\nNequi: 3001234567\nTitular: Juan Avalos\nValor: 60000 COP\nWeb: https://applay65.com/pagar";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Pagar Pauta con QR',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Escanea con Nequi, Bancolombia o Daviplata',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white),
            child: QrImageView(
              data: datosPago,
              version: QrVersions.auto,
              size: 250,
              gapless: false,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(8)),
            child: const Column(
              children: [
                Text('TITULAR: JUAN AVALOS - Applay65',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('NEQUI: 300 123 4567',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Text('Cambia este numero por tu Nequi real',
                    style: TextStyle(color: Colors.yellow, fontSize: 10)),
                SizedBox(height: 6),
                Text('CONCEPTO: Pauta S.O.S.Auto',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
              '1. Escanea el QR\n2. Paga\n3. Envía comprobante al WhatsApp\nTu pauta sale en 24 horas',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}
