import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/constants/dehydration_ranges.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/fluid_resuscitation/presentation/providers/fluid_resuscitation_providers.dart';
import 'package:chemical_app/features/fluid_resuscitation/presentation/widgets/fluid_result_widget.dart';

class FluidResuscitationScreen extends ConsumerStatefulWidget {
  const FluidResuscitationScreen({super.key});

  @override
  ConsumerState<FluidResuscitationScreen> createState() =>
      _FluidResuscitationScreenState();
}

class _FluidResuscitationScreenState
    extends ConsumerState<FluidResuscitationScreen> {
  late final TextEditingController _weightController;

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
    final formState = ref.watch(fluidResuscitationFormProvider);
    final result = ref.watch(fluidResuscitationResultProvider);
    final formNotifier = ref.read(fluidResuscitationFormProvider.notifier);

    // Sync controller with state only if different (to avoid cursor jumping)
    if (_weightController.text != (formState.weight ?? '')) {
      _weightController.text = formState.weight ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluid Resuscitation'),
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
            // Patient Type
            Text(
              'Patient Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<PatientType>(
              segments: const [
                ButtonSegment(value: PatientType.adult, label: Text('Adult')),
                ButtonSegment(
                  value: PatientType.pediatric,
                  label: Text('Pediatric'),
                ),
              ],
              selected: {
                if (formState.patientType != null) formState.patientType!,
              },
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<PatientType> selected) {
                formNotifier.setPatientType(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 24),
            // Weight
            CustomTextField(
              label: 'Body Weight',
              unit: 'kg',
              controller: _weightController,
              validator: validateWeight,
              onChanged: (value) => formNotifier.setWeight(value),
            ),
            const SizedBox(height: 24),
            // Dehydration Severity
            Text(
              'Dehydration Severity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<DehydrationSeverity>(
              segments: const [
                ButtonSegment(
                  value: DehydrationSeverity.mild,
                  label: Text('Mild'),
                ),
                ButtonSegment(
                  value: DehydrationSeverity.moderate,
                  label: Text('Moderate'),
                ),
                ButtonSegment(
                  value: DehydrationSeverity.severe,
                  label: Text('Severe'),
                ),
              ],
              selected: {if (formState.severity != null) formState.severity!},
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<DehydrationSeverity> selected) {
                formNotifier.setSeverity(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 32),
            // Results
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              FluidResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
