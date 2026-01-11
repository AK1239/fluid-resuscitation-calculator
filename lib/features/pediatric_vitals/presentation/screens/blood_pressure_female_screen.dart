import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen displaying blood pressure charts for females
class BloodPressureFemaleScreen extends StatelessWidget {
  const BloodPressureFemaleScreen({super.key});

  static const List<String> _imagePaths = [
    'assets/images/vitals/blood-pressure/female/chart-001.png',
    'assets/images/vitals/blood-pressure/female/chart-002.png',
    'assets/images/vitals/blood-pressure/female/chart-003.png',
    'assets/images/vitals/blood-pressure/female/chart-004.png',
    'assets/images/vitals/blood-pressure/female/chart-005.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Pressure - Female'),
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
        height: MediaQuery.of(context).size.height * 0.7,
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
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
