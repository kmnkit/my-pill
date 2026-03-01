import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;

  Future<void> _showManualInputSheet() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        String? errorText;
        return StatefulBuilder(
          builder: (_, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.enterInviteCode,
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    maxLength: 8,
                    decoration: InputDecoration(
                      hintText: l10n.inviteCodeHint,
                      errorText: errorText,
                      border: const OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (_) {
                      if (errorText != null) setState(() => errorText = null);
                    },
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () {
                      final input = controller.text.trim();
                      if (!RegExp(r'^[a-zA-Z0-9]{8}$').hasMatch(input)) {
                        setState(() => errorText = l10n.invalidInviteCode);
                        return;
                      }
                      Navigator.of(sheetContext).pop(input);
                    },
                    child: Text(l10n.acceptInvitation),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    controller.dispose();
    if (code != null && mounted) {
      _scanned = true;
      _controller.stop();
      Navigator.of(context).pop(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: KdAppBar(title: l10n.scanQrCode, showBack: true),
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
                l10n.positionQrCode,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ),
          // Manual code entry fallback
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: _showManualInputSheet,
                child: Text(
                  l10n.enterCodeManually,
                  style: const TextStyle(color: Colors.white),
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
      if (uri != null && uri.host.contains('kusuridoki.app')) {
        // Extract code from path: /invite/{code}
        final segments = uri.pathSegments;
        if (segments.length >= 2 && segments[0] == 'invite') {
          return segments[1];
        }
      }

      // If not a valid kusuridoki.app URL, return null
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
