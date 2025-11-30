import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Code Test")),
      body: Center(
        child: QrImage(
          data: "HELLO-WORLD-TEST",
          version: QrVersions.auto,
          size: 250,
        ),
      ),
    );
  }
}
