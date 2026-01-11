import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/burn_resuscitation/presentation/providers/burn_resuscitation_providers.dart';
import 'package:chemical_app/features/burn_resuscitation/presentation/widgets/burn_resuscitation_result_widget.dart';

class BurnResuscitationScreen extends ConsumerStatefulWidget {
  const BurnResuscitationScreen({super.key});

  @override
  ConsumerState<BurnResuscitationScreen> createState() =>
      _BurnResuscitationScreenState();
}

class _BurnResuscitationScreenState
    extends ConsumerState<BurnResuscitationScreen> {
  late final TextEditingController _ageYearsController;
  late final TextEditingController _weightKgController;
  late final TextEditingController _tbsaPercentController;
  late final TextEditingController _timeSinceBurnHoursController;

  @override
  void initState() {
    super.initState();
    _ageYearsController = TextEditingController();
    _weightKgController = TextEditingController();
    _tbsaPercentController = TextEditingController();
    _timeSinceBurnHoursController = TextEditingController();
  }

  @override
  void dispose() {
    _ageYearsController.dispose();
    _weightKgController.dispose();
    _tbsaPercentController.dispose();
    _timeSinceBurnHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(burnResuscitationFormProvider);
    final result = ref.watch(burnResuscitationResultProvider);
    final formNotifier = ref.read(burnResuscitationFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_ageYearsController.text != (formState.ageYears ?? '')) {
      _ageYearsController.text = formState.ageYears ?? '';
    }
    if (_weightKgController.text != (formState.weightKg ?? '')) {
      _weightKgController.text = formState.weightKg ?? '';
    }
    if (_tbsaPercentController.text != (formState.tbsaPercent ?? '')) {
      _tbsaPercentController.text = formState.tbsaPercent ?? '';
    }
    if (_timeSinceBurnHoursController.text !=
        (formState.timeSinceBurnHours ?? '')) {
      _timeSinceBurnHoursController.text = formState.timeSinceBurnHours ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Burn Resuscitation'),
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
              'Parkland Formula',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate initial fluid resuscitation for burn patients using Parkland formula',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Age',
              unit: 'years',
              controller: _ageYearsController,
              validator: validateAgeYears,
              onChanged: (value) => formNotifier.setAgeYears(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Body Weight',
              unit: 'kg',
              controller: _weightKgController,
              validator: validateWeight,
              onChanged: (value) => formNotifier.setWeightKg(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: '% TBSA Burned',
              unit: '%',
              controller: _tbsaPercentController,
              validator: validateTbsaPercent,
              onChanged: (value) => formNotifier.setTbsaPercent(value),
              hintText: 'Do NOT include superficial burns',
            ),
            const SizedBox(height: 8),
            Text(
              'Indication: Adults ≥10-15%, Children ≥10%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Time Since Burn Injury',
              unit: 'hours',
              controller: _timeSinceBurnHoursController,
              validator: validateTimeHours,
              onChanged: (value) => formNotifier.setTimeSinceBurnHours(value),
              hintText: 'From moment of burn, not hospital arrival',
            ),
            const SizedBox(height: 24),
            Text(
              'Inhalation Injury',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('No')),
                ButtonSegment(value: true, label: Text('Yes')),
              ],
              selected: {
                if (formState.hasInhalationInjury != null)
                  formState.hasInhalationInjury!,
              },
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<bool> selected) {
                formNotifier.setHasInhalationInjury(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Urine Output Available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('No')),
                ButtonSegment(value: true, label: Text('Yes')),
              ],
              selected: {
                if (formState.hasUrineOutputAvailable != null)
                  formState.hasUrineOutputAvailable!,
              },
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<bool> selected) {
                formNotifier.setHasUrineOutputAvailable(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              BurnResuscitationResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
