import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/pediatric_burn_resuscitation/presentation/providers/pediatric_burn_resuscitation_providers.dart';
import 'package:chemical_app/features/pediatric_burn_resuscitation/presentation/widgets/pediatric_burn_resuscitation_result_widget.dart';

class PediatricBurnResuscitationScreen extends ConsumerStatefulWidget {
  const PediatricBurnResuscitationScreen({super.key});

  @override
  ConsumerState<PediatricBurnResuscitationScreen> createState() =>
      _PediatricBurnResuscitationScreenState();
}

class _PediatricBurnResuscitationScreenState
    extends ConsumerState<PediatricBurnResuscitationScreen> {
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
    final formState = ref.watch(pediatricBurnResuscitationFormProvider);
    final result = ref.watch(pediatricBurnResuscitationResultProvider);
    final formNotifier =
        ref.read(pediatricBurnResuscitationFormProvider.notifier);

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
        title: const Text('Pediatric Burn Resuscitation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/burn-resuscitation'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parkland Formula + Maintenance Fluids',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate initial fluid resuscitation for pediatric burn patients using Parkland formula with mandatory maintenance fluids (Holliday-Segar)',
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
              'Indication: ≥10% TBSA, or any burn with shock, electrical injury, or inhalation injury',
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
              'Electrical Injury',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('No')),
                ButtonSegment(value: true, label: Text('Yes')),
              ],
              selected: {
                if (formState.hasElectricalInjury != null)
                  formState.hasElectricalInjury!,
              },
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<bool> selected) {
                formNotifier.setHasElectricalInjury(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              PediatricBurnResuscitationResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
