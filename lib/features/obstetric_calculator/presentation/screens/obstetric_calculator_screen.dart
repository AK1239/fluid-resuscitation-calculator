import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/obstetric_calculator/presentation/providers/obstetric_providers.dart';
import 'package:chemical_app/features/obstetric_calculator/presentation/widgets/obstetric_result_widget.dart';

class ObstetricCalculatorScreen extends ConsumerStatefulWidget {
  const ObstetricCalculatorScreen({super.key});

  @override
  ConsumerState<ObstetricCalculatorScreen> createState() =>
      _ObstetricCalculatorScreenState();
}

class _ObstetricCalculatorScreenState
    extends ConsumerState<ObstetricCalculatorScreen> {
  late final TextEditingController _lmpController;
  late final TextEditingController _todayController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _lmpController = TextEditingController();
    _todayController = TextEditingController();
    
    // Set today's date as default
    final today = DateTime.now();
    final todayStr = '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';
    _todayController.text = todayStr;
  }

  @override
  void dispose() {
    _lmpController.dispose();
    _todayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(obstetricFormProvider);
    final result = ref.watch(obstetricResultProvider);
    final formNotifier = ref.read(obstetricFormProvider.notifier);

    // Initialize today's date in form state if not already set
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_todayController.text.isNotEmpty && formState.today == null) {
          formNotifier.setToday(_todayController.text);
        }
      });
    }

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_lmpController.text != (formState.lmp ?? '')) {
      _lmpController.text = formState.lmp ?? '';
    }
    if (_todayController.text != (formState.today ?? '')) {
      _todayController.text = formState.today ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Obstetric Calculator'),
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
              'EDD & Gestational Age',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate Estimated Date of Delivery (EDD) using Naegele\'s rule and current Gestational Age (GA)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Last Menstrual Period (LMP)',
              unit: 'DD/MM/YYYY',
              controller: _lmpController,
              validator: validateDate,
              onChanged: (value) => formNotifier.setLmp(value),
              hintText: '10/08/2025',
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Today\'s Date',
              unit: 'DD/MM/YYYY',
              controller: _todayController,
              validator: validateDate,
              onChanged: (value) => formNotifier.setToday(value),
              hintText: '11/01/2026',
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              ObstetricResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
