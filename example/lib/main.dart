import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_code_scanner/src/qr_code_scanner.dart';
import 'package:flutter_code_scanner/src/qr_scanner_overlay_shape.dart';
import 'package:flutter_code_scanner/src/types/barcode.dart';

void main() => runApp(const MaterialApp(home: Home()));

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const QrExample(),
              ));
            },
            child: const Text('Scan Qr Code'),
          ),
        ),
      ),
    );
  }
}

class QrExample extends StatefulWidget {
  const QrExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrExampleState();
}

class _QrExampleState extends State<QrExample> {
  Barcode? result;
  QrController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void resumeC() async {
    await controller?.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    resumeC();
  }

  @override
  Widget build(BuildContext context) {
    resumeC();
    return Scaffold(
      backgroundColor: const Color(0xFF4A4A4A).withOpacity(1),
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 180.0
        : 240.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderLength: 30,
        borderWidth: 5,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QrController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QrController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
