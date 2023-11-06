import 'package:AceDeck/components/custom_text.dart';
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

    for (int score in playerScores) {
      cumulativeScore += score;
      cumulativeScores.add(cumulativeScore);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Player Score Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Player Score Chart',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            textcustom(data: "Player : $playerNames", size: 20),
            textcustom(data: "Score : $score", size: 20),
            textcustom(data: "Total Score : $totalScore", size: 20),
            SizedBox(height: 25),
            Container(
              height: 400,
              width: 400,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: Colors.deepPurpleAccent, width: 1),
                  ),
                  minX: 0,
                  maxX: playerScores.length.toDouble() - 1,
                  minY: 0,
                  maxY: cumulativeScores.reduce((a, b) => a > b ? a : b),
                  lineBarsData: [
                    LineChartBarData(
                      spots: cumulativeScores.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.deepPurpleAccent,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
