import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/core/utils/photo_encryption.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

class PhotoPickerButton extends ConsumerStatefulWidget {
  const PhotoPickerButton({
    super.key,
    this.currentPhotoPath,
    this.onPhotoChanged,
  });

  final String? currentPhotoPath;
  final ValueChanged<String?>? onPhotoChanged;

  @override
  ConsumerState<PhotoPickerButton> createState() => _PhotoPickerButtonState();
}

class _PhotoPickerButtonState extends ConsumerState<PhotoPickerButton> {
  Future<Uint8List>? _decryptedImageFuture;

  @override
  void initState() {
    super.initState();
    _updateDecryptionFuture();
  }

  @override
  void didUpdateWidget(PhotoPickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPhotoPath != widget.currentPhotoPath) {
      _updateDecryptionFuture();
    }
  }

  void _updateDecryptionFuture() {
    final path = widget.currentPhotoPath;
    if (path != null && PhotoEncryption.isEncrypted(path)) {
      final key = ref.read(storageServiceProvider).encryptionKeyBytes;
      _decryptedImageFuture = PhotoEncryption.decryptFromFile(path, key);
    } else {
      _decryptedImageFuture = null;
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) return;

      final bytes = await File(pickedFile.path).readAsBytes();
      final appDir = await getApplicationSupportDirectory();
      final fileName = 'med_photo_${DateTime.now().millisecondsSinceEpoch}';
      final destPath = '${appDir.path}/$fileName';

      final storage = ref.read(storageServiceProvider);
      final encPath = await PhotoEncryption.encryptAndSave(
        bytes,
        destPath,
        storage.encryptionKeyBytes,
      );

      widget.onPhotoChanged?.call(encPath);
    } catch (e, st) {
      ErrorHandler.debugLog(e, st, 'pickImage');
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToPickImage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showPhotoOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.takePhotoOption),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery);
              },
            ),
            if (widget.currentPhotoPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: Text(
                  l10n.removePhoto,
                  style: const TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(storageServiceProvider)
                      .deletePhotoFile(widget.currentPhotoPath);
                  widget.onPhotoChanged?.call(null);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPhotoOptions(context),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.borderLight,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: widget.currentPhotoPath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd - 2),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildPhotoWidget(),
                    Positioned(
                      bottom: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: AppSpacing.iconSm,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: context.appColors.textMuted,
                      size: AppSpacing.iconXl,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppLocalizations.of(context)!.takePhoto,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPhotoWidget() {
    if (_decryptedImageFuture != null) {
      return FutureBuilder<Uint8List>(
        future: _decryptedImageFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          if (snapshot.hasError) {
            return Center(
              child: Icon(
                Icons.broken_image,
                color: context.appColors.textMuted,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      );
    }
    // Legacy unencrypted photo (pre-migration)
    return Image.file(File(widget.currentPhotoPath!), fit: BoxFit.cover);
  }
}
