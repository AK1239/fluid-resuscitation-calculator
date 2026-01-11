import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/utils/formatters.dart';
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
  DateTime? _selectedLmp;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(obstetricFormProvider);
    final result = ref.watch(obstetricResultProvider);
    final formNotifier = ref.read(obstetricFormProvider.notifier);

    // Sync selected date with form state
    if (_selectedLmp != formState.lmp) {
      _selectedLmp = formState.lmp;
    }

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedLmp ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        helpText: 'Select Last Menstrual Period',
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
          _selectedLmp = picked;
        });
        formNotifier.setLmp(picked);
      }
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
            // LMP Date Picker Field
            Text(
              'Last Menstrual Period (LMP)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => selectDate(context),
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
                      _selectedLmp != null
                          ? formatDate(_selectedLmp!)
                          : 'Select LMP date',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _selectedLmp != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (formState.lmp != null) ...[
              const SizedBox(height: 8),
              Text(
                'Today\'s date is automatically used for calculation',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
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
