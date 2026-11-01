import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const SOSAutoApp());

class SOSAutoApp extends StatelessWidget {
  const SOSAutoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const FullApplayScreen());
  }
}

class Conductor {
  String nombres, apellidos, telefono, parentesco;
  Conductor({required this.nombres, required this.apellidos, required this.telefono, required this.parentesco});
}

class Vehiculo {
  String marca, modelo, color, placa, tipo;
  List<Conductor> conductores;
  Vehiculo({required this.marca, required this.modelo, required this.color, required this.placa, required this.tipo, required this.conductores});
}

class FullApplayScreen extends StatefulWidget {
  const FullApplayScreen({super.key});
  @override
  State<FullApplayScreen> createState() => _FullApplayScreenState();
}

class _FullApplayScreenState extends State<FullApplayScreen> {
  late final WebViewController _mapController;
  Vehiculo? _vehiculoRegistrado;
  bool _showRegister = false;

  @override
  void initState() {
    super.initState();
    _mapController = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse('https://www.google.com/maps/@9.3047,-75.3978,14z'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: WebViewWidget(controller: _mapController)),
          Positioned(top: 40, left: 10, right: 10, child: Column(children: [
            Row(children: [_emergencyBtn('Me Varé', Icons.car_repair, Colors.orange), const SizedBox(width: 6), _emergencyBtn('Accidenté', Icons.car_crash, Colors.red)]),
            const SizedBox(height: 6),
            Row(children: [_emergencyBtn('Peligro', Icons.sos, Colors.purple), const SizedBox(width: 6), _emergencyBtn('Robo Auto', Icons.local_police, Colors.black, isRobo: true)]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _smallBtn('Mi Auto', Icons.directions_car, () => setState(() => _showRegister = true), subtitle: _vehiculoRegistrado == null ? 'Sin registro' : _vehiculoRegistrado!.placa),
              _smallBtn('Novedades', Icons.traffic, () {}, isAlert: true),
              _smallBtn('Paute Aquí', Icons.campaign, () => _showPauteModal(), isPrimary: true),
            ]),
            if (_vehiculoRegistrado != null)
              Container(margin: const EdgeInsets.only(top: 6), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Text('${_vehiculoRegistrado!.marca} ${_vehiculoRegistrado!.color} ${_vehiculoRegistrado!.placa} - ${_vehiculoRegistrado!.conductores.length} conductores', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
          ])),
          Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 100, color: Colors.white.withOpacity(0.95), child: Column(children: [Container(color: Colors.red, width: double.infinity, padding: const EdgeInsets.all(3), child: const Text('PAUTAS ACTIVAS - APPLAY65 DESDE SINCELEJO', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))), Expanded(child: PageView(children: [Center(child: Text('Grúas Sincelejo 24H - ${_vehiculoRegistrado?.placa ?? 'Tu placa aquí'}')), Center(child: Text('Publicidad Local'))]))]))),
          if (_showRegister) _buildVehiculoModal(),
        ],
      ),
    );
  }

  Widget _emergencyBtn(String label, IconData icon, Color color, {bool isRobo = false}) {
    return Expanded(child: ElevatedButton.icon(onPressed: () {
      if (isRobo && _vehiculoRegistrado == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PRIMERO REGISTRA TU VEHÍCULO Y CONDUCTORES - Es obligatorio para reportar robo y evitar falsos'), backgroundColor: Colors.red));
        setState(() => _showRegister = true);
        return;
      }
      if (isRobo) { _showRoboModal(); } else { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ALERTA $label - Vehículo ${_vehiculoRegistrado?.placa ?? ''}'))); }
    }, icon: Icon(icon, size: 16), label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))));
  }

  Widget _smallBtn(String label, IconData icon, VoidCallback onTap, {bool isPrimary = false, bool isAlert = false, String? subtitle}) {
    return ElevatedButton.icon(onPressed: onTap, icon: Icon(icon, size: 14), label: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 8))]), style: ElevatedButton.styleFrom(backgroundColor: isPrimary ? Colors.red : isAlert ? Colors.amber.shade700 : Colors.white, foregroundColor: isPrimary || isAlert ? Colors.white : Colors.black, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
  }

  // MODAL FICHA COMPLETA VEHICULO + CONDUCTORES
  Widget _buildVehiculoModal() {
    final marcaCtrl = TextEditingController(text: _vehiculoRegistrado?.marca ?? '');
    final modeloCtrl = TextEditingController(text: _vehiculoRegistrado?.modelo ?? '');
    final colorCtrl = TextEditingController(text: _vehiculoRegistrado?.color ?? '');
    final placaCtrl = TextEditingController(text: _vehiculoRegistrado?.placa ?? '');
    List<Conductor> conductoresTemp = _vehiculoRegistrado != null ? List.from(_vehiculoRegistrado!.conductores) : [Conductor(nombres: '', apellidos: '', telefono: '', parentesco: 'Propietario')];

    return StatefulBuilder(builder: (context, setModal) {
      return Positioned.fill(child: Container(color: Colors.black54, child: Center(child: Container(margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Ficha Vehículo + Conductores', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _showRegister = false))]),
        const Text('Datos del vehículo (obligatorio para alertas)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(height: 8),
        Row(children: [Expanded(child: TextField(controller: marcaCtrl, decoration: const InputDecoration(labelText: 'Marca *', hintText: 'Mazda', border: OutlineInputBorder(), isDense: true))), const SizedBox(width: 8), Expanded(child: TextField(controller: modeloCtrl, decoration: const InputDecoration(labelText: 'Modelo *', hintText: '2020', border: OutlineInputBorder(), isDense: true)))]),
        const SizedBox(height: 8),
        Row(children: [Expanded(child: TextField(controller: colorCtrl, decoration: const InputDecoration(labelText: 'Color *', border: OutlineInputBorder(), isDense: true))), const SizedBox(width: 8), Expanded(child: TextField(controller: placaCtrl, decoration: const InputDecoration(labelText: 'Placa *', hintText: 'ABC123', border: OutlineInputBorder(), isDense: true), textCapitalization: TextCapitalization.characters))]),
        const Divider(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Conductores Autorizados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), TextButton.icon(onPressed: () => setModal(() => conductoresTemp.add(Conductor(nombres: '', apellidos: '', telefono: '', parentesco: 'Familiar'))), icon: const Icon(Icons.person_add, size: 16), label: const Text('Agregar', style: TextStyle(fontSize: 11)))]),
        const Text('Nombres, apellidos y teléfono de quienes manejan el auto', style: TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 8),
        ...conductoresTemp.asMap().entries.map((entry) {
          int idx = entry.key;
          Conductor c = entry.value;
          return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: Column(children: [
            Row(children: [Text('Conductor ${idx+1} - ${c.parentesco}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)), const Spacer(), if (conductoresTemp.length > 1) InkWell(onTap: () => setModal(() => conductoresTemp.removeAt(idx)), child: const Icon(Icons.delete, size: 16, color: Colors.red))]),
            const SizedBox(height: 6),
            Row(children: [Expanded(child: TextField(onChanged: (v) => c.nombres = v, controller: TextEditingController(text: c.nombres)..selection = TextSelection.fromPosition(TextPosition(offset: c.nombres.length)), decoration: const InputDecoration(labelText: 'Nombres *', isDense: true, border: OutlineInputBorder()))), const SizedBox(width: 6), Expanded(child: TextField(onChanged: (v) => c.apellidos = v, controller: TextEditingController(text: c.apellidos)..selection = TextSelection.fromPosition(TextPosition(offset: c.apellidos.length)), decoration: const InputDecoration(labelText: 'Apellidos *', isDense: true, border: OutlineInputBorder())))]),
            const SizedBox(height: 6),
            Row(children: [Expanded(child: TextField(onChanged: (v) => c.telefono = v, controller: TextEditingController(text: c.telefono)..selection = TextSelection.fromPosition(TextPosition(offset: c.telefono.length)), decoration: const InputDecoration(labelText: 'Celular *', prefixText: '+57 ', isDense: true, border: OutlineInputBorder()), keyboardType: TextInputType.phone)), const SizedBox(width: 6), Expanded(child: DropdownButtonFormField(value: c.parentesco, items: const [DropdownMenuItem(value: 'Propietario', child: Text('Propietario', style: TextStyle(fontSize: 12))), DropdownMenuItem(value: 'Familiar', child: Text('Familiar')), DropdownMenuItem(value: 'Conductor', child: Text('Conductor')), DropdownMenuItem(value: 'Empresa', child: Text('Empresa'))], onChanged: (v) => setModal(() => c.parentesco = v!), decoration: const InputDecoration(labelText: 'Rol', isDense: true, border: OutlineInputBorder()), isDense: true))]),
          ]));
        }),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {
          if (marcaCtrl.text.isEmpty || placaCtrl.text.length < 5 || conductoresTemp.any((c) => c.nombres.isEmpty || c.telefono.length < 7)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa marca, placa y nombres/apellidos/telefono de cada conductor')));
            return;
          }
          setState(() {
            _vehiculoRegistrado = Vehiculo(marca: marcaCtrl.text, modelo: modeloCtrl.text, color: colorCtrl.text, placa: placaCtrl.text.toUpperCase(), tipo: 'Carro', conductores: conductoresTemp);
            _showRegister = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vehículo ${placaCtrl.text.toUpperCase()} guardado con ${conductoresTemp.length} conductores'), backgroundColor: Colors.green));
        }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Guardar Ficha y Activar S.O.S.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
        const SizedBox(height: 6),
        const Text('Al reportar Robo, enviaremos placa + ficha + lista de conductores autorizados a tu contacto de emergencia y a la comunidad. Esto evita reportes falsos.', style: TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center),
      ])))))));
    });
  }

  void _showRoboModal() {
    showDialog(context: context, builder: (_) => AlertDialog(title: Text('ROBO - ${_vehiculoRegistrado!.placa}', style: const TextStyle(color: Colors.red)), content: Text('Vehículo: ${_vehiculoRegistrado!.marca} ${_vehiculoRegistrado!.color}\nConductores: ${_vehiculoRegistrado!.conductores.map((c) => '${c.nombres} ${c.apellidos} ${c.telefono}').join(', ')}\n\n¿Confirmas reporte de robo? Se notificará a todos los conductores y a tu contacto de emergencia.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), ElevatedButton(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ROBO ${_vehiculoRegistrado!.placa} EN VERIFICACIÓN - Contactando a ${ _vehiculoRegistrado!.conductores.length} conductores'), backgroundColor: Colors.red)); }, child: const Text('Sí, Reportar Robo'))]));
  }

  void _showPauteModal() {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => Container(padding: const EdgeInsets.all(20), height: 500, child: Column(children: [const Text('Paute Aquí - QR Wompi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const SizedBox(height: 15), QrImageView(data: 'https://checkout.wompi.co/l/71663024', size: 180), const SizedBox(height: 10), Text('Vehículo registrado: ${_vehiculoRegistrado?.placa ?? 'Sin registro - Regístrate para pautar'}'), const Spacer(), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))])));
  }
}
