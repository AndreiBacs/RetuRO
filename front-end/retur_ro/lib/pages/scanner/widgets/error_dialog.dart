import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onTryAgain;

  const ErrorDialog({
    super.key,
    required this.errorMessage,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text('Failed to check barcode: $errorMessage'),
      actions: [
        ElevatedButton(onPressed: onTryAgain, child: const Text('Try Again')),
      ],
    );
  }
}
