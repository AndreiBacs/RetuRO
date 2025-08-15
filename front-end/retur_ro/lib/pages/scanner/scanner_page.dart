import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:retur_ro/pages/scanner/camera_controls.dart';
import 'package:retur_ro/pages/scanner/scanner_overlay.dart';
import 'package:retur_ro/services/http_service.dart';

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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final isValid = response.success && response.data == true;

          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  isValid ? Icons.check_circle : Icons.cancel,
                  color: isValid ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(isValid ? 'Valid Barcode' : 'Invalid Barcode'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Large visual indicator
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isValid
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isValid ? Colors.green : Colors.red,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    isValid ? Icons.check : Icons.close,
                    size: 50,
                    color: isValid ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                // Barcode display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Code: $barcodeData',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Status message
                Text(
                  isValid
                      ? 'This barcode is valid and can be recycled!'
                      : 'This barcode is not valid for recycling.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isValid ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (!response.success) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Error: ${response.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
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
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to check barcode: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isDialogOpen = false;
                  });
                },
                child: const Text('Try Again'),
              ),
            ],
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
