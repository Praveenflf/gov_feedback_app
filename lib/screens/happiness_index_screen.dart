import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/feedback_notifier.dart';
import '../utils/fetchData.dart';

import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

// Hardcoded data for now
final Map<String, int> complaintData = {
  'April': 9,
  'May': 12,
  'June': 15,
};

double ratingAverage = 0.0;

//get value from db
Future<void> getAverageofRating() async {
  double avg = await fetchCurrentMonthAverageRating();
  ratingAverage = avg;
}

class BuildInfoContent extends StatelessWidget {
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        getAverageofRating();
        bool isWide = constraints.maxWidth > 600;
        return isWide
            ? Row(
                children: [
                  Expanded(child: _buildCard(_buildHappinessIndex())),
                  SizedBox(width: 20),
                  Expanded(child: _buildCard(_buildComplaintChart())),
                ],
              )
            : Column(
                children: [
                  _buildCard(_buildHappinessIndex()),
                  _buildCard(_buildComplaintChart()),
                ],
              );
      },
    );
  }
}

Widget _buildCard(Widget child) {
  return Card(
    elevation: 3,
    child: Padding(padding: const EdgeInsets.all(16.0), child: child),
  );
}

Widget _buildHappinessIndex() {
  double angle = (ratingAverage / 5) * pi; // 0 to π radians (half circle)

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Happiness Index',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 16),
      SizedBox(
        height: 200,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(200, 100),
              painter: _HalfCirclePainter(ratingAverage / 5),
            ),
            Positioned(
              bottom: 0,
              child: Transform.rotate(
                angle: angle - pi / 2,
                child: Icon(Icons.arrow_upward_rounded,
                    size: 120, color: Color.fromARGB(255, 93, 40, 239)),
              ),
            ),
            Positioned(
              left: 35,
              bottom: 0,
              child: Text('☹️', style: TextStyle(fontSize: 25)),
            ),
            Positioned(
              right: 35,
              bottom: 0,
              child: Text('😊', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
      SizedBox(height: 30),
      Text(
        '${ratingAverage.toStringAsFixed(1)} / 5.0',
        style: TextStyle(fontSize: 16),
      ),
    ],
  );
}

Widget _buildComplaintChart() {
  List<BarChartGroupData> barGroups = [];
  int x = 0;
  complaintData.forEach((month, value) {
    barGroups.add(
      BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
              toY: value.toDouble(),
              color: Color.fromARGB(255, 93, 40, 239),
              width: 15),
        ],
      ),
    );
    x++;
  });

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Graph of Complaints',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 26),
      SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    List<String> months = complaintData.keys.toList();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(months[value.toInt()]),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize:
                      32, // Increase reserved space for Y-axis numbers
                  getTitlesWidget: (value, _) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12),
                    );
                  },
                ),
              ),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: false),
            barGroups: barGroups,
          ),
        ),
      ),
    ],
  );
}

// Custom painter for half-circle progress
class _HalfCirclePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  _HalfCirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = Color.fromARGB(255, 93, 40, 239)
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    // Draw background half-circle
    canvas.drawArc(rect, pi, pi, false, backgroundPaint);

    // Draw progress half-circle
    canvas.drawArc(rect, pi, pi * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
