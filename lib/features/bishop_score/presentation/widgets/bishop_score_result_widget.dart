import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/features/bishop_score/domain/entities/bishop_score_result.dart';

class BishopScoreResultWidget extends StatelessWidget {
  final BishopScoreResult result;

  const BishopScoreResultWidget({super.key, required this.result});

  String _getDilationDisplay(CervicalDilation dilation) {
    switch (dilation) {
      case CervicalDilation.zero:
        return '0 cm (0 points)';
      case CervicalDilation.oneToTwo:
        return '1-2 cm (1 point)';
      case CervicalDilation.threeToFour:
        return '3-4 cm (2 points)';
      case CervicalDilation.fiveOrMore:
        return '≥5 cm (3 points)';
    }
  }

  String _getEffacementDisplay(CervicalEffacement effacement) {
    switch (effacement) {
      case CervicalEffacement.zeroToThirty:
        return '0-30% (0 points)';
      case CervicalEffacement.fortyToFifty:
        return '40-50% (1 point)';
      case CervicalEffacement.sixtyToSeventy:
        return '60-70% (2 points)';
      case CervicalEffacement.eightyOrMore:
        return '≥80% (3 points)';
    }
  }

  String _getStationDisplay(FetalStation station) {
    switch (station) {
      case FetalStation.minusThree:
        return '-3 (0 points)';
      case FetalStation.minusTwo:
        return '-2 (1 point)';
      case FetalStation.minusOneOrZero:
        return '-1 or 0 (2 points)';
      case FetalStation.plusOneOrTwo:
        return '+1 or +2 (3 points)';
    }
  }

  String _getConsistencyDisplay(CervicalConsistency consistency) {
    switch (consistency) {
      case CervicalConsistency.firm:
        return 'Firm (0 points)';
      case CervicalConsistency.medium:
        return 'Medium (1 point)';
      case CervicalConsistency.soft:
        return 'Soft (2 points)';
    }
  }

  String _getPositionDisplay(CervicalPosition position) {
    switch (position) {
      case CervicalPosition.posterior:
        return 'Posterior (0 points)';
      case CervicalPosition.midPosition:
        return 'Mid-position (1 point)';
      case CervicalPosition.anterior:
        return 'Anterior (2 points)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = result.isFavourable ? Colors.green : Colors.orange;
    final icon = result.isFavourable
        ? Icons.check_circle_outline
        : Icons.warning_amber_rounded;

    return Column(
      children: [
        ResultCard(
          title: 'Bishop Score Results',
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bishop Score: ${result.totalScore}/13',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            result.isFavourable
                                ? 'Favourable Cervix'
                                : 'Unfavourable Cervix',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ResultRow(
                label: 'Dilation',
                value: _getDilationDisplay(result.dilation),
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Effacement',
                value: _getEffacementDisplay(result.effacement),
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Fetal Station',
                value: _getStationDisplay(result.station),
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Consistency',
                value: _getConsistencyDisplay(result.consistency),
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Position',
                value: _getPositionDisplay(result.position),
                isHighlighted: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Interpretation and Management Guidance
        if (result.isFavourable) ...[
          // Favourable Cervix (Score ≥ 6)
          _buildFavourableCervixGuidance(context),
        ] else ...[
          // Unfavourable Cervix (Score ≤ 6)
          _buildUnfavourableCervixGuidance(context),
        ],
      ],
    );
  }

  Widget _buildUnfavourableCervixGuidance(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Interpretation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Cervix is unfavourable for induction. High likelihood of failed induction without cervical ripening.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionTitle(context, 'Recommended Cervical Ripening Options'),
        const SizedBox(height: 8),
        // Prostaglandin E₂
        _buildProstaglandinE2(context),
        const SizedBox(height: 12),
        // Prostaglandin E₁
        _buildProstaglandinE1(context),
        const SizedBox(height: 12),
        // Mechanical Ripening
        _buildMechanicalRipening(context),
      ],
    );
  }

  Widget _buildFavourableCervixGuidance(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Interpretation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Cervix favourable for induction. High probability of successful vaginal delivery.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionTitle(context, 'Induction Options'),
        const SizedBox(height: 8),
        // Amniotomy
        _buildAmniotomy(context),
        const SizedBox(height: 12),
        // Oxytocin Infusion
        _buildOxytocinInfusion(context),
        const SizedBox(height: 12),
        // Augmentation
        _buildAugmentation(context),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildProstaglandinE2(BuildContext context) {
    return _buildInfoCard(
      context,
      title: 'Prostaglandin E₂ (Dinoprostone)',
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubtitle(context, 'Forms & Dosing:'),
          _buildBulletPoint('3 mg vaginal suppository'),
          _buildBulletPoint('0.5 mg / 2 mL endocervical gel'),
          _buildBulletPoint(
            '3 mg vaginal tablet placed in posterior fornix every 6-12 hours (maximum 2 doses)',
          ),
          const SizedBox(height: 8),
          _buildSubtitle(context, 'Key Safety Notes:'),
          _buildBulletPoint(
            'Avoid oxytocin for at least 8 hours after the last dose',
          ),
          _buildBulletPoint(
            'Contraindications include: Glaucoma, Recent myocardial infarction',
          ),
        ],
      ),
    );
  }

  Widget _buildProstaglandinE1(BuildContext context) {
    return _buildInfoCard(
      context,
      title: 'Prostaglandin E₁ (Misoprostol)',
      color: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubtitle(context, 'Vaginal Regimen:'),
          _buildBulletPoint('25 µg vaginally every 6 hours'),
          _buildBulletPoint('Repeat only if uterine contractions are absent'),
          _buildBulletPoint('Maximum of 4 doses'),
          const SizedBox(height: 8),
          _buildSubtitle(context, 'Oral Regimen:'),
          _buildBulletPoint('25-50 µg orally with water every 2 hours'),
          _buildBulletPoint('Continue until contractions begin'),
          _buildBulletPoint('Maximum of 8 doses'),
          const SizedBox(height: 8),
          _buildSubtitle(context, 'Monitoring & Safety:'),
          _buildBulletPoint(
            'Assess fetal heart rate 30 minutes before each dose',
          ),
          _buildBulletPoint(
            'Avoid oxytocin for at least 6 hours after the last dose',
          ),
        ],
      ),
    );
  }

  Widget _buildMechanicalRipening(BuildContext context) {
    return _buildInfoCard(
      context,
      title: 'Mechanical Cervical Ripening (Balloon Devices)',
      color: Colors.teal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletPoint('Foley catheter (18F)'),
          _buildBulletPoint('Insert past internal cervical os'),
          _buildBulletPoint('Inflate balloon with 30-60 mL saline'),
          _buildBulletPoint('Oxytocin may be used concurrently'),
        ],
      ),
    );
  }

  Widget _buildAmniotomy(BuildContext context) {
    return _buildInfoCard(
      context,
      title: 'Amniotomy',
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubtitle(context, 'Prerequisites:'),
          _buildBulletPoint('Membranes accessible'),
          _buildBulletPoint('Presenting part engaged'),
          const SizedBox(height: 8),
          _buildSubtitle(context, 'Important Precaution:'),
          _buildBulletPoint(
            'Avoid amniotomy in HIV-positive patients unless cervical dilation is ≥6 cm',
          ),
          const SizedBox(height: 8),
          _buildSubtitle(context, 'Next Step:'),
          _buildBulletPoint('Initiate oxytocin infusion following amniotomy'),
        ],
      ),
    );
  }

  Widget _buildOxytocinInfusion(BuildContext context) {
    return _buildInfoCard(
      context,
      title: 'Oxytocin Infusion (IV)',
      color: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubtitle(context, 'Primigravida:'),
          _buildBulletPoint('Start: 5 mIU/min'),
          _buildBulletPoint('Increase by 5 mIU/min every 30 minutes'),
          _buildBulletPoint('Titrate to effective uterine contractions'),
          _buildBulletPoint('Maximum dose: 30 mIU/min'),
          const SizedBox(height: 8),
          _buildSubtitle(context, 'Multipara:'),
          _buildBulletPoint('Start: 2.5 mIU/min'),
          _buildBulletPoint('Increase by 2.5 mIU/min every 30 minutes'),
          _buildBulletPoint('Target: 3-4 contractions per 10 minutes'),
        ],
      ),
    );
  }

  Widget _buildAugmentation(BuildContext context) {
    return _buildInfoCard(
      context,
      title: 'Augmentation of Labor',
      subtitle: '(When Labor Is Established but Inadequate)',
      color: Colors.teal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletPoint('Amniotomy'),
          _buildBulletPoint('Oxytocin infusion (dose titrated as above)'),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required Color color,
    required Widget child,
  }) {
    // Helper to get dark shade for MaterialColor/ColorSwatch, fallback to color itself
    Color getDarkShade(Color c) {
      if (c is ColorSwatch<int>) {
        return c[900] ?? c;
      }
      return c;
    }

    // Helper to get medium shade for MaterialColor/ColorSwatch, fallback to color itself
    Color getMediumShade(Color c) {
      if (c is ColorSwatch<int>) {
        return c[700] ?? c;
      }
      return c;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: getDarkShade(color),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: getMediumShade(color),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
