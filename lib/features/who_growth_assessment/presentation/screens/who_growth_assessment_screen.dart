import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/who_growth_assessment/presentation/providers/who_growth_providers.dart';
import 'package:chemical_app/features/who_growth_assessment/presentation/widgets/who_growth_result_widget.dart';

class WhoGrowthAssessmentScreen extends ConsumerStatefulWidget {
  const WhoGrowthAssessmentScreen({super.key});

  @override
  ConsumerState<WhoGrowthAssessmentScreen> createState() =>
      _WhoGrowthAssessmentScreenState();
}

class _WhoGrowthAssessmentScreenState
    extends ConsumerState<WhoGrowthAssessmentScreen> {
  late final TextEditingController _ageMonthsController;
  late final TextEditingController _weightKgController;
  late final TextEditingController _heightCmController;
  late final TextEditingController _wazController;
  late final TextEditingController _hazController;
  late final TextEditingController _whzController;

  @override
  void initState() {
    super.initState();
    _ageMonthsController = TextEditingController();
    _weightKgController = TextEditingController();
    _heightCmController = TextEditingController();
    _wazController = TextEditingController();
    _hazController = TextEditingController();
    _whzController = TextEditingController();
  }

  @override
  void dispose() {
    _ageMonthsController.dispose();
    _weightKgController.dispose();
    _heightCmController.dispose();
    _wazController.dispose();
    _hazController.dispose();
    _whzController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(whoGrowthFormProvider);
    final result = ref.watch(whoGrowthResultProvider);
    final formNotifier = ref.read(whoGrowthFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_ageMonthsController.text != (formState.ageMonths ?? '')) {
      _ageMonthsController.text = formState.ageMonths ?? '';
    }
    if (_weightKgController.text != (formState.weightKg ?? '')) {
      _weightKgController.text = formState.weightKg ?? '';
    }
    if (_heightCmController.text != (formState.heightCm ?? '')) {
      _heightCmController.text = formState.heightCm ?? '';
    }
    if (_wazController.text != (formState.waz ?? '')) {
      _wazController.text = formState.waz ?? '';
    }
    if (_hazController.text != (formState.haz ?? '')) {
      _hazController.text = formState.haz ?? '';
    }
    if (_whzController.text != (formState.whz ?? '')) {
      _whzController.text = formState.whz ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('WHO Growth Assessment'),
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
              'WHO Child Growth Standards',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Assess nutritional status using WHO Z-scores for children 0-59 months',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Age',
              unit: 'months',
              controller: _ageMonthsController,
              validator: validateAgeMonths,
              onChanged: (value) => formNotifier.setAgeMonths(value),
              hintText: 'e.g., 24',
            ),
            const SizedBox(height: 16),
            Text(
              'Sex',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Male')),
                ButtonSegment(value: false, label: Text('Female')),
              ],
              selected: {if (formState.isMale != null) formState.isMale!},
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<bool> selected) {
                formNotifier.setIsMale(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Weight',
              unit: 'kg',
              controller: _weightKgController,
              validator: validateWeight,
              onChanged: (value) => formNotifier.setWeightKg(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Length/Height',
              unit: 'cm',
              controller: _heightCmController,
              validator: validateHeightCm,
              onChanged: (value) => formNotifier.setHeightCm(value),
            ),
            const SizedBox(height: 24),
            Text(
              'WHO Z-Scores',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the calculated WHO Z-scores',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Weight-for-Age Z-score (WAZ)',
              unit: 'SD',
              controller: _wazController,
              validator: validateZScore,
              onChanged: (value) => formNotifier.setWaz(value),
              hintText: 'e.g., -1.5',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Height-for-Age Z-score (HAZ)',
              unit: 'SD',
              controller: _hazController,
              validator: validateZScore,
              onChanged: (value) => formNotifier.setHaz(value),
              hintText: 'e.g., -2.3',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Weight-for-Height Z-score (WHZ)',
              unit: 'SD',
              controller: _whzController,
              validator: validateZScore,
              onChanged: (value) => formNotifier.setWhz(value),
              hintText: 'e.g., -1.8',
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              WhoGrowthResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
