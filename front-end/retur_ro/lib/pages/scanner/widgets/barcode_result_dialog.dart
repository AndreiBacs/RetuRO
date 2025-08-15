import 'package:flutter/material.dart';

class BarcodeResultDialog extends StatelessWidget {
  final bool isValid;
  final String barcodeData;
  final String? errorMessage;
  final VoidCallback onScanAgain;

  const BarcodeResultDialog({
    super.key,
    required this.isValid,
    required this.barcodeData,
    this.errorMessage,
    required this.onScanAgain,
  });

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          if (errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Error: $errorMessage',
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
      actions: [
        ElevatedButton(onPressed: onScanAgain, child: const Text('Scan Again')),
      ],
    );
  }
}
