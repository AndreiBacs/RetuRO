# Mobile Scanner Setup

This document describes the setup and configuration of the `mobile_scanner` package in the RetuRO Flutter application.

## Package Added

- **mobile_scanner**: ^3.5.6

## Android Configuration

### Permissions Added to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="true" />
```

### Features:
- Camera permission for barcode scanning
- Hardware camera feature requirement
- Supports both front and back cameras
- Torch/flashlight control

## iOS Configuration

### Permissions Added to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to camera to scan barcodes.</string>
```

### Features:
- Camera usage description for App Store compliance
- Supports iOS camera permissions

## Implementation

### Scanner Page (`lib/pages/scanner/scanner_page.dart`)

The scanner page includes:

1. **MobileScanner Widget**: Main camera view for barcode detection
2. **Custom Overlay**: Visual guide with corner markers for barcode positioning
3. **App Bar Controls**:
   - Torch/flashlight toggle
   - Camera switch (front/back)
4. **Barcode Detection**: Automatic detection with result dialog
5. **UI Features**:
   - Green theme matching the app
   - User-friendly instructions
   - Result dialog with options to search or scan again

### Integration

The scanner is integrated into the app as a dedicated tab in the bottom navigation bar:
- Positioned between Search and Profile tabs
- Uses QR scanner icon for easy identification
- Provides direct access to the scanner functionality

## Usage

1. Tap the "Scanner" tab in the bottom navigation bar
2. Grant camera permissions when prompted
3. Position barcode within the green corner markers
4. The app will automatically detect and display the barcode
5. Choose to search for the barcode or scan another

## Supported Barcode Formats

The mobile_scanner package supports multiple barcode formats including:
- QR Code
- Code 128
- Code 39
- EAN-13
- EAN-8
- UPC-A
- UPC-E
- And many more

## Troubleshooting

### Common Issues:

1. **Camera Permission Denied**:
   - Go to device settings and enable camera permission for the app
   - Restart the app after granting permission

2. **Scanner Not Working**:
   - Ensure the device has a camera
   - Check that camera permissions are granted
   - Try switching between front and back cameras

3. **Poor Scanning Performance**:
   - Ensure good lighting conditions
   - Hold the device steady
   - Make sure the barcode is within the scan area
   - Try using the torch/flashlight in low light

## Dependencies

The mobile_scanner package automatically handles:
- Camera initialization
- Permission requests
- Barcode detection algorithms
- Platform-specific implementations

No additional native dependencies are required beyond the Flutter package.
