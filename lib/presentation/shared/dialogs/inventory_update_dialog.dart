import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

class InventoryUpdateDialog extends StatefulWidget {
  const InventoryUpdateDialog({
    super.key,
    required this.currentRemaining,
    required this.currentTotal,
  });

  final int currentRemaining;
  final int currentTotal;

  static Future<({int remaining, int total})?> show(
    BuildContext context, {
    required int currentRemaining,
    required int currentTotal,
  }) {
    return showDialog<({int remaining, int total})>(
      context: context,
      builder: (context) => InventoryUpdateDialog(
        currentRemaining: currentRemaining,
        currentTotal: currentTotal,
      ),
    );
  }

  @override
  State<InventoryUpdateDialog> createState() => _InventoryUpdateDialogState();
}

class _InventoryUpdateDialogState extends State<InventoryUpdateDialog> {
  late final TextEditingController _remainingController;
  late final TextEditingController _totalController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _remainingController = TextEditingController(
      text: widget.currentRemaining.toString(),
    );
    _totalController = TextEditingController(
      text: widget.currentTotal.toString(),
    );
  }

  @override
  void dispose() {
    _remainingController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  bool _validate() {
    final remaining = int.tryParse(_remainingController.text);
    final total = int.tryParse(_totalController.text);

    if (remaining == null || total == null) {
      setState(() => _errorText = 'Please enter valid numbers');
      return false;
    }

    if (remaining < 0) {
      setState(() => _errorText = 'Remaining must be 0 or greater');
      return false;
    }

    if (total <= 0) {
      setState(() => _errorText = 'Total must be greater than 0');
      return false;
    }

    if (remaining > total) {
      setState(() => _errorText = 'Remaining cannot exceed total');
      return false;
    }

    setState(() => _errorText = null);
    return true;
  }

  void _addToInventory(int amount) {
    final currentRemaining = int.tryParse(_remainingController.text) ?? 0;
    final currentTotal = int.tryParse(_totalController.text) ?? 0;

    _remainingController.text = (currentRemaining + amount).toString();
    _totalController.text = (currentTotal + amount).toString();
    _validate();
  }

  void _refill() {
    final total = int.tryParse(_totalController.text) ?? 0;
    _remainingController.text = total.toString();
    _validate();
  }

  void _save() {
    if (_validate()) {
      final remaining = int.parse(_remainingController.text);
      final total = int.parse(_totalController.text);
      Navigator.of(context).pop((remaining: remaining, total: total));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Text(
        'Update Inventory',
        style: textTheme.titleLarge?.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _remainingController,
              decoration: InputDecoration(
                labelText: 'Remaining',
                border: const OutlineInputBorder(),
                errorText: _errorText,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _totalController,
              decoration: const InputDecoration(
                labelText: 'Total',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Quick Actions',
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addToInventory(30),
                    icon: const Icon(Icons.add, size: AppSpacing.iconSm),
                    label: const Text('+30'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addToInventory(90),
                    icon: const Icon(Icons.add, size: AppSpacing.iconSm),
                    label: const Text('+90'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: _refill,
              icon: const Icon(Icons.refresh, size: AppSpacing.iconSm),
              label: const Text('Refill (Set Remaining = Total)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.success,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
