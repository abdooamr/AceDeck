import 'package:AceDeck/components/aurora_background.dart';
import 'package:AceDeck/components/custom_text.dart';
import 'package:AceDeck/components/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompetitiveChart extends StatelessWidget {
  final List<int> playerScores;
  final String playerNames;
  final int totalScore;

  CompetitiveChart(
      {required this.playerScores,
      required this.playerNames,
      required this.totalScore});

  @override
  Widget build(BuildContext context) {
    List<double> cumulativeScores = [];
    final String score = playerScores.join(',');
    double cumulativeScore = 0;

    for (int s in playerScores) {
      cumulativeScore += s;
      cumulativeScores.add(cumulativeScore);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Player Score Chart'),
      ),
      body: AuroraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Player Score Chart',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BlackOpsOne',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                textcustom(data: "Player : $playerNames", size: 18),
                textcustom(data: "Scores : $score", size: 16),
                textcustom(data: "Total : $totalScore", size: 18),
                const SizedBox(height: 20),
                GlassContainer(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: 320,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.white12,
                            strokeWidth: 1,
                          ),
                          getDrawingVerticalLine: (value) => FlLine(
                            color: Colors.white12,
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                              width: 1),
                        ),
                        minX: 0,
                        maxX: playerScores.length.toDouble() - 1,
                        minY: 0,
                        maxY: cumulativeScores.isEmpty
                            ? 1
                            : cumulativeScores.reduce((a, b) => a > b ? a : b),
                        lineBarsData: [
                          LineChartBarData(
                            spots: cumulativeScores.asMap().entries.map((entry) {
                              return FlSpot(
                                  entry.key.toDouble(), entry.value);
                            }).toList(),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, bar, index) =>
                                  FlDotCirclePainter(
                                radius: 4,
                                color: Theme.of(context).colorScheme.primary,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              ),
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
