import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/features/bishop_score/domain/entities/bishop_score_result.dart';
import 'package:chemical_app/features/bishop_score/presentation/providers/bishop_score_providers.dart';
import 'package:chemical_app/features/bishop_score/presentation/widgets/bishop_score_result_widget.dart';

class BishopScoreScreen extends ConsumerWidget {
  const BishopScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(bishopScoreFormProvider);
    final result = ref.watch(bishopScoreResultProvider);
    final formNotifier = ref.read(bishopScoreFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bishop Score'),
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
              'Bishop Score Calculator',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Assess cervical favorability for induction of labor',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            // Cervical Dilation
            Text(
              'Cervical Dilation',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CervicalDilation>(
              value: formState.dilation,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: CervicalDilation.zero,
                  child: Text('0 cm'),
                ),
                DropdownMenuItem(
                  value: CervicalDilation.oneToTwo,
                  child: Text('1-2 cm'),
                ),
                DropdownMenuItem(
                  value: CervicalDilation.threeToFour,
                  child: Text('3-4 cm'),
                ),
                DropdownMenuItem(
                  value: CervicalDilation.fiveOrMore,
                  child: Text('≥5 cm'),
                ),
              ],
              onChanged: (value) => formNotifier.setDilation(value),
            ),
            const SizedBox(height: 24),
            // Cervical Effacement
            Text(
              'Cervical Effacement',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CervicalEffacement>(
              initialValue: formState.effacement,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: CervicalEffacement.zeroToThirty,
                  child: Text('0-30%'),
                ),
                DropdownMenuItem(
                  value: CervicalEffacement.fortyToFifty,
                  child: Text('40-50%'),
                ),
                DropdownMenuItem(
                  value: CervicalEffacement.sixtyToSeventy,
                  child: Text('60-70%'),
                ),
                DropdownMenuItem(
                  value: CervicalEffacement.eightyOrMore,
                  child: Text('≥80%'),
                ),
              ],
              onChanged: (value) => formNotifier.setEffacement(value),
            ),
            const SizedBox(height: 24),
            // Fetal Station
            Text(
              'Fetal Station',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '(relative to ischial spines)',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<FetalStation>(
              initialValue: formState.station,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: FetalStation.minusThree,
                  child: Text('-3'),
                ),
                DropdownMenuItem(
                  value: FetalStation.minusTwo,
                  child: Text('-2'),
                ),
                DropdownMenuItem(
                  value: FetalStation.minusOneOrZero,
                  child: Text('-1 or 0'),
                ),
                DropdownMenuItem(
                  value: FetalStation.plusOneOrTwo,
                  child: Text('+1 or +2'),
                ),
              ],
              onChanged: (value) => formNotifier.setStation(value),
            ),
            const SizedBox(height: 24),
            // Cervical Consistency
            Text(
              'Cervical Consistency',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CervicalConsistency>(
              initialValue: formState.consistency,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: CervicalConsistency.firm,
                  child: Text('Firm'),
                ),
                DropdownMenuItem(
                  value: CervicalConsistency.medium,
                  child: Text('Medium'),
                ),
                DropdownMenuItem(
                  value: CervicalConsistency.soft,
                  child: Text('Soft'),
                ),
              ],
              onChanged: (value) => formNotifier.setConsistency(value),
            ),
            const SizedBox(height: 24),
            // Cervical Position
            Text(
              'Cervical Position',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CervicalPosition>(
              initialValue: formState.position,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: CervicalPosition.posterior,
                  child: Text('Posterior'),
                ),
                DropdownMenuItem(
                  value: CervicalPosition.midPosition,
                  child: Text('Mid-position'),
                ),
                DropdownMenuItem(
                  value: CervicalPosition.anterior,
                  child: Text('Anterior'),
                ),
              ],
              onChanged: (value) => formNotifier.setPosition(value),
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
                        'About Bishop Score',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The Bishop score assesses cervical favorability for induction of labor. Score ranges from 0-13, with ≥6 indicating a favorable cervix for successful induction. This tool provides evidence-based management recommendations.',
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
              BishopScoreResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
