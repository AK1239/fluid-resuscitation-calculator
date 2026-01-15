import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/norepinephrine/presentation/providers/norepinephrine_providers.dart';
import 'package:chemical_app/features/norepinephrine/presentation/widgets/norepinephrine_result_widget.dart';

class NorepinephrineScreen extends ConsumerStatefulWidget {
  const NorepinephrineScreen({super.key});

  @override
  ConsumerState<NorepinephrineScreen> createState() =>
      _NorepinephrineScreenState();
}

class _NorepinephrineScreenState extends ConsumerState<NorepinephrineScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _doseController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _doseController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(norepinephrineFormProvider);
    final result = ref.watch(norepinephrineResultProvider);
    final formNotifier = ref.read(norepinephrineFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_weightController.text != (formState.weight ?? '')) {
      _weightController.text = formState.weight ?? '';
    }
    if (_doseController.text != (formState.dose ?? '')) {
      _doseController.text = formState.dose ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Norepinephrine Infusion'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Infusion Dosing',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Standard concentration: 4 mg in 50 mL of 5% dextrose (80 µg/mL)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Body Weight',
              unit: 'kg',
              controller: _weightController,
              validator: validateWeight,
              onChanged: (value) => formNotifier.setWeight(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Target Dose',
              unit: 'µg/kg/min',
              controller: _doseController,
              validator: validateNorepinephrineDose,
              onChanged: (value) => formNotifier.setDose(value),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Dosing Guidelines',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Initial: 0.05–0.1 µg/kg/min\n'
                    '• Usual range: 0.05–0.3 µg/kg/min\n'
                    '• Maximum: 1 µg/kg/min (higher doses → ischemic risk)\n'
                    '• Titration: Increase every 2–5 min',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue.shade900,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              NorepinephrineResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
