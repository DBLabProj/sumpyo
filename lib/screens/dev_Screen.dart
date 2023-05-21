import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final double y;
  final double y1;
}

class devScreen extends StatefulWidget {
  const devScreen({super.key});

  @override
  State<devScreen> createState() => _devScreenState();
}

class _devScreenState extends State<devScreen> {
  late SelectionBehavior _selectionBehavior;

  @override
  void initState() {
    _selectionBehavior = SelectionBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('USA', 6, 8),
      ChartData('China', 11, 7),
      ChartData('UK', 9, 10),
      ChartData('Japan', 14, 8),
      ChartData('France', 10, 12),
    ];
    return Scaffold(
        body: SfCartesianChart(
      // Mode of selection
      selectionType: SelectionType.cluster,
      series: <ChartSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
          dataSource: <ChartData>[
            ChartData('USA', 6, 8),
            ChartData('China', 11, 7),
            ChartData('UK', 9, 10),
            ChartData('Japan', 14, 8),
            ChartData('France', 10, 12),
          ],
          selectionBehavior: _selectionBehavior,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        ),
        ColumnSeries<ChartData, String>(
            dataSource: chartData,
            selectionBehavior: _selectionBehavior,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y1)
      ],
    ));
  }
}
