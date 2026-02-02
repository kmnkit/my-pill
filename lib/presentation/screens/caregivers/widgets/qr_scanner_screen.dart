import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MpAppBar(title: 'Scan QR Code', showBack: true),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_scanned) return;
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final value = barcode.rawValue;
                if (value != null) {
                  // Try to extract invite code from URL
                  final code = _extractInviteCode(value);
                  if (code != null) {
                    _scanned = true;
                    _controller.stop();
                    Navigator.of(context).pop(code);
                    break;
                  }
                }
              }
            },
          ),
          // Overlay with scan area guide
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Instructions overlay
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Position the QR code within the frame',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _extractInviteCode(String scannedValue) {
    try {
      // Try to parse as URL
      final uri = Uri.tryParse(scannedValue);
      if (uri != null && uri.host.contains('mypill.app')) {
        // Extract code from path: /invite/{code}
        final segments = uri.pathSegments;
        if (segments.length >= 2 && segments[0] == 'invite') {
          return segments[1];
        }
      }

      // If not a valid mypill.app URL, return null
      return null;
    } catch (e) {
      // Invalid URL format
      return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
