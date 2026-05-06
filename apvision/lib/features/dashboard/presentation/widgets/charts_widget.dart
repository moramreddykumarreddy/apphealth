import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/utils/responsive.dart';

class ChartsWidget extends StatelessWidget {
  const ChartsWidget({Key? key}) : super(key: key);

  static const Color _primaryColor = Color(0xFF173F45);
  static const Color _secondaryColor = Color(0xFFFFB300);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Column(
        children: [
          _buildBarChart(context),
          const SizedBox(height: 16),
          _buildPieChart(context),
        ],
      ),
      tablet: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildBarChart(context)),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: _buildPieChart(context)),
        ],
      ),
      desktop: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildBarChart(context)),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: _buildPieChart(context)),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Screenings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 280,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 200,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          final idx = value.toInt();
                          final text = idx >= 0 && idx < labels.length
                              ? Text(labels[idx], style: style)
                              : const Text('', style: style);
                          return SideTitleWidget(meta: meta, child: text);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 150, color: _primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 120, color: _primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 180, color: _primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 140, color: _primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 190, color: _primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 80, color: _secondaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 50, color: _secondaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnosis Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 65,
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: 40,
                          title: 'Cataract\n40%',
                          radius: 45,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.green,
                          value: 30,
                          title: 'Refractive\n30%',
                          radius: 45,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.orange,
                          value: 15,
                          title: 'Glaucoma\n15%',
                          radius: 45,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.purple,
                          value: 15,
                          title: 'Other\n15%',
                          radius: 45,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Total\n12.4k',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
