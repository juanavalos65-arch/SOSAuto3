import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SosAutoFinal(),
  ));
}

class SosAutoFinal extends StatefulWidget {
  const SosAutoFinal({super.key});
  @override
  State<SosAutoFinal> createState() => _SosAutoFinalState();
}

class _SosAutoFinalState extends State<SosAutoFinal> with SingleTickerProviderStateMixin {
  String placa = '';
  List<Map<String, dynamic>> novedades = [];
  List<Map<String, dynamic>> pautas = [
    {'nombre': 'Gruas Sincelejo', 'ciudad': 'Sincelejo', 'horario': '24/7', 'telefono': '3116479280'},
    {'nombre': 'Taller El Costeño', 'ciudad': 'Sincelejo', 'horario': '7am-6pm', 'telefono': '3116479280'},
  ];
  List<Map<String, dynamic>> bannerItems = [];
  bool showFicha = false;

  late AnimationController _blinkController;
  late Animation<double> _blinkAnim;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _blinkAnim = Tween<double>(begin: 1.0, end: 0.4).animate(_blinkController);
    _actualizarBanner();
  }

  void _actualizarBanner() {
    bannerItems = [];
    if (novedades.isNotEmpty) {
      bannerItems.add({
        'tipo': 'mixto',
        'novedadTipo': novedades.first['tipo'],
        'novedadPlaca': novedades.first['placa'],
        'pautaNombre': pautas.first['nombre'],
        'pautaHorario': pautas.first['horario']
      });
    } else {
      bannerItems.add({
        'tipo': 'solo_pauta',
        'pautaNombre': pautas.first['nombre'],
        'pautaHorario': pautas.first['horario']
      });
    }
  }

  void _nuevaNovedad(String tipo) {
    if (placa.isEmpty) {
      setState(() => showFicha = true);
      return;
    }
    setState(() {
      novedades.insert(0, {'tipo': tipo, 'placa': placa, 'dist': '1.2km', 'hora': 'ahora'});
      _actualizarBanner();
    });
    _blinkController.repeat(reverse: true);
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) _blinkController.stop();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$tipo $placa enviado a usuarios a 5km'),
      backgroundColor: tipo == 'Estoy en Peligro' ? Colors.purple : Colors.green,
    ));
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5FF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Image.asset('assets/logo_sosauto.png', height: 28,
                      errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, color: Colors.orange, size: 32)),
                  const SizedBox(width: 8),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('S.O.S. Auto',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0A2A6B), letterSpacing: 0.5)),
                    Text('con auxilio al instante', style: TextStyle(fontSize: 11, color: Colors.black54)),
                  ]),
                ],
              ),
            ),
            Container(
              color: const Color(0xFFF0F5FF),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Row(children: [
                _topMini('Me Varé', Icons.build_outlined, () => _nuevaNovedad('Me Varé')),
                const SizedBox(width: 5),
                _topMini('Accidente', Icons.warning_amber_outlined, () => _nuevaNovedad('Accidente')),
                const SizedBox(width: 5),
                _topMini('Estoy en Peligro', Icons.shield_outlined, () => _nuevaNovedad('Estoy en Peligro'), danger: true),
                const SizedBox(width: 5),
                _topMini('Robo Auto', Icons.lock_outline, () => _nuevaNovedad('Robo Auto'), black: true),
              ]),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8ECF2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white),
                ),
                child: Stack(
                  children: [
                    const Center(child: Text('MAPA INTERACTIVO', style: TextStyle(color: Colors.black12, fontSize: 12))),
                    ...List.generate(8, (i) => Positioned(
                          left: 30 + (i * 37) % 200,
                          top: 20 + (i * 52) % 220,
                          child: const Icon(Icons.location_on, color: Color(0xFF1565C0), size: 28),
                        )),
                    const Center(child: Icon(Icons.my_location, color: Color(0xFF1565C0), size: 36)),
                  ],
                ),
              ),
            ),
            _bannerUnico(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.white,
              child: Row(children: [
                Expanded(child: _bottomBtn('Registro', Icons.person_outline, () => setState(() => showFicha = true))),
                const SizedBox(width: 6),
                Expanded(child: _bottomNovedades()),
                const SizedBox(width: 6),
                Expanded(child: _bottomBtn('Paute Aquí', Icons.campaign_outlined, () => _showPaute())),
              ]),
            ),
            if (showFicha) _fichaRegistro(),
          ],
        ),
      ),
    );
  }

  Widget _topMini(String label, IconData icon, VoidCallback onTap, {bool danger = false, bool black = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD0D8E8)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 14, color: danger ? Colors.orange : black ? Colors.black : const Color(0xFF0A2A6B)),
            const SizedBox(width: 3),
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0A2A6B)))),
          ]),
        ),
      ),
    );
  }

  Widget _bannerUnico() {
    if (bannerItems.isEmpty) return const SizedBox();
    final item = bannerItems.first;
    bool hayNovedad = item['tipo'] == 'mixto';
    return Container(
      margin: const EdgeInsets.all(10),
      height: 62,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: Row(children: [
        if (hayNovedad)
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(color: Color(0xFFE53935), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
              child: Row(children: [
                const Icon(Icons.build, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(item['novedadTipo'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('${item['novedadPlaca']} • 1.2km', style: const TextStyle(color: Colors.white, fontSize: 11)),
                ])
              ]),
            ),
          ),
        Expanded(
          flex: hayNovedad ? 6 : 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: hayNovedad
                    ? const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                    : BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.local_shipping, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(item['pautaNombre'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text('${item['pautaHorario']} • Cerca de ti', style: const TextStyle(color: Colors.white, fontSize: 11)),
              ])
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _bottomBtn(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFD0D8E8))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 20, color: Colors.black54), const SizedBox(height: 2), Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
      ),
    );
  }

  Widget _bottomNovedades() {
    bool hay = novedades.isNotEmpty;
    return AnimatedBuilder(
      animation: _blinkAnim,
      builder: (_, __) {
        return Opacity(
          opacity: hay ? _blinkAnim.value : 1.0,
          child: GestureDetector(
            onTap: () {
              _blinkController.stop();
              _showNovedades();
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                  color: hay ? Colors.orange.shade400 : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: hay ? Colors.orange : const Color(0xFFD0D8E8), width: hay ? 2 : 1),
                  boxShadow: hay ? [BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 8)] : []),
              child: Stack(
                children: [
                  Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.notifications_active, size: 20, color: hay ? Colors.white : Colors.orange), const SizedBox(height: 2), Text('Novedades', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: hay ? Colors.white : Colors.black))])),
                  if (hay)
                    Positioned(
                        top: 0,
                        right: 4,
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: Text('${novedades.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _fichaRegistro() {
    return Stack(children: [
      Positioned.fill(
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Registro Vehículo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                TextField(onChanged: (v) => placa = v.toUpperCase(), decoration: const InputDecoration(labelText: 'Placa Ej: ABC123', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: ElevatedButton(onPressed: () => setState(() => showFicha = false), child: const Text('Cancelar'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() => showFicha = false);
                            _actualizarBanner();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A2A6B)),
                          child: const Text('Guardar', style: TextStyle(color: Colors.white)))),
                ])
              ]),
            ),
          ),
        ),
      )
    ]);
  }

  void _showNovedades() {
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
            height: 350,
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              const Text('Novedades en la vía - Alertas colaborativas', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                  child: ListView.builder(
                      itemCount: novedades.length,
                      itemBuilder: (_, i) => Card(
                          child: ListTile(
                              title: Text(novedades[i]['tipo']),
                              subtitle: Text('${novedades[i]['placa']} • ${novedades[i]['dist']}'),
                              trailing: ElevatedButton(onPressed: () {}, child: const Text('Ayudar'))))))
            ])));
  }

  void _showPaute() {
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
            height: 380,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const Text('Paute Aquí - QR Wompi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              QrImageView(data: 'https://checkout.wompi.co/l/71663024', size: 160),
              const SizedBox(height: 10),
              const Text('Tu empresa aparece en mapa solo pagando pauta geolocalizada', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: () => _open('https://checkout.wompi.co/l/71663024'), child: const Text('Pagar Pauta Ahora')),
            ])));
  }

  void _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
