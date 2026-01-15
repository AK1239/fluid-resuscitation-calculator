import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/obstetric_calculator/presentation/providers/ultrasound_providers.dart';
import 'package:chemical_app/features/obstetric_calculator/presentation/widgets/ultrasound_result_widget.dart';

class UltrasoundCalculatorScreen extends ConsumerStatefulWidget {
  const UltrasoundCalculatorScreen({super.key});

  @override
  ConsumerState<UltrasoundCalculatorScreen> createState() =>
      _UltrasoundCalculatorScreenState();
}

class _UltrasoundCalculatorScreenState
    extends ConsumerState<UltrasoundCalculatorScreen> {
  DateTime? _selectedUltrasoundDate;
  DateTime? _selectedCalculationDate;
  late final TextEditingController _gaWeeksController;
  late final TextEditingController _gaDaysController;

  @override
  void initState() {
    super.initState();
    _gaWeeksController = TextEditingController();
    _gaDaysController = TextEditingController();
  }

  @override
  void dispose() {
    _gaWeeksController.dispose();
    _gaDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(ultrasoundFormProvider);
    final result = ref.watch(ultrasoundResultProvider);
    final formNotifier = ref.read(ultrasoundFormProvider.notifier);

    // Sync selected dates with form state
    if (_selectedUltrasoundDate != formState.ultrasoundDate) {
      _selectedUltrasoundDate = formState.ultrasoundDate;
    }
    if (_selectedCalculationDate != formState.calculationDate) {
      _selectedCalculationDate = formState.calculationDate;
    }

    // Sync controllers with state
    if (_gaWeeksController.text != (formState.gaWeeks ?? '')) {
      _gaWeeksController.text = formState.gaWeeks ?? '';
    }
    if (_gaDaysController.text != (formState.gaDays ?? '')) {
      _gaDaysController.text = formState.gaDays ?? '';
    }

    Future<void> selectUltrasoundDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedUltrasoundDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        helpText: 'Select Ultrasound Date',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          _selectedUltrasoundDate = picked;
        });
        formNotifier.setUltrasoundDate(picked);
      }
    }

    Future<void> selectCalculationDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedCalculationDate ?? DateTime.now(),
        firstDate: _selectedUltrasoundDate ?? DateTime(1900),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        helpText: 'Select Date for GA Calculation',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          _selectedCalculationDate = picked;
        });
        formNotifier.setCalculationDate(picked);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ultrasound Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/obstetric-calculator'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Gestational Age',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate current GA based on early-trimester ultrasound dating scan',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            // Ultrasound Date Picker
            Text(
              'Date of Ultrasound',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => selectUltrasoundDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'Tap to select date',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedUltrasoundDate != null
                          ? formatDate(_selectedUltrasoundDate!)
                          : 'Select ultrasound date',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: _selectedUltrasoundDate != null
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // GA at Ultrasound
            Text(
              'Gestational Age at Ultrasound',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter GA in format: W+D (e.g., 20+2 means 20 weeks and 2 days)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Weeks',
                    controller: _gaWeeksController,
                    validator: validateGaWeeks,
                    onChanged: (value) => formNotifier.setGaWeeks(value),
                    hintText: 'e.g., 20',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    label: 'Days',
                    controller: _gaDaysController,
                    validator: validateGaDays,
                    onChanged: (value) => formNotifier.setGaDays(value),
                    hintText: '0-6',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Calculation Date Picker
            Text(
              'Date for GA Calculation',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => selectCalculationDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'Tap to select date (defaults to today)',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCalculationDate != null
                          ? formatDate(_selectedCalculationDate!)
                          : 'Today (${formatDate(DateTime.now())})',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: _selectedCalculationDate != null
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Leave unselected to use today\'s date, or select any date for retrospective charting',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
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
                        'Clinical Notes',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Ultrasound dating is assumed to be from early pregnancy\n'
                    '• Treated as the reference standard for GA calculation\n'
                    '• Days must be between 0-6',
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
              UltrasoundResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
