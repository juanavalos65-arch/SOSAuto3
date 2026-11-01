import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() { runApp(const SOSAutoApp()); }

class SOSAutoApp extends StatelessWidget {
  const SOSAutoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'S.O.S.Auto',
      theme: ThemeData(primaryColor: Colors.black),
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
          WebViewWidget(controller: _controller), // 0: S.O.S.Auto
          const PautasScreen(), // 1: Donde salen las pautas
          const TarifasScreen(), // 2: Calculadora justa
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.car_crash), label: 'S.O.S.'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Pautas'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Tarifas'),
        ],
      ),
      floatingActionButton: _index == 0 ? FloatingActionButton.extended(
        onPressed: () => setState(() => _index = 1),
        backgroundColor: Colors.red,
        label: const Text('PAUTAR AQUÍ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.local_offer, color: Colors.white),
      ) : null,
    );
  }
}

// PANTALLA 2: DONDE SALEN LAS PAUTAS
class PautasScreen extends StatelessWidget {
  const PautasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Pautantes Oficiales S.O.S.Auto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _pautaCard('Grúas Sincelejo 24H', 'Servicio #1 en Sucre', 'https://applay65.com/pautas/gruas'),
        _pautaCard('Taller El Costeño', '-20% en latonería con S.O.S.Auto', 'https://applay65.com/pautas/taller'),
        _pautaCard('Seguros Bolívar - Costa', 'Asegura tu carro en 5 min', 'https://applay65.com/pautas/seguros'),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
          onPressed: () {},
          child: const Text('¿QUIERES PAUTAR? Ver Tarifas', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
  Widget _pautaCard(String titulo, String desc, String link) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.verified, color: Colors.green, size: 40),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {},
      ),
    );
  }
}

// PANTALLA 3: CALCULADORA DE TARIFAS JUSTAS
class TarifasScreen extends StatelessWidget {
  const TarifasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('Calculadora Justa - Applay65', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Basado en alcance real + tipo de negocio + ciudad', style: TextStyle(color: Colors.grey)),
        SizedBox(height: 16),
        TarifaItem(nivel: 'LOCAL', alcance: 'Sincelejo + Corozal + Sampués', precio: '\$60.000 COP / semana', desc: 'Ideal para talleres, grúas, llanterias. ~3.000 impresiones/semana'),
        TarifaItem(nivel: 'REGIONAL', alcance: 'Toda la Costa Caribe', precio: '\$150.000 COP / semana', desc: 'Para concesionarios, repuestos. ~10.000 impresiones/semana'),
        TarifaItem(nivel: 'NACIONAL', alcance: 'Toda Colombia', precio: '\$350.000 COP / semana', desc: 'Para seguros, marcas nacionales. ~30.000 impresiones/semana'),
        TarifaItem(nivel: 'CONTINENTAL', alcance: 'América (App Applay65)', precio: '\$120 USD / semana', desc: 'Para apps, marcas grandes. Banner en todas nuestras apps'),
      ],
    );
  }
}

class TarifaItem extends StatelessWidget {
  final String nivel, alcance, precio, desc;
  const TarifaItem({super.key, required this.nivel, required this.alcance, required this.precio, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: nivel == 'LOCAL' ? Colors.yellow[100] : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(nivel, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          Text(alcance, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(precio, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ]),
      ),
    );
  }
}
