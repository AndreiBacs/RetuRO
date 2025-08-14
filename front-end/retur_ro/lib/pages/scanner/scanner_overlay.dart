import 'package:flutter/material.dart';

class ScannerOverlay extends CustomPainter {
  final BuildContext context;

  const ScannerOverlay({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final colorScheme = Theme.of(context).colorScheme;
    final paint = Paint()
      ..color = Theme.of(context).brightness == Brightness.dark
          ? const Color(0xCC000000) // Darker overlay for dark theme
          : const Color(0x66000000) // Lighter overlay for light theme
      ..style = PaintingStyle.fill;

    final scanArea = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: size.height * 0.3,
    );

    // Draw the overlay
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(
          RRect.fromRectAndRadius(scanArea, const Radius.circular(12)),
        ),
      ),
      paint,
    );

    // Draw the corner markers
    final cornerPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const cornerLength = 30.0;
    const cornerRadius = 8.0;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left, scanArea.top + cornerLength)
        ..lineTo(scanArea.left, scanArea.top + cornerRadius)
        ..arcToPoint(
          Offset(scanArea.left + cornerRadius, scanArea.top),
          radius: const Radius.circular(cornerRadius),
        )
        ..lineTo(scanArea.left + cornerLength, scanArea.top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right - cornerLength, scanArea.top)
        ..lineTo(scanArea.right - cornerRadius, scanArea.top)
        ..arcToPoint(
          Offset(scanArea.right, scanArea.top + cornerRadius),
          radius: const Radius.circular(cornerRadius),
        )
        ..lineTo(scanArea.right, scanArea.top + cornerLength),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right, scanArea.bottom - cornerLength)
        ..lineTo(scanArea.right, scanArea.bottom - cornerRadius)
        ..arcToPoint(
          Offset(scanArea.right - cornerRadius, scanArea.bottom),
          radius: const Radius.circular(cornerRadius),
        )
        ..lineTo(scanArea.right - cornerLength, scanArea.bottom),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left + cornerLength, scanArea.bottom)
        ..lineTo(scanArea.left + cornerRadius, scanArea.bottom)
        ..arcToPoint(
          Offset(scanArea.left, scanArea.bottom - cornerRadius),
          radius: const Radius.circular(cornerRadius),
        )
                 ..lineTo(scanArea.left, scanArea.bottom - cornerLength),
       cornerPaint,
     );

     // Draw the laser line (dashed)
     final laserPaint = Paint()
       ..color = Colors.red
       ..style = PaintingStyle.stroke
       ..strokeWidth = 2;

     final laserY = scanArea.center.dy;
     final dashWidth = 8.0;
     final dashSpace = 4.0;
     final startX = scanArea.left + 10;
     final endX = scanArea.right - 10;
     
     double currentX = startX;
     while (currentX < endX) {
       final dashEndX = (currentX + dashWidth).clamp(currentX, endX);
       canvas.drawLine(
         Offset(currentX, laserY),
         Offset(dashEndX, laserY),
         laserPaint,
       );
       currentX += dashWidth + dashSpace;
     }
   }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
