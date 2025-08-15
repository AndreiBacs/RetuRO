import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraControls extends StatefulWidget {
  final MobileScannerController cameraController;

  const CameraControls({super.key, required this.cameraController});

  @override
  State<CameraControls> createState() => _CameraControlsState();
}

class _CameraControlsState extends State<CameraControls>
    with SingleTickerProviderStateMixin {
  bool _showCameraControls = false;
  bool _isTorchOn = false;
  bool _isFrontCamera = false;
  Timer? _hideControlsTimer;

  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _widthAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _showCameraControls) {
        setState(() {
          _showCameraControls = false;
          _animationController.reverse();
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showCameraControls = !_showCameraControls;
      if (_showCameraControls) {
        _animationController.forward();
        _startHideTimer();
      } else {
        _animationController.reverse();
        _hideControlsTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(25),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              onPressed: _toggleControls,
            ),
            SizeTransition(
              sizeFactor: _widthAnimation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isTorchOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        widget.cameraController.toggleTorch();
                        setState(() {
                          _isTorchOn = !_isTorchOn;
                        });
                        _startHideTimer();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        widget.cameraController.switchCamera();
                        setState(() {
                          _isFrontCamera = !_isFrontCamera;
                        });
                        _startHideTimer();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
