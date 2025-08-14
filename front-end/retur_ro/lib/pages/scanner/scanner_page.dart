import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:retur_ro/pages/scanner/camera_controls.dart';
import 'package:retur_ro/pages/scanner/scanner_overlay.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isStarted = true;
  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              // Prevent multiple scans while dialog is open
              if (_isDialogOpen) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
                _showBarcodeResult(barcode.rawValue ?? 'No data');
                break; // Only process the first barcode to avoid multiple dialogs
              }
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(painter: ScannerOverlay(context: context)),
          ),
          CameraControls(cameraController: cameraController),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Position barcode within the frame',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBarcodeResult(String barcodeData) {
    setState(() {
      _isDialogOpen = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Barcode Scanned'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Code: $barcodeData'),
              const SizedBox(height: 10),
              const Text('What would you like to do with this barcode?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isDialogOpen = false;
                });
                // Here you can add logic to search for the barcode
                // For example, navigate to search page with the barcode
              },
              child: const Text('Search'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isDialogOpen = false;
                });
              },
              child: const Text('Scan Again'),
            ),
          ],
        );
      },
    ).then((_) {
      // Ensure dialog state is reset if dialog is dismissed in any way
      if (mounted) {
        setState(() {
          _isDialogOpen = false;
        });
      }
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
