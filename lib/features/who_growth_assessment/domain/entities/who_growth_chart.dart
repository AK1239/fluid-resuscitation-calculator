/// Represents a single WHO growth chart image
class WhoGrowthChart {
  final String assetPath;
  final String category;
  final String gender; // 'boys' or 'girls'
  final String fileName;

  const WhoGrowthChart({
    required this.assetPath,
    required this.category,
    required this.gender,
    required this.fileName,
  });
}

/// Represents a chart category with its charts
class WhoGrowthChartCategory {
  final String name;
  final String displayName;
  final List<WhoGrowthChart> boysCharts;
  final List<WhoGrowthChart> girlsCharts;

  const WhoGrowthChartCategory({
    required this.name,
    required this.displayName,
    required this.boysCharts,
    required this.girlsCharts,
  });

  int get totalCharts => boysCharts.length + girlsCharts.length;
}
