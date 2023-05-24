import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class noticeScreen extends StatelessWidget {
  Color chartBarColor = const Color(0xFFC8E9F3);
  Color happyLineColor = const Color(0xFFF3BCD0);
  Color sadnessLineColor = const Color(0xFFA1D6E2);

  noticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            width: 500,
            child: SfCartesianChart(
              margin: const EdgeInsets.all(30),
              backgroundColor: Theme.of(context).primaryColor,
              plotAreaBackgroundColor: Colors.white,
              primaryXAxis: DateTimeCategoryAxis(
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
                majorTickLines: const MajorTickLines(
                  size: 0,
                ),
                dateFormat: DateFormat('M.d'),
                interval: 1,
                majorGridLines: const MajorGridLines(
                  color: Color.fromRGBO(255, 255, 255, 0),
                ),
              ),
              primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(
                  color: Color.fromRGBO(255, 255, 255, 0),
                ),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                minimum: 0,
                maximum: 10,
                interval: 2,
              ),
              series: <ChartSeries>[
                LineSeries<EmotionData, DateTime>(
                  dataSource: [
                    EmotionData('행복', DateTime.utc(2023, 3, 31), 0),
                    EmotionData('행복', DateTime.utc(2023, 4, 1), 2),
                    EmotionData('행복', DateTime.utc(2023, 4, 2), 0),
                    EmotionData('행복', DateTime.utc(2023, 4, 3), 6),
                    EmotionData('행복', DateTime.utc(2023, 4, 4), 4),
                    EmotionData('행복', DateTime.utc(2023, 4, 5), 8),
                    EmotionData('행복', DateTime.utc(2023, 4, 6), 2),
                  ],
                  color: happyLineColor,
                  xValueMapper: (EmotionData sales, _) => sales.date,
                  yValueMapper: (EmotionData sales, _) => sales.count,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    height: 5,
                    width: 5,
                  ),
                ),
                LineSeries<EmotionData, DateTime>(
                  dataSource: [
                    EmotionData('슬픔', DateTime.utc(2023, 3, 31), 4),
                    EmotionData('슬픔', DateTime.utc(2023, 4, 1), 4),
                    EmotionData('슬픔', DateTime.utc(2023, 4, 2), 8),
                    EmotionData('슬픔', DateTime.utc(2023, 4, 3), 8),
                    EmotionData('슬픔', DateTime.utc(2023, 4, 4), 10),
                    EmotionData('슬픔', DateTime.utc(2023, 4, 5), 4),
                    EmotionData('슬픔', DateTime.utc(2023, 4, 6), 6),
                  ],
                  color: sadnessLineColor,
                  xValueMapper: (EmotionData sales, _) => sales.date,
                  yValueMapper: (EmotionData sales, _) => sales.count,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    height: 5,
                    width: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class EmotionData {
  EmotionData(this.emotion, this.date, this.count);
  final String emotion;
  final DateTime date;
  final double count;
}
