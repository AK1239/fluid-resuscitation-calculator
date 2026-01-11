import 'package:flutter/material.dart';
import 'package:chemical_app/core/constants/app_constants.dart';

/// Reusable disclaimer dialog component
class DisclaimerDialog extends StatelessWidget {
  final VoidCallback onAccept;

  const DisclaimerDialog({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Important Disclaimer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.disclaimerText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Please use this app responsibly and always consult with qualified healthcare professionals for clinical decisions.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAccept();
          },
          child: const Text('I Understand'),
        ),
      ],
    );
  }
}
