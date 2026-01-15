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
  DateTime? _selectedCalculationDate;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(obstetricFormProvider);
    final result = ref.watch(obstetricResultProvider);
    final formNotifier = ref.read(obstetricFormProvider.notifier);

    // Sync selected dates with form state
    if (_selectedLmp != formState.lmp) {
      _selectedLmp = formState.lmp;
    }
    if (_selectedCalculationDate != formState.calculationDate) {
      _selectedCalculationDate = formState.calculationDate;
    }

    Future<void> selectLmpDate(BuildContext context) async {
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

    Future<void> selectCalculationDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedCalculationDate ?? DateTime.now(),
        firstDate: _selectedLmp ?? DateTime(1900),
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
        title: const Text('LMP Calculator'),
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
              onTap: () => selectLmpDate(context),
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
            const SizedBox(height: 24),
            // Calculation Date Picker Field
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
