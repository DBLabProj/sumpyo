import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/diary.dart';

class noticeScreen extends StatelessWidget {
  Color chartBarColor = const Color(0xFFC8E9F3);
  noticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      height: 300,
      width: 300,
      child: SfCartesianChart(
        // 차트 테두리 두께
        plotAreaBorderWidth: 0,
        tooltipBehavior: TooltipBehavior(),
        primaryXAxis: CategoryAxis(
            multiLevelLabels: List.empty(),
            axisLine: const AxisLine(width: 1, color: Colors.transparent),
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(
              size: 0,
            )),
        primaryYAxis: NumericAxis(
          // 라벨 스타일
          labelStyle: const TextStyle(color: Colors.transparent),
          // 최소/최대/간격
          minimum: 0,
          maximum: 50,
          interval: 25,
          // 축선
          axisLine: const AxisLine(color: Colors.transparent),
          // 라벨 표시선
          majorTickLines: const MajorTickLines(size: 0),
          // 간격선
          majorGridLines: MajorGridLines(
              width: 2,
              color: Colors.grey.withOpacity(0.5),
              dashArray: const [4]),
        ),
        series: <ChartSeries<emotionData, String>>[
          ColumnSeries(
            color: chartBarColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            dataSource: <emotionData>[
              emotionData('기쁨', 35),
              emotionData('분노', 28),
              emotionData('슬픔', 34),
              emotionData('당황', 32),
              emotionData('역겨움', 40)
            ],
            xValueMapper: (emotionData sales, _) => sales.labledEmotion,
            yValueMapper: (emotionData sales, _) => sales.frequency,
          )
        ],
      ),
    ));
  }
}
