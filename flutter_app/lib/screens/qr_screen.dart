import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr/qr.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String _url = "";
  QrCode? _qrCode;

  void _generateQR() {
    try {
      final qr = QrCode(4, QrErrorCorrectLevel.L);
      qr.addData(_url.trim());
      qr.make();

      setState(() {
        _qrCode = qr;
      });
    } catch (e) {
      debugPrint("QR error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR Code"),
        backgroundColor: Colors.pink.shade400,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Enter model URL",
              ),
              onChanged: (v) => setState(() => _url = v),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateQR,
              child: const Text("Generate"),
            ),
            const SizedBox(height: 20),
            if (_qrCode != null)
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: CustomPaint(
                  size: const Size(250, 250),
                  painter: _QrPainter(_qrCode!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  final QrCode qr;

  _QrPainter(this.qr);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final double cellSize = size.width / qr.moduleCount;

    for (int x = 0; x < qr.moduleCount; x++) {
      for (int y = 0; y < qr.moduleCount; y++) {
        if (qr.isDark(y, x)) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
