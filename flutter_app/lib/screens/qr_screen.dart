import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatelessWidget {
  final String qrData;

  const QRScreen({Key? key, required this.qrData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Device'),
        backgroundColor: Colors.pink.shade400,
      ),
      body: Center(
        child: QrImage(
          data: qrData,
          version: QrVersions.auto,
          size: 250.0,
        ),
      ),
    );
  }
}
