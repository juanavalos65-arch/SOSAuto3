import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() { runApp(const SOSAutoApp()); }

class SOSAutoApp extends StatelessWidget {
  const SOSAutoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'S.O.S.Auto',
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
        title: const Text('S.O.S.Auto | Applay65', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black, foregroundColor: Colors.white, centerTitle: true,
      ),
      body: IndexedStack(
        index: _index,
        children: [
          WebViewWidget(controller: _controller),
          const PautasScreen(),
          const TarifasScreen(),
          const PagarScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
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

class PautasScreen extends StatelessWidget {
  const PautasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Pautantes Oficiales S.O.S.Auto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const Text('Sincelejo para toda América - Applay65', style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 15),
      _card('Grúas Sincelejo 24H', 'Llega en 15 min'),
      _card('Taller El Costeño', '-20% con S.O.S.Auto'),
      _card('Seguros Bolívar', 'Asegura tu carro en 5 min'),
    ]);
  }
  Widget _card(String t, String d) => Card(child: ListTile(leading: const Icon(Icons.verified, color: Colors.green), title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(d)));
}

class TarifasScreen extends StatelessWidget {
  const TarifasScreen({super.key});
  // CALCULO JUSTO CON COMISION WOMPI + IMPUESTO
  double calcularTotal(double base) {
    double comisionWompi = base * 0.029 + 900; // Wompi 2.9% + $900 COP
    double iva = comisionWompi * 0.19; // IVA sobre comisión
    double impuestoPais = base * 0.05; // 5% impuesto operación local (ajustable por país)
    return base + comisionWompi + iva + impuestoPais;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Tarifas Justas + Impuestos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const Text('El pautante paga: BASE + Wompi + Impuesto país', style: TextStyle(fontSize: 11, color: Colors.red)),
      const SizedBox(height: 16),
      _tarifa('LOCAL', 60000),
      _tarifa('REGIONAL', 150000),
      _tarifa('NACIONAL', 350000),
      _tarifaContinental(120),
    ]);
  }

  Widget _tarifa(String nivel, double base) {
    double total = calcularTotal(base);
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(nivel, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
      Text('Base: \$${base.toStringAsFixed(0)} COP', style: const TextStyle(fontWeight: FontWeight.bold)),
      Text('Wompi (2.9%+\$900) + IVA 19% + Imp. País 5%: \$${(total-base).toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: Colors.black54)),
      Text('TOTAL A PAGAR: \$${total.toStringAsFixed(0)} COP', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
      const Text('La comisión la paga el pautante, tú recibes la base limpia.', style: TextStyle(fontSize: 9, color: Colors.green)),
    ])));
  }

  Widget _tarifaContinental(double baseUSD) {
    double total = baseUSD * 1.08; // 2.9% + tax USA aprox 8%
    return Card(color: Colors.red.shade50, child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('CONTINENTAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
      Text('Base: \$$baseUSD USD', style: const TextStyle(fontWeight: FontWeight.bold)),
      Text('Total con Wompi + Imp: \$${total.toStringAsFixed(2)} USD', style: const TextStyle(fontWeight: FontWeight.bold)),
    ])));
  }
}

class PagarScreen extends StatelessWidget {
  const PagarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // DATOS REALES GUARDADOS
    String datosQR = "WOMPI PAGO S.O.S.Auto\nLlave: 71663024\nNequi: 3116479280\nTitular: Juan Avalos Applay65\nLink: https://applay65.com/pagar\nValor incluye Wompi+Impuesto";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Pagar Pauta - QR Wompi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Escanea y paga. La comisión la asume el pautante.', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all(width: 2), borderRadius: BorderRadius.circular(16), color: Colors.white),
            child: QrImageView(data: datosQR, version: QrVersions.auto, size: 260),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DATOS DE PAGO OFICIAL', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Titular: JUAN AVALOS - Applay65', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Nequi: 3116479280', style: TextStyle(color: Colors.white, fontSize: 16)),
                Text('Llave Wompi: 71663024', style: TextStyle(color: Colors.white)),
                Text('Link: applay65.com/pagar', style: TextStyle(color: Colors.white70)),
                Divider(color: Colors.white24),
                Text('Nota: Al total se suma Wompi 2.9%+\$900 + IVA 19% + Impuesto país 5%. Lo paga el pautante.', style: TextStyle(color: Colors.white60, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
