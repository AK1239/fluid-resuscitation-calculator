import 'package:flutter/material.dart';

/// Custom text field with unit label support
class CustomTextField extends StatelessWidget {
  final String label;
  final String? unit;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool enabled;
  final String? hintText;

  const CustomTextField({
    super.key,
    required this.label,
    this.unit,
    this.controller,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            if (unit != null) ...[
              const SizedBox(width: 8),
              Text(
                '($unit)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType ?? TextInputType.number,
          onChanged: onChanged,
          onTap: onTap,
          enabled: enabled,
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
