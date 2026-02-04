import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme.dart';

// Permission status provider (not autoDispose so state persists when navigating to settings)
final cameraPermissionProvider =
    StateProvider<PermissionStatus?>((ref) => null);

/// QR Scanner Screen - Uses mobile_scanner for scanning QR codes
/// Works on both Android and iOS
class QRScannerScreen extends ConsumerStatefulWidget {
  const QRScannerScreen({super.key});

  @override
  ConsumerState<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends ConsumerState<QRScannerScreen>
    with WidgetsBindingObserver {
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isScanned = false;

  /// Track if user explicitly went to settings via our button
  /// This distinguishes between:
  /// - Resume from settings (should try requesting permission)
  /// - Resume from other reasons like switching apps (should NOT request)
  bool _wentToSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Check initial permission status without requesting
    _checkCameraPermission(requestOnChange: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Recheck permission when app resumes from settings
    if (state == AppLifecycleState.resumed) {
      // Only try to request permission if user explicitly went to settings
      _checkCameraPermission(requestOnChange: _wentToSettings);
      // Reset the flag after checking
      _wentToSettings = false;
    }
  }

  /// Check camera permission status and optionally request if needed
  Future<void> _checkCameraPermission({bool requestOnChange = false}) async {
    final previousStatus = ref.read(cameraPermissionProvider);
    final status = await Permission.camera.status;

    print('DEBUG: _checkCameraPermission called');
    print('  requestOnChange: $requestOnChange');
    print('  previousStatus: $previousStatus');
    print('  currentStatus: $status');
    print('  isPermanentlyDenied: ${status.isPermanentlyDenied}');
    print('  isGranted: ${status.isGranted}');

    // If user came back from settings and permission is not granted yet,
    // try requesting permission - Android sometimes doesn't update the status
    // immediately even after user changes to "ask every time" in settings
    if (requestOnChange && !status.isGranted) {
      print('DEBUG: User returned from settings, trying to request permission');
      // Try requesting permission - if truly permanently denied, this will
      // just return permanently denied without showing dialog
      // If user changed to "ask every time", dialog will show
      final newStatus = await Permission.camera.request();
      print('DEBUG: Permission request result: $newStatus');
      ref.read(cameraPermissionProvider.notifier).state = newStatus;
    } else {
      print('DEBUG: Not requesting permission, just updating status');
      ref.read(cameraPermissionProvider.notifier).state = status;
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;

    print('DEBUG: _onDetect called');
    print('  capture: $capture');
    print('  capture.barcodes: ${capture.barcodes}');
    print('  capture.barcodes.length: ${capture.barcodes.length}');
    print('  capture.barcodes[0]: ${capture.barcodes[0]}');
    print('  capture.barcodes[0].rawValue: ${capture.barcodes[0].rawValue}');
    print('  capture.barcodes[0].type: ${capture.barcodes[0].type}');

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      _isScanned = true;

      // Vibrate or provide feedback
      // HapticFeedback.mediumImpact();

      // Return success
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionStatus = ref.watch(cameraPermissionProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Camera view or permission message
          if (permissionStatus?.isPermanentlyDenied ?? false)
            // Permanently denied message
            Center(
              child: Padding(
                padding: EdgeInsets.all(spacing24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: brandSecondary,
                      size: 80,
                    ),
                    const SizedBox(height: spacing24),
                    Text(
                      'Camera Permission Required',
                      style: h2Style.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: spacing16),
                    Text(
                      'Camera access is permanently denied. Please enable camera permission from your device settings to scan QR codes.',
                      style: bodyTextStyle.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: spacing24),
                    ElevatedButton(
                      onPressed: () {
                        _wentToSettings = true;
                        openAppSettings();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandSecondary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: spacing24,
                          vertical: spacing16,
                        ),
                      ),
                      child: Text(
                        'Open Settings',
                        style: bodyTextStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            // Show camera - mobile_scanner will handle permission request automatically
            MobileScanner(
              controller: cameraController,
              onDetect: _onDetect,
            ),

          // Overlay with scanning frame (show when camera is visible)
          if (!(permissionStatus?.isPermanentlyDenied ?? false))
            CustomPaint(
              painter: ScannerOverlayPainter(),
              child: const SizedBox.expand(),
            ),

          // Top bar with title and close button
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(spacing16),
                  child: Row(
                    children: [
                      // Close button
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      const SizedBox(width: spacing8),
                      // Title
                      Expanded(
                        child: Text(
                          'Scan QR Code',
                          style: h2Style.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      // Flash toggle (show when camera is visible)
                      if (!(permissionStatus?.isPermanentlyDenied ?? false))
                        IconButton(
                          icon: ValueListenableBuilder(
                            valueListenable: cameraController,
                            builder: (context, state, child) {
                              switch (state.torchState) {
                                case TorchState.on:
                                  return Icon(
                                    Icons.flash_on,
                                    color: brandSecondary,
                                    size: 28,
                                  );
                                case TorchState.off:
                                case TorchState.auto:
                                case TorchState.unavailable:
                                  return const Icon(
                                    Icons.flash_off,
                                    color: Colors.white,
                                    size: 28,
                                  );
                              }
                            },
                          ),
                          onPressed: () {
                            cameraController.toggleTorch();
                          },
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                // Bottom instruction text (show when camera is visible)
                if (!(permissionStatus?.isPermanentlyDenied ?? false))
                  Container(
                    padding: const EdgeInsets.all(spacing24),
                    child: Text(
                      'Position the QR code within the frame',
                      style: bodyTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double scanAreaSize = 250.0;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;
    final Rect scanArea = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);

    // Draw dimmed overlay
    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5);

    canvas.drawPath(
      Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRRect(RRect.fromRectAndRadius(
            scanArea, const Radius.circular(radiusLarge)))
        ..fillType = PathFillType.evenOdd,
      backgroundPaint,
    );

    // Draw corner brackets
    final Paint cornerPaint = Paint()
      ..color = brandSecondary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const double cornerLength = 30;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(left, top + cornerLength)
        ..lineTo(left, top + radiusLarge)
        ..arcToPoint(
          Offset(left + radiusLarge, top),
          radius: const Radius.circular(radiusLarge),
        )
        ..lineTo(left + cornerLength, top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(left + scanAreaSize - cornerLength, top)
        ..lineTo(left + scanAreaSize - radiusLarge, top)
        ..arcToPoint(
          Offset(left + scanAreaSize, top + radiusLarge),
          radius: const Radius.circular(radiusLarge),
        )
        ..lineTo(left + scanAreaSize, top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(left, top + scanAreaSize - cornerLength)
        ..lineTo(left, top + scanAreaSize - radiusLarge)
        ..arcToPoint(
          Offset(left + radiusLarge, top + scanAreaSize),
          radius: const Radius.circular(radiusLarge),
        )
        ..lineTo(left + cornerLength, top + scanAreaSize),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(left + scanAreaSize - cornerLength, top + scanAreaSize)
        ..lineTo(left + scanAreaSize - radiusLarge, top + scanAreaSize)
        ..arcToPoint(
          Offset(left + scanAreaSize, top + scanAreaSize - radiusLarge),
          radius: const Radius.circular(radiusLarge),
        )
        ..lineTo(left + scanAreaSize, top + scanAreaSize - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
