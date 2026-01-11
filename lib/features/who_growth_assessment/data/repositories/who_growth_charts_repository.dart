import 'package:chemical_app/features/who_growth_assessment/domain/entities/who_growth_chart.dart';

/// Repository for WHO growth charts data
class WhoGrowthChartsRepository {
  /// Returns all chart categories with their charts
  List<WhoGrowthChartCategory> getCharts() {
    return [
      WhoGrowthChartCategory(
        name: 'weight-for-age',
        displayName: 'Weight-for-Age',
        boysCharts: [
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-age/boys/chart-011.png',
            category: 'weight-for-age',
            gender: 'boys',
            fileName: 'chart-011.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-age/boys/chart-012.png',
            category: 'weight-for-age',
            gender: 'boys',
            fileName: 'chart-012.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-age/boys/chart-013.png',
            category: 'weight-for-age',
            gender: 'boys',
            fileName: 'chart-013.png',
          ),
        ],
        girlsCharts: [
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-age/girls/chart-008.png',
            category: 'weight-for-age',
            gender: 'girls',
            fileName: 'chart-008.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-age/girls/chart-009.png',
            category: 'weight-for-age',
            gender: 'girls',
            fileName: 'chart-009.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-age/girls/chart-010.png',
            category: 'weight-for-age',
            gender: 'girls',
            fileName: 'chart-010.png',
          ),
        ],
      ),
      WhoGrowthChartCategory(
        name: 'height-for-age',
        displayName: 'Height-for-Age',
        boysCharts: [
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/height-for-age/boys/chart-004.png',
            category: 'height-for-age',
            gender: 'boys',
            fileName: 'chart-004.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/height-for-age/boys/chart-005.png',
            category: 'height-for-age',
            gender: 'boys',
            fileName: 'chart-005.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/height-for-age/boys/chart-006.png',
            category: 'height-for-age',
            gender: 'boys',
            fileName: 'chart-006.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/height-for-age/boys/chart-007.png',
            category: 'height-for-age',
            gender: 'boys',
            fileName: 'chart-007.png',
          ),
        ],
        girlsCharts: [
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/height-for-age/girls/chart-000.png',
            category: 'height-for-age',
            gender: 'girls',
            fileName: 'chart-000.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/height-for-age/girls/chart-001.png',
            category: 'height-for-age',
            gender: 'girls',
            fileName: 'chart-001.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/height-for-age/girls/chart-002.png',
            category: 'height-for-age',
            gender: 'girls',
            fileName: 'chart-002.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/height-for-age/girls/chart-003.png',
            category: 'height-for-age',
            gender: 'girls',
            fileName: 'chart-003.png',
          ),
        ],
      ),
      WhoGrowthChartCategory(
        name: 'weight-for-height',
        displayName: 'Weight-for-Height',
        boysCharts: [
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/boys/chart-023.png',
            category: 'weight-for-height',
            gender: 'boys',
            fileName: 'chart-023.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/boys/chart-024.png',
            category: 'weight-for-height',
            gender: 'boys',
            fileName: 'chart-024.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/boys/chart-025.png',
            category: 'weight-for-height',
            gender: 'boys',
            fileName: 'chart-025.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/boys/chart-026.png',
            category: 'weight-for-height',
            gender: 'boys',
            fileName: 'chart-026.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/boys/chart-027.png',
            category: 'weight-for-height',
            gender: 'boys',
            fileName: 'chart-027.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/boys/chart-028.png',
            category: 'weight-for-height',
            gender: 'boys',
            fileName: 'chart-028.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/boys/chart-029.png',
            category: 'weight-for-height',
            gender: 'boys',
            fileName: 'chart-029.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/boys/chart-030.png',
            category: 'weight-for-height',
            gender: 'boys',
            fileName: 'chart-030.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/boys/chart-031.png',
            category: 'weight-for-height',
            gender: 'boys',
            fileName: 'chart-031.png',
          ),
        ],
        girlsCharts: [
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/girls/chart-014.png',
            category: 'weight-for-height',
            gender: 'girls',
            fileName: 'chart-014.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/girls/chart-015.png',
            category: 'weight-for-height',
            gender: 'girls',
            fileName: 'chart-015.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/girls/chart-016.png',
            category: 'weight-for-height',
            gender: 'girls',
            fileName: 'chart-016.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/girls/chart-017.png',
            category: 'weight-for-height',
            gender: 'girls',
            fileName: 'chart-017.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/girls/chart-018.png',
            category: 'weight-for-height',
            gender: 'girls',
            fileName: 'chart-018.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/girls/chart-019.png',
            category: 'weight-for-height',
            gender: 'girls',
            fileName: 'chart-019.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/girls/chart-020.png',
            category: 'weight-for-height',
            gender: 'girls',
            fileName: 'chart-020.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/girls/chart-021.png',
            category: 'weight-for-height',
            gender: 'girls',
            fileName: 'chart-021.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/weight-for-height/girls/chart-022.png',
            category: 'weight-for-height',
            gender: 'girls',
            fileName: 'chart-022.png',
          ),
        ],
      ),
      WhoGrowthChartCategory(
        name: 'muac-for-age',
        displayName: 'MUAC-for-Age',
        boysCharts: [
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/muac-for-age/boys/chart-034.png',
            category: 'muac-for-age',
            gender: 'boys',
            fileName: 'chart-034.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/muac-for-age/boys/chart-035.png',
            category: 'muac-for-age',
            gender: 'boys',
            fileName: 'chart-035.png',
          ),
        ],
        girlsCharts: [
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/muac-for-age/girls/chart-032.png',
            category: 'muac-for-age',
            gender: 'girls',
            fileName: 'chart-032.png',
          ),
          const WhoGrowthChart(
            assetPath: 'assets/images/charts/muac-for-age/girls/chart-033.png',
            category: 'muac-for-age',
            gender: 'girls',
            fileName: 'chart-033.png',
          ),
        ],
      ),
    ];
  }
}
