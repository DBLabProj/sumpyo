import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class noticeScreen extends StatefulWidget {
  const noticeScreen({super.key});

  @override
  State<noticeScreen> createState() => _noticeScreenState();
}

class _noticeScreenState extends State<noticeScreen> {
  // final List<bool> _selectedTerm = <bool>[true, false, false];
  Color chartBarColor = const Color(0xFFC8E9F3);

  Color happyLineColor = const Color(0xFFF3BCD0);
  Color sadnessLineColor = const Color(0xFFA1D6E2);
  Color scaredLineColor = const Color(0xFFD0ACEC);
  Color disgustLineColor = const Color(0xFFABD99B);
  Color angerLineColor = const Color(0xFFEB7575);
  Color embarrassedLineColor = const Color(0xFFFFDE6A);

  bool happyBtnIsPushed = false;
  bool sadnessBtnIsPushed = false;
  bool angerBtnIsPushed = false;
  bool scaredBtnIsPushed = false;
  bool disgustBtnIsPushed = false;
  bool embarrassedBtnIsPushed = false;

  void pushedBtnType(String BtnType) {
    if (BtnType == "행복") {
      setState(() {
        happyBtnIsPushed = !happyBtnIsPushed;
      });
    } else if (BtnType == "슬픔") {
      setState(() {
        sadnessBtnIsPushed = !sadnessBtnIsPushed;
      });
    } else if (BtnType == "공포") {
      setState(() {
        scaredBtnIsPushed = !scaredBtnIsPushed;
      });
    } else if (BtnType == "분노") {
      setState(() {
        angerBtnIsPushed = !angerBtnIsPushed;
      });
    } else if (BtnType == "혐오") {
      setState(() {
        disgustBtnIsPushed = !disgustBtnIsPushed;
      });
    } else {
      setState(() {
        embarrassedBtnIsPushed = !embarrassedBtnIsPushed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // const List<Widget> term = <Widget>[
    //   Text('주간'),
    //   Text('월간'),
    //   Text('연간'),
    // ];

    List<EmotionData> happyData = [
      EmotionData('행복', DateTime.utc(2023, 3, 31), 0),
      EmotionData('행복', DateTime.utc(2023, 4, 1), 2),
      EmotionData('행복', DateTime.utc(2023, 4, 2), 0),
      EmotionData('행복', DateTime.utc(2023, 4, 3), 6),
      EmotionData('행복', DateTime.utc(2023, 4, 4), 4),
      EmotionData('행복', DateTime.utc(2023, 4, 5), 8),
      EmotionData('행복', DateTime.utc(2023, 4, 6), 2),
    ];
    List<EmotionData> SadnessData = [
      EmotionData('슬픔', DateTime.utc(2023, 3, 31), 2),
      EmotionData('슬픔', DateTime.utc(2023, 4, 1), 5),
      EmotionData('슬픔', DateTime.utc(2023, 4, 2), 1),
      EmotionData('슬픔', DateTime.utc(2023, 4, 3), 0),
      EmotionData('슬픔', DateTime.utc(2023, 4, 4), 1),
      EmotionData('슬픔', DateTime.utc(2023, 4, 5), 9),
      EmotionData('슬픔', DateTime.utc(2023, 4, 6), 3),
    ];
    List<EmotionData> angerData = [
      EmotionData('분노', DateTime.utc(2023, 3, 31), 5),
      EmotionData('분노', DateTime.utc(2023, 4, 1), 1),
      EmotionData('분노', DateTime.utc(2023, 4, 2), 0),
      EmotionData('분노', DateTime.utc(2023, 4, 3), 3),
      EmotionData('분노', DateTime.utc(2023, 4, 4), 7),
      EmotionData('분노', DateTime.utc(2023, 4, 5), 2),
      EmotionData('분노', DateTime.utc(2023, 4, 6), 10),
    ];
    List<EmotionData> scaredData = [
      EmotionData('공포', DateTime.utc(2023, 3, 31), 1),
      EmotionData('공포', DateTime.utc(2023, 4, 1), 8),
      EmotionData('공포', DateTime.utc(2023, 4, 2), 0),
      EmotionData('공포', DateTime.utc(2023, 4, 3), 0),
      EmotionData('공포', DateTime.utc(2023, 4, 4), 1),
      EmotionData('공포', DateTime.utc(2023, 4, 5), 5),
      EmotionData('공포', DateTime.utc(2023, 4, 6), 7),
    ];
    List<EmotionData> disgustData = [
      EmotionData('혐오', DateTime.utc(2023, 3, 31), 3),
      EmotionData('혐오', DateTime.utc(2023, 4, 1), 2),
      EmotionData('혐오', DateTime.utc(2023, 4, 2), 7),
      EmotionData('혐오', DateTime.utc(2023, 4, 3), 7),
      EmotionData('혐오', DateTime.utc(2023, 4, 4), 0),
      EmotionData('혐오', DateTime.utc(2023, 4, 5), 9),
      EmotionData('혐오', DateTime.utc(2023, 4, 6), 2),
    ];
    List<EmotionData> embarrassedData = [
      EmotionData('당황', DateTime.utc(2023, 3, 31), 7),
      EmotionData('당황', DateTime.utc(2023, 4, 1), 3),
      EmotionData('당황', DateTime.utc(2023, 4, 2), 5),
      EmotionData('당황', DateTime.utc(2023, 4, 3), 4),
      EmotionData('당황', DateTime.utc(2023, 4, 4), 7),
      EmotionData('당황', DateTime.utc(2023, 4, 5), 3),
      EmotionData('당황', DateTime.utc(2023, 4, 6), 9),
    ];
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: SfCartesianChart(
                tooltipBehavior: TooltipBehavior(),
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    size: 0,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: const TextStyle(color: Colors.transparent),
                  minimum: 0,
                  maximum: 50,
                  interval: 25,
                  axisLine: const AxisLine(color: Colors.transparent),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: const MajorGridLines(
                      width: 3, color: Colors.red, dashArray: [4]),
                  // isVisible: true,
                ),
                series: <ChartSeries<SalesData, String>>[
                  ColumnSeries(
                    color: chartBarColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    dataSource: <SalesData>[
                      SalesData('행복', 35),
                      SalesData('슬픔', 28),
                      SalesData('공포', 34),
                      SalesData('혐오', 32),
                      SalesData('분노', 40),
                      SalesData('당황', 40),
                    ],
                    xValueMapper: (SalesData sales, _) => sales.year,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                  )
                ],
              ),
            ),
            // Container(
            //   child: ToggleButtons(
            //     onPressed: (int index) {
            //       setState(
            //         () {
            //           for (int i = 0; i < _selectedTerm.length; i++) {
            //             _selectedTerm[i] = i == index;
            //           }
            //         },
            //       );
            //     },
            //     borderWidth: 1.5,
            //     disabledBorderColor: Colors.white,
            //     borderColor: Theme.of(context).primaryColor,
            //     borderRadius: const BorderRadius.all(Radius.circular(20)),
            //     selectedBorderColor: Theme.of(context).primaryColor,
            //     selectedColor: Colors.white,
            //     fillColor: Theme.of(context).primaryColor,
            //     color: Theme.of(context).primaryColor,
            //     constraints: const BoxConstraints(
            //       minHeight: 40.0,
            //       minWidth: 80.0,
            //     ),
            //     isSelected: _selectedTerm,
            //     children: term,
            //   ),
            // ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 300,
              width: 400,
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
                  majorTickLines: const MajorTickLines(
                    size: 0,
                  ),
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
                    isVisible: happyBtnIsPushed,
                    dataSource: happyData,
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
                    isVisible: sadnessBtnIsPushed,
                    dataSource: SadnessData,
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
                  LineSeries<EmotionData, DateTime>(
                    isVisible: scaredBtnIsPushed,
                    dataSource: scaredData,
                    color: scaredLineColor,
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
                    isVisible: disgustBtnIsPushed,
                    dataSource: disgustData,
                    color: disgustLineColor,
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
                    isVisible: angerBtnIsPushed,
                    dataSource: angerData,
                    color: angerLineColor,
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
                    isVisible: embarrassedBtnIsPushed,
                    dataSource: embarrassedData,
                    color: embarrassedLineColor,
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
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  emotionBtn(
                    emotion: '행복',
                    changeState: pushedBtnType,
                  ),
                  emotionBtn(
                    emotion: '슬픔',
                    changeState: pushedBtnType,
                  ),
                  emotionBtn(
                    emotion: '공포',
                    changeState: pushedBtnType,
                  ),
                  emotionBtn(
                    emotion: '혐오',
                    changeState: pushedBtnType,
                  ),
                  emotionBtn(
                    emotion: '분노',
                    changeState: pushedBtnType,
                  ),
                  emotionBtn(
                    emotion: '당황',
                    changeState: pushedBtnType,
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

// class termSelector extends StatefulWidget {
//   String term;
//   termSelector({
//     super.key,
//     required this.term,
//   });

//   @override
//   State<termSelector> createState() => _termSelectorState();
// }

// class _termSelectorState extends State<termSelector> {
//   bool isPushed = false;
//   static const List<String> selections = <String>[
//     '주간',
//     '월간',
//     '연간',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: TextButton(
//         onPressed: () {
//           setState(() {
//             isPushed = !isPushed;
//           });
//         },
//         style: isPushed
//             ? TextButton.styleFrom(
//                 padding: const EdgeInsets.all(13),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 backgroundColor: Theme.of(context).primaryColor,
//                 foregroundColor: Colors.white,
//                 textStyle: const TextStyle(
//                   fontSize: 15,
//                   color: Colors.white,
//                 ),
//               )
//             : TextButton.styleFrom(
//                 padding: const EdgeInsets.all(13),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 backgroundColor: Colors.white,
//                 foregroundColor: Theme.of(context).primaryColor,
//                 textStyle: TextStyle(
//                   fontSize: 15,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//         child: Text(widget.term),
//       ),
//     );
//   }
// }

class emotionBtn extends StatefulWidget {
  String emotion;
  Function changeState;

  emotionBtn({
    super.key,
    required this.emotion,
    required this.changeState,
  });

  @override
  State<emotionBtn> createState() => _emotionBtnState();
}

class _emotionBtnState extends State<emotionBtn> {
  bool isPushed = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.changeState(widget.emotion);
        setState(() {
          isPushed = !isPushed;
          // test = !test;
        });
      },
      style: isPushed
          ? TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            )
          : TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              textStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
      child: Text(widget.emotion),
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
