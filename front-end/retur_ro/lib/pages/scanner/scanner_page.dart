import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:retur_ro/pages/scanner/widgets/camera_controls.dart';
import 'package:retur_ro/pages/scanner/widgets/scanner_overlay.dart';
import 'package:retur_ro/services/http_service.dart';
import 'package:retur_ro/pages/scanner/widgets/barcode_result_dialog.dart';
import 'package:retur_ro/pages/scanner/widgets/error_dialog.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isStarted = true;
  bool _isDialogOpen = false;
  final HttpService _httpService = HttpService();

  @override
  void initState() {
    super.initState();
    _httpService.initialize();
  }

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
                  color: Colors.black.withValues(alpha: 0.54),
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

  void _showBarcodeResult(String barcodeData) async {
    setState(() {
      _isDialogOpen = true;
    });

    // Show loading dialog first
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Checking barcode...'),
            ],
          ),
        );
      },
    );

    try {
      // Make API call to check barcode
      final response = await _httpService.post(
        ApiEndpoints.barcodeCheck,
        body: {'barcode': barcodeData},
      );

      // Check if widget is still mounted before using context
      if (!mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      // Show result dialog
      final isValid = response.success && response.data == true;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BarcodeResultDialog(
            isValid: isValid,
            barcodeData: barcodeData,
            errorMessage: !response.success ? response.message : null,
            onScanAgain: () {
              Navigator.of(context).pop();
              setState(() {
                _isDialogOpen = false;
              });
            },
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
    } catch (e) {
      // Check if widget is still mounted before using context
      if (!mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      // Show error dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMessage: e.toString(),
            onTryAgain: () {
              Navigator.of(context).pop();
              setState(() {
                _isDialogOpen = false;
              });
            },
          );
        },
      ).then((_) {
        if (mounted) {
          setState(() {
            _isDialogOpen = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    _httpService.dispose();
    super.dispose();
  }
}
