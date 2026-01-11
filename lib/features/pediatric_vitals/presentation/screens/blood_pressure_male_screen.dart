import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen displaying blood pressure charts for males
class BloodPressureMaleScreen extends StatelessWidget {
  const BloodPressureMaleScreen({super.key});

  static const List<String> _imagePaths = [
    'assets/images/vitals/blood-pressure/male/chart-006.png',
    'assets/images/vitals/blood-pressure/male/chart-007.png',
    'assets/images/vitals/blood-pressure/male/chart-008.png',
    'assets/images/vitals/blood-pressure/male/chart-009.png',
    'assets/images/vitals/blood-pressure/male/chart-010.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Pressure - Male'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pediatric-vitals/blood-pressure'),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _imagePaths.length,
          itemBuilder: (context, index) {
            return _buildChartImage(context, _imagePaths[index]);
          },
        ),
      ),
    );
  }

  Widget _buildChartImage(BuildContext context, String imagePath) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading blood pressure chart: $imagePath');
              debugPrint('Error: $error');
              return Container(
                height: 200,
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.grey[400],
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unable to load chart',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
