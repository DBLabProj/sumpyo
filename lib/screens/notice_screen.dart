import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
        tooltipBehavior: TooltipBehavior(),
        primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(
              size: 0,
            )),
        primaryYAxis: NumericAxis(
          labelStyle: const TextStyle(color: Colors.transparent),
          minimum: 0,
          maximum: 50,
          interval: 25,
          axisLine: const AxisLine(color: Colors.transparent),
          majorTickLines: const MajorTickLines(size: 0),
          majorGridLines:
              const MajorGridLines(width: 3, color: Colors.red, dashArray: [4]),
          // isVisible: true,
        ),
        series: <ChartSeries<SalesData, String>>[
          ColumnSeries(
            color: chartBarColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            dataSource: <SalesData>[
              SalesData('기쁨', 35),
              SalesData('분노', 28),
              SalesData('슬픔', 34),
              SalesData('당황', 32),
              SalesData('역겨움', 40)
            ],
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
          )
        ],
      ),
    ));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
