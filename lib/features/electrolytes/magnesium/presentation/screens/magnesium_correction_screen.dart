import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/electrolytes/magnesium/presentation/providers/magnesium_providers.dart';
import 'package:chemical_app/features/electrolytes/magnesium/presentation/widgets/magnesium_result_widget.dart';

class MagnesiumCorrectionScreen extends ConsumerStatefulWidget {
  const MagnesiumCorrectionScreen({super.key});

  @override
  ConsumerState<MagnesiumCorrectionScreen> createState() =>
      _MagnesiumCorrectionScreenState();
}

class _MagnesiumCorrectionScreenState
    extends ConsumerState<MagnesiumCorrectionScreen> {
  late final TextEditingController _currentMgController;

  @override
  void initState() {
    super.initState();
    _currentMgController = TextEditingController();
  }

  @override
  void dispose() {
    _currentMgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(magnesiumFormProvider);
    final result = ref.watch(magnesiumResultProvider);
    final formNotifier = ref.read(magnesiumFormProvider.notifier);

    // Sync controller with state only if different (to avoid cursor jumping)
    if (_currentMgController.text != (formState.currentMg ?? '')) {
      _currentMgController.text = formState.currentMg ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Magnesium Correction'),
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
            CustomTextField(
              label: 'Current Magnesium',
              unit: 'mg/dL',
              controller: _currentMgController,
              validator: validateMagnesium,
              onChanged: (value) => formNotifier.setCurrentMg(value),
            ),
            const SizedBox(height: 24),
            Text(
              'Symptomatic?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Yes')),
                ButtonSegment(value: false, label: Text('No')),
              ],
              selected: {if (formState.isSymptomatic != null) formState.isSymptomatic!},
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<bool> selected) {
                formNotifier.setIsSymptomatic(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              MagnesiumResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}

