import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/features/premature_baby_fluid/domain/entities/premature_baby_fluid_result.dart';
import 'package:chemical_app/features/premature_baby_fluid/presentation/providers/premature_baby_fluid_providers.dart';
import 'package:chemical_app/features/premature_baby_fluid/presentation/widgets/premature_baby_fluid_result_widget.dart';

class PrematureBabyFluidScreen extends ConsumerStatefulWidget {
  const PrematureBabyFluidScreen({super.key});

  @override
  ConsumerState<PrematureBabyFluidScreen> createState() =>
      _PrematureBabyFluidScreenState();
}

class _PrematureBabyFluidScreenState
    extends ConsumerState<PrematureBabyFluidScreen> {
  late final TextEditingController _dayOfLifeController;
  late final TextEditingController _currentWeightController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dayOfLifeController = TextEditingController();
    _currentWeightController = TextEditingController();
  }

  @override
  void dispose() {
    _dayOfLifeController.dispose();
    _currentWeightController.dispose();
    super.dispose();
  }

  String? _validateDayOfLife(String? value) {
    if (value == null || value.isEmpty) {
      return 'Day of life is required';
    }
    final day = int.tryParse(value);
    if (day == null) {
      return 'Please enter a valid number';
    }
    if (day < 0 || day > 30) {
      return 'Day of life must be between 0-30';
    }
    return null;
  }

  String? _validateWeight(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    if (weight <= 0) {
      return '$fieldName must be greater than 0';
    }
    if (weight > 5) {
      return '$fieldName seems unrealistic (max 5 kg)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(prematureBabyFluidFormProvider);
    final result = ref.watch(prematureBabyFluidResultProvider);
    final formNotifier = ref.read(prematureBabyFluidFormProvider.notifier);

    // Sync controllers with state
    if (_dayOfLifeController.text != (formState.dayOfLife ?? '')) {
      _dayOfLifeController.text = formState.dayOfLife ?? '';
    }
    if (_currentWeightController.text != (formState.currentWeightKg ?? '')) {
      _currentWeightController.text = formState.currentWeightKg ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Premature Baby Fluid'),
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
                'Premature Baby Fluid Calculator',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Calculate IV fluid and feeding requirements based on MNH Clinical Guidelines',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              // Gestational category
              Text(
                'Gestational Category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<GestationalCategory>(
                initialValue: formState.gestationalCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: GestationalCategory.pretermLessThan1000g,
                    child: Text('Preterm <1000 g'),
                  ),
                  DropdownMenuItem(
                    value:
                        GestationalCategory.pretermLessThan35wGreaterThan1000g,
                    child: Text('Preterm <35 weeks & >1000 g'),
                  ),
                  DropdownMenuItem(
                    value: GestationalCategory.termNeonate,
                    child: Text('Term neonate'),
                  ),
                ],
                onChanged: (value) =>
                    formNotifier.setGestationalCategory(value),
              ),
              const SizedBox(height: 24),
              // Day of life
              CustomTextField(
                label: 'Day of Life',
                controller: _dayOfLifeController,
                validator: _validateDayOfLife,
                onChanged: (value) => formNotifier.setDayOfLife(value),
              ),
              const SizedBox(height: 16),
              // Current weight
              CustomTextField(
                label: 'Current Weight',
                unit: 'kg',
                controller: _currentWeightController,
                validator: (value) => _validateWeight(value, 'Current weight'),
                onChanged: (value) => formNotifier.setCurrentWeightKg(value),
              ),
              const SizedBox(height: 24),
              // EBM
              Text(
                'Can the baby take expressed breast milk (EBM)?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Yes')),
                  ButtonSegment(value: false, label: Text('No')),
                ],
                selected: {
                  if (formState.canTakeEbm != null) formState.canTakeEbm!,
                },
                emptySelectionAllowed: true,
                onSelectionChanged: (Set<bool> selected) {
                  formNotifier.setCanTakeEbm(selected.firstOrNull);
                },
              ),
              const SizedBox(height: 24),
              // Environment
              Text(
                'Environment',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Environment>(
                initialValue: formState.environment,
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: Environment.none,
                    child: Text('None'),
                  ),
                  DropdownMenuItem(
                    value: Environment.phototherapy,
                    child: Text('Phototherapy (open crib / non-humidified)'),
                  ),
                  DropdownMenuItem(
                    value: Environment.radiantWarmer,
                    child: Text('Radiant overhead warmer'),
                  ),
                ],
                onChanged: (value) => formNotifier.setEnvironment(value),
              ),
              const SizedBox(height: 24),
              // Clinical conditions
              Text(
                'Clinical Conditions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('Severe HIE'),
                value: formState.hasSevereHie,
                onChanged: (value) =>
                    formNotifier.setHasSevereHie(value ?? false),
              ),
              CheckboxListTile(
                title: const Text('AKI'),
                value: formState.hasAki,
                onChanged: (value) => formNotifier.setHasAki(value ?? false),
              ),
              CheckboxListTile(
                title: const Text('Cerebral edema'),
                value: formState.hasCerebralEdema,
                onChanged: (value) =>
                    formNotifier.setHasCerebralEdema(value ?? false),
              ),
              CheckboxListTile(
                title: const Text('Multi-organ damage'),
                value: formState.hasMultiOrganDamage,
                onChanged: (value) =>
                    formNotifier.setHasMultiOrganDamage(value ?? false),
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
                          'About This Calculator',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This calculator follows MNH Clinical Guidelines for premature baby fluid management. Calculations use current weight and apply appropriate adjustments for clinical conditions and environment.',
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
                PrematureBabyFluidResultWidget(result: result),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
