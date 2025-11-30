import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatelessWidget {
  final String examCode;

  const QRScreen({super.key, required this.examCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam QR Code"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: examCode,
              version: QrVersions.auto,
              size: 250.0,
            ),
            const SizedBox(height: 20),
            Text(
              "Exam Code:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              examCode,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
