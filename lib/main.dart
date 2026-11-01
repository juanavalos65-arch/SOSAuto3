import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const SOSAutoApp());

class SOSAutoApp extends StatelessWidget {
  const SOSAutoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: FullScreen());
  }
}

class FullScreen extends StatefulWidget {
  const FullScreen({super.key});
  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  String marca = '', modelo = '', color = '', placa = '';
  List<Map<String,String>> conductores = [
    {'nombres':'','apellidos':'','telefono':'','rol':'Propietario'}
  ];
  bool showFicha = false;
  List<Map<String,String>> novedades = [
    {'tipo':'Reten','desc':'Reten via Corozal km 5','hora':'hace 10 min'},
    {'tipo':'Hueco','desc':'Hueco Av. Sincelejito','hora':'hace 1h'},
  ];

  final marcaCtrl = TextEditingController();
  final modeloCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  final placaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE8E6E1),
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.map, size: 70, color: Colors.grey),
                  const Text('MAPA SOSAuto - Sincelejo', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(placa.isEmpty ? 'Sin vehiculo registrado' : placa, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(onPressed: () => _open('https://www.google.com/maps/@9.3047,-75.3978,14z'), child: const Text('Google Maps')),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: () => _open('https://waze.com/ul?ll=9.3047,-75.3978&navigate=yes'), child: const Text('Waze')),
                  ])
                ]),
              ),
            ),
          ),
          Positioned(top: 40, left: 8, right: 8, child: Column(children: [
            Row(children: [ _topBtn('Me Vare', Icons.car_repair, Colors.orange), const SizedBox(width: 5), _topBtn('Accidente', Icons.car_crash, Colors.red)]),
            const SizedBox(height: 5),
            Row(children: [ _topBtn('Peligro', Icons.sos, Colors.purple), const SizedBox(width: 5), _topBtn('Robo Auto', Icons.local_police, Colors.black, isRobo: true)]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _smallBtn(placa.isEmpty ? 'Mi Auto' : placa, Icons.directions_car, () => setState(() => showFicha = true)),
              _smallBtn('Novedades', Icons.traffic, () => _showNovedades(), alert: true),
              _smallBtn('Paute Aqui', Icons.campaign, () => _showPaute(), primary: true),
            ]),
          ])),
          Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 85, color: Colors.white.withOpacity(0.95), child: Column(children: [Container(color: Colors.red, width: double.infinity, padding: const EdgeInsets.all(3), child: const Text('PAUTAS ACTIVAS - APPLAY65', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))), Expanded(child: ListView(scrollDirection: Axis.horizontal, children: const [Chip(label: Text('Gruas Sincelejo 24H')), Chip(label: Text('Taller El Costeno -20pct'))]))]))),
          if (showFicha) _fichaModal(),
        ],
      ),
    );
  }

  Widget _topBtn(String label, IconData icon, Color c, {bool isRobo = false}) {
    return Expanded(child: ElevatedButton.icon(onPressed: (){
      if(isRobo && placa.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registra vehiculo y conductores primero'), backgroundColor: Colors.red));
        setState(()=> showFicha = true); return;
      }
      if(isRobo){ _confirmRobo(); } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label + ' enviado - Placa ' + placa)));
      }
    }, icon: Icon(icon, size: 15), label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: c, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 9))));
  }

  Widget _smallBtn(String label, IconData icon, VoidCallback onTap, {bool primary = false, bool alert = false}) {
    return ElevatedButton.icon(onPressed: onTap, icon: Icon(icon, size: 12), label: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: primary ? Colors.red : alert ? Colors.amber.shade700 : Colors.white, foregroundColor: primary || alert ? Colors.white : Colors.black, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))));
  }

  void _open(String url) async { final u = Uri.parse(url); if(await canLaunchUrl(u)) launchUrl(u, mode: LaunchMode.externalApplication); }

  void _showNovedades(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_)=> Container(height: 450, padding: const EdgeInsets.all(12), child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Novedades en la Via', style: TextStyle(fontWeight: FontWeight.bold)), ElevatedButton(onPressed: (){ Navigator.pop(context); _addNovedad(); }, child: const Text('Reportar'))]),
      Expanded(child: ListView.builder(itemCount: novedades.length, itemBuilder: (_, i)=> Card(child: ListTile(title: Text(novedades[i]['tipo'].toString() + ' - ' + novedades[i]['desc'].toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), subtitle: Text(novedades[i]['hora'].toString()))))),
    ])));
  }

  void _addNovedad(){
    final c = TextEditingController();
    showDialog(context: context, builder: (_)=> AlertDialog(title: const Text('Reportar Novedad'), content: TextField(controller: c, decoration: const InputDecoration(labelText: 'Que pasa y donde')), actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Cancelar')), ElevatedButton(onPressed: (){ setState(()=> novedades.insert(0, {'tipo':'Nuevo','desc':c.text,'hora':'ahora'})); Navigator.pop(context); }, child: const Text('Publicar'))]));
  }

  void _confirmRobo(){
    showDialog(context: context, builder: (_)=> AlertDialog(
      title: Text('ROBO ' + placa + ' - Verificacion', style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)),
      content: Text('Vehiculo: ' + marca + ' ' + modelo + ' ' + color + ' ' + placa),
      actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Cancelar')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: (){ Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reporte en verificacion - Envia foto denuncia al 3116479280'), backgroundColor: Colors.red)); }, child: const Text('Confirmar', style: TextStyle(color: Colors.white)))],
    ));
  }

  void _showPaute(){
    showModalBottomSheet(context: context, builder: (_)=> Container(padding: const EdgeInsets.all(20), height: 420, child: Column(children: [
      const Text('Pagar Pauta - QR Wompi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 10),
      QrImageView(data: 'https://checkout.wompi.co/l/71663024', size: 180),
      const SizedBox(height: 10),
      Text('Vehiculo: ' + (placa.isEmpty ? 'Registra primero' : placa), style: const TextStyle(fontSize: 11)),
      const Text('Formato: 1080x1080 JPG + 30 palabras + WhatsApp 3116479280\nBASE + Wompi 2.9% + 900 + IVA lo paga pautante', style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
      const SizedBox(height: 6),
      const Text('Link: checkout.wompi.co/l/71663024', style: TextStyle(fontSize: 9, color: Colors.blue)),
    ])));
  }

  Widget _fichaModal(){
    return Positioned.fill(child: Container(color: Colors.black54, child: Center(child: Container(margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Ficha Vehiculo + Conductores', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), IconButton(icon: const Icon(Icons.close), onPressed: ()=> setState(()=> showFicha = false))]),
      const Text('Datos del auto y quienes lo manejan - Obligatorio anti-falsos', style: TextStyle(fontSize: 10, color: Colors.red)),
      const SizedBox(height: 6),
      TextField(controller: marcaCtrl, decoration: const InputDecoration(labelText: 'Marca', border: OutlineInputBorder(), isDense: true)),
      const SizedBox(height: 4),
      Row(children: [Expanded(child: TextField(controller: modeloCtrl, decoration: const InputDecoration(labelText: 'Modelo', border: OutlineInputBorder(), isDense: true))), const SizedBox(width: 4), Expanded(child: TextField(controller: colorCtrl, decoration: const InputDecoration(labelText: 'Color', border: OutlineInputBorder(), isDense: true)))]),
      const SizedBox(height: 4),
      TextField(controller: placaCtrl, decoration: const InputDecoration(labelText: 'Placa', border: OutlineInputBorder(), isDense: true)),
      const Divider(),
      Text('Conductores: Nombres, Apellidos, Telefono (' + conductores.length.toString() + ')', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
      const SizedBox(height: 4),
      ...List.generate(conductores.length, (i){
        return Container(margin: const EdgeInsets.only(bottom: 5), padding: const EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(5)), child: Column(children: [
          Row(children: [
            Expanded(child: TextFormField(initialValue: conductores[i]['nombres'], onChanged: (v)=> conductores[i]['nombres']=v, decoration: const InputDecoration(labelText: 'Nombres', isDense: true, border: OutlineInputBorder()))),
            const SizedBox(width: 3),
            Expanded(child: TextFormField(initialValue: conductores[i]['apellidos'], onChanged: (v)=> conductores[i]['apellidos']=v, decoration: const InputDecoration(labelText: 'Apellidos', isDense: true, border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 3),
          TextFormField(initialValue: conductores[i]['telefono'], onChanged: (v)=> conductores[i]['telefono']=v, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Celular', prefixText: '+57 ', isDense: true, border: OutlineInputBorder())),
        ]));
      }),
      TextButton.icon(onPressed: ()=> setState(()=> conductores.add({'nombres':'','apellidos':'','telefono':'','rol':'Familiar'})), icon: const Icon(Icons.person_add, size: 14), label: const Text('Agregar conductor', style: TextStyle(fontSize: 10))),
      SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: (){
        if(placaCtrl.text.length < 5){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Placa minimo 5'))); return; }
        if(conductores.any((e)=> e['nombres']!.isEmpty || e['apellidos']!.isEmpty || e['telefono']!.length < 7)){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa nombres, apellidos y telefono'))); return; }
        setState((){ marca=marcaCtrl.text; modelo=modeloCtrl.text; color=colorCtrl.text; placa=placaCtrl.text.toUpperCase(); showFicha=false; });
      }, child: const Text('Guardar Ficha', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
    ]))))));
  }
}
