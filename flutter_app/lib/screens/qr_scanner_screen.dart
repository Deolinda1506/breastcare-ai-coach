import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _hasPermission = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
        _isLoading = false;
      });
    } else if (status.isDenied) {
      final result = await Permission.camera.request();
      setState(() {
        _hasPermission = result.isGranted;
        _isLoading = false;
        if (!result.isGranted) {
          _errorMessage = 'Camera permission is required to scan QR codes';
        }
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _hasPermission = false;
        _isLoading = false;
        _errorMessage =
            'Camera permission was permanently denied. Please enable it in settings.';
      });
    } else {
      // Try to request permission anyway
      final result = await Permission.camera.request();
      setState(() {
        _hasPermission = result.isGranted;
        _isLoading = false;
        if (!result.isGranted) {
          _errorMessage = 'Camera permission is required to scan QR codes';
        }
      });
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    final result = await Permission.camera.request();
    final status = await Permission.camera.status;

    setState(() {
      _hasPermission = result.isGranted;
      _isLoading = false;
      if (!result.isGranted) {
        if (status.isPermanentlyDenied) {
          _errorMessage =
              'Camera permission was permanently denied. Please enable it in settings.';
        } else {
          _errorMessage = 'Camera permission is required to scan QR codes';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.pink.shade400,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasPermission) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage ?? 'Camera permission required',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _requestPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Autoriser la caméra'),
                ),
                const SizedBox(height: 16),
                FutureBuilder<PermissionStatus>(
                  future: Permission.camera.status,
                  builder: (context, snapshot) {
                    final status = snapshot.data ?? PermissionStatus.denied;
                    if (status.isPermanentlyDenied) {
                      return ElevatedButton(
                        onPressed: () async {
                          final result = await openAppSettings();
                          if (result && mounted) {
                            _checkCameraPermission();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Ouvrir les paramètres'),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    }

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.pink.shade400,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 250,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        if (scanData.code != null && scanData.code!.isNotEmpty) {
          controller.pauseCamera();
          if (mounted) {
            Navigator.pop(context, scanData.code);
          }
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Error scanning QR code: ${error.toString()}';
          });
        }
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
