import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/maintenance_calories/domain/entities/maintenance_calories_result.dart';
import 'package:chemical_app/features/maintenance_calories/presentation/providers/maintenance_calories_providers.dart';
import 'package:chemical_app/features/maintenance_calories/presentation/widgets/maintenance_calories_result_widget.dart';

class MaintenanceCaloriesScreen extends ConsumerStatefulWidget {
  const MaintenanceCaloriesScreen({super.key});

  @override
  ConsumerState<MaintenanceCaloriesScreen> createState() =>
      _MaintenanceCaloriesScreenState();
}

class _MaintenanceCaloriesScreenState
    extends ConsumerState<MaintenanceCaloriesScreen> {
  late final TextEditingController _weightController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(maintenanceCaloriesFormProvider);
    final result = ref.watch(maintenanceCaloriesResultProvider);
    final formNotifier = ref.read(maintenanceCaloriesFormProvider.notifier);

    // Sync controller with state
    if (_weightController.text != (formState.weightKg ?? '')) {
      _weightController.text = formState.weightKg ?? '';
    }

    // Get current category range if category is selected
    PatientCategoryRange? currentRange;
    if (formState.category != null) {
      currentRange = PatientCategoryRange.ranges[formState.category]!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Calories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maintenance Calories Calculator',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Calculate daily caloric requirements and equivalent IV dextrose volumes',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              // Weight input
              CustomTextField(
                label: 'Patient Weight',
                unit: 'kg',
                controller: _weightController,
                validator: validateWeight,
                onChanged: (value) => formNotifier.setWeightKg(value),
              ),
              const SizedBox(height: 24),
              // Patient category dropdown
              Text(
                'Patient Category / Clinical Condition',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<PatientCategory>(
                value: formState.category,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: PatientCategory.values.map((category) {
                  final range = PatientCategoryRange.ranges[category]!;
                  return DropdownMenuItem(
                    value: category,
                    child: Text(range.displayName),
                  );
                }).toList(),
                onChanged: (value) => formNotifier.setCategory(value),
              ),
              if (currentRange != null) ...[
                const SizedBox(height: 24),
                // Caloric target slider
                Text(
                  'Caloric Target',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${currentRange.minKcalPerKgPerDay.toStringAsFixed(0)} - ${currentRange.maxKcalPerKgPerDay.toStringAsFixed(0)} kcal/kg/day',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: formState.kcalPerKgPerDay ?? currentRange.midpointKcalPerKgPerDay,
                  min: currentRange.minKcalPerKgPerDay,
                  max: currentRange.maxKcalPerKgPerDay,
                  divisions: ((currentRange.maxKcalPerKgPerDay - currentRange.minKcalPerKgPerDay) * 10).round(),
                  label: '${(formState.kcalPerKgPerDay ?? currentRange.midpointKcalPerKgPerDay).toStringAsFixed(1)} kcal/kg/day',
                  onChanged: (value) {
                    formNotifier.setKcalPerKgPerDay(value);
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${currentRange.minKcalPerKgPerDay.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Selected: ${(formState.kcalPerKgPerDay ?? currentRange.midpointKcalPerKgPerDay).toStringAsFixed(1)} kcal/kg/day',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    Text(
                      '${currentRange.maxKcalPerKgPerDay.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
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
                          'About This Calculator',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This calculator determines daily maintenance caloric requirements based on patient condition and converts them to equivalent IV dextrose volumes. Note: Calculations are for caloric requirements only and do not include electrolyte or fluid needs.',
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
                MaintenanceCaloriesResultWidget(result: result),
              ],
            ],
          ),
        ),
      ),
    );
  }
}