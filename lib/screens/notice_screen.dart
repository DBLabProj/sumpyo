import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:sumpyo/screens/home_screen.dart';
import 'package:sumpyo/models/user.dart';
import 'package:sumpyo/apis/api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class noticeScreen extends StatefulWidget {
  const noticeScreen({super.key});

  @override
  State<noticeScreen> createState() => _noticeScreenState();
}

class _noticeScreenState extends State<noticeScreen> {
  List<String> formatValues = ['일주일', '월간', '연간'];
  String userName = '';
  DateTime now = DateTime.now();
  List<int> happinessData = [];
  List<int> angerData = [];
  List<int> disgustData = [];
  List<int> embarrassmentData = [];
  List<int> sadnessData = [];

  static const storage = FlutterSecureStorage();
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
  int selectIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadAccount();
      loadEmotion();
    });
  }

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

  changeIndex(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  loadEmotion() async {
    sendUser userId = sendUser(userName);
    var res = await http.post(Uri.parse(RestAPI.getAnalysis),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userId.toJson()));
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      happinessData = (data["happiness"] as List).map((e) => e as int).toList();
      sadnessData = (data["sadness"] as List).map((e) => e as int).toList();
      angerData = (data["anger"] as List).map((e) => e as int).toList();
      disgustData = (data["disgust"] as List).map((e) => e as int).toList();
      embarrassmentData =
          (data["embarrassment"] as List).map((e) => e as int).toList();
    }
  }

  loadAccount() async {
    var acc = await storage.read(key: 'login');
    if (acc != null) {
      var user = jsonDecode(acc);
      userName = user['user_id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      loadEmotion();
    });

    List<EmotionData> happyData = [];
    List<EmotionData> sadData = [];
    List<EmotionData> angryData = [];
    List<EmotionData> disgustedData = [];
    List<EmotionData> embarrassData = [];
    List<EmotionData> stressData = [];

    for (int i = 0; i < happinessData.length; i++) {
      happyData.add(EmotionData(
          "행복",
          now.add(Duration(days: (i - happinessData.length + 1))),
          happinessData[i].toDouble()));
    }
    for (int i = 0; i < sadnessData.length; i++) {
      sadData.add(EmotionData(
          "슬픔",
          now.add(Duration(days: (i - sadnessData.length + 1))),
          sadnessData[i].toDouble()));
    }
    for (int i = 0; i < angerData.length; i++) {
      angryData.add(EmotionData(
          "분노",
          now.add(Duration(days: (i - angerData.length + 1))),
          angerData[i].toDouble()));
    }
    for (int i = 0; i < disgustData.length; i++) {
      disgustedData.add(EmotionData(
          "혐오",
          now.add(Duration(days: (i - disgustData.length + 1))),
          disgustData[i].toDouble()));
    }
    for (int i = 0; i < embarrassmentData.length; i++) {
      embarrassData.add(EmotionData(
          "당황",
          now.add(Duration(days: (i - embarrassmentData.length + 1))),
          embarrassmentData[i].toDouble()));
    }
    for (int i = 0; i < angryData.length; i++) {
      stressData.add(EmotionData(
          "stress",
          now.add(Duration(days: (i - angryData.length + 1))),
          embarrassmentData[i].toDouble()));
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '요즘 감정 상태예요!!',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '·기분 추이 그래프',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        formatSelector(
                          changeIndex: changeIndex,
                          formatValues: formatValues,
                        ),
                        const SizedBox(
                          height: 20,
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
                              maximum: 25,
                              interval: 2,
                            ),
                            series: <ChartSeries>[
                              LineSeries<EmotionData, DateTime>(
                                isVisible: happyBtnIsPushed,
                                dataSource: happyData,
                                color: happyLineColor,
                                xValueMapper: (EmotionData sales, _) =>
                                    sales.date,
                                yValueMapper: (EmotionData sales, _) =>
                                    sales.count,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  height: 5,
                                  width: 5,
                                ),
                              ),
                              LineSeries<EmotionData, DateTime>(
                                isVisible: sadnessBtnIsPushed,
                                dataSource: sadData,
                                color: sadnessLineColor,
                                xValueMapper: (EmotionData sales, _) =>
                                    sales.date,
                                yValueMapper: (EmotionData sales, _) =>
                                    sales.count,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  height: 5,
                                  width: 5,
                                ),
                              ),
                              LineSeries<EmotionData, DateTime>(
                                isVisible: disgustBtnIsPushed,
                                dataSource: disgustedData,
                                color: disgustLineColor,
                                xValueMapper: (EmotionData sales, _) =>
                                    sales.date,
                                yValueMapper: (EmotionData sales, _) =>
                                    sales.count,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  height: 5,
                                  width: 5,
                                ),
                              ),
                              LineSeries<EmotionData, DateTime>(
                                isVisible: angerBtnIsPushed,
                                dataSource: angryData,
                                color: angerLineColor,
                                xValueMapper: (EmotionData sales, _) =>
                                    sales.date,
                                yValueMapper: (EmotionData sales, _) =>
                                    sales.count,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  height: 5,
                                  width: 5,
                                ),
                              ),
                              LineSeries<EmotionData, DateTime>(
                                isVisible: embarrassedBtnIsPushed,
                                dataSource: embarrassData,
                                color: embarrassedLineColor,
                                xValueMapper: (EmotionData sales, _) =>
                                    sales.date,
                                yValueMapper: (EmotionData sales, _) =>
                                    sales.count,
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
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
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
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '·스트레스 추이 그래프\n',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        stressGraph(
                          stressData: stressData,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class stressGraph extends StatelessWidget {
  List<EmotionData> stressData;
  stressGraph({
    super.key,
    required this.stressData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          maximum: 20,
          interval: 2,
        ),
        series: <ChartSeries>[
          LineSeries<EmotionData, DateTime>(
            // isVisible: happyBtnIsPushed,
            dataSource: stressData,
            // color: happyLineColor,
            xValueMapper: (EmotionData emotion, _) => emotion.date,
            yValueMapper: (EmotionData emotion, _) => emotion.count,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              height: 5,
              width: 5,
            ),
          ),
        ],
      ),
    );
  }
}

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

class EmotionData {
  EmotionData(this.emotion, this.date, this.count);
  final String emotion;
  final DateTime date;
  final double count;
}
