import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sumpyo/apis/api.dart';
import 'package:http/http.dart' as http;
import 'package:sumpyo/models/diary.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/src/slider_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat calFormat = CalendarFormat.month;
  bool isExpanded = false;
  DateTime _selectedDate = DateTime.now();
  List<String> ableDiaryDays = [];
  dynamic userInfo = '';
  String userName = '';
  Map<String, Diary> _diarys = {};

  static const storage = FlutterSecureStorage();
  @override
  void initState() {
    // FlutterNotification.showNotification();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _asyncMethod();
      _diarys = await getDiary({'userId': userName});
      setState(() {
        ableDiaryDays = _diarys.keys.toList();
      });
    });
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: 'login');
    if (userInfo != null) {
      var user = jsonDecode(userInfo);
      userName = user['user_id'];
    } else {
      print('로그인이 필요합니다');
    }
  }

  static Future<Map<String, Diary>> getDiary(
      Map<String, String> userNameInfo) async {
    Map<String, Diary> diaryInstance = {};
    var res = await http.post(Uri.parse(RestAPI.getDiary),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userNameInfo));
    if (res.statusCode == 200) {
      var resDiary = jsonDecode(utf8.decode(res.bodyBytes));
      if (resDiary['result'] == 'Success') {
        Fluttertoast.showToast(msg: '성공적으로 불러왔습니다.');
        final List<dynamic> diarys = resDiary['diarys'];
        for (var diary in diarys) {
          final instance = Diary.fromJson(diary);
          String diaryDate =
              DateFormat('yyyy-MM-dd').format(instance.diary_date);
          diaryInstance.addAll({diaryDate: instance});
        }
        return diaryInstance;
      } else {
        Fluttertoast.showToast(msg: '불러오는중 오류가 발생했습니다.');
        return diaryInstance;
      }
    }
    return diaryInstance;
  }

  changeDate(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: topAppBar(
        appBar: AppBar(),
      ),
      body: SafeArea(
          child: Column(
        children: [
          mainCalendar(
            changeDate: changeDate,
            ableDays: ableDiaryDays,
            calendarFormat: calFormat,
          ),
          GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                if (details.localPosition.dy > 0) {
                  calFormat = CalendarFormat.month;
                  isExpanded = true;
                } else {
                  calFormat = CalendarFormat.week;
                  isExpanded = false;
                }
              });
            },
            // 당기기? 바
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 50,
                  height: 10,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade400,
                    ),
                    child: const Text('  '),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                  color: Colors.transparent,
                ),
                child: diaryContainer(
                  isExpanded: isExpanded,
                  calendarDate: DateFormat("yyyy-MM-dd").format(_selectedDate),
                  diarys: _diarys,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

// -----------------------------------상단 바------------------------------------
class topAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  const topAppBar({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              size: 40,
            ),
            color: Colors.white,
            onPressed: () {},
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.account_circle_rounded,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

// -----------------------------------달력--------------------------------------
class mainCalendar extends StatefulWidget {
  CalendarFormat calendarFormat;
  List<String> ableDays;
  Function changeDate;
  mainCalendar({
    super.key,
    required this.calendarFormat,
    required this.ableDays,
    required this.changeDate,
  });

  @override
  State<mainCalendar> createState() => _mainCalendarState();
}

class _mainCalendarState extends State<mainCalendar> {
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko',
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2050, 12, 31),
      calendarFormat: widget.calendarFormat,
      eventLoader: (day) {
        if (widget.ableDays.contains(DateFormat("yyyy-MM-dd").format(day))) {
          return ['다이어리가 있어요.'];
        }
        return [];
      },
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      headerStyle: HeaderStyle(
        headerPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.03,
            horizontal: MediaQuery.of(context).size.width * 0.05),
        leftChevronVisible: false,
        rightChevronVisible: false,
        formatButtonVisible: false,
      ),
      calendarStyle: CalendarStyle(
        markersMaxCount: 1,
        markerDecoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        todayDecoration: const BoxDecoration(
          color: Color(0xff5A6E90),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color(0xFFB9E1EC), width: 3),
          shape: BoxShape.circle,
        ),
        defaultTextStyle: const TextStyle(color: Colors.white),
        weekendTextStyle: const TextStyle(color: Colors.white),
        outsideTextStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          widget.calendarFormat = CalendarFormat.week;
          this.selectedDay = selectedDay;
          this.focusedDay = focusedDay;
          widget.changeDate(selectedDay);
        });
      },
    );
  }
}

// -----------------------------------일기 화면----------------------------------
class diaryContainer extends StatefulWidget {
  bool isExpanded;
  String calendarDate;
  final Map<String, Diary> diarys;
  diaryContainer({
    super.key,
    required this.diarys,
    required this.calendarDate,
    required this.isExpanded,
  });

  @override
  State<diaryContainer> createState() => _diaryContainerState();
}

class _diaryContainerState extends State<diaryContainer> {
  CardSwiperController swiperController = CardSwiperController();
  late List<Widget> cards;
  @override
  void initState() {
    super.initState();
  }

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    debugPrint('The card $previousIndex was swiped to the ${direction.name}.');
    return true;
  }

  bool _onUndo(
      int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    debugPrint('The card $currentIndex was swiped to the ${direction.name}.');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    cards = [
      diaryPanel(diarys: widget.diarys, calendarDate: widget.calendarDate),
      diaryAlysisChart(
        isExpanded: widget.isExpanded,
        diarys: widget.diarys,
        selectedDate: widget.calendarDate,
      )
    ];
    return CardSwiper(
      scale: 1,
      maxAngle: 180,
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      isHorizontalSwipingEnabled: false,
      cardBuilder: (context, index) => Container(child: cards[index]),
      // direction: CardSwiperDirection.bottom,
      cardsCount: cards.length,
      numberOfCardsDisplayed: 2,
      backCardOffset: const Offset(0, -40),
      onSwipe: _onSwipe,
      onUndo: _onUndo,
    );
  }
}

class diaryPanel extends StatelessWidget {
  diaryPanel({
    super.key,
    required this.diarys,
    required this.calendarDate,
  });

  Map<String, Diary> diarys;
  String calendarDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height.,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(-4.0, -4.0),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      padding: EdgeInsets.fromLTRB(
          10,
          MediaQuery.of(context).size.width * 0.035,
          MediaQuery.of(context).size.width * 0.035,
          0),
      child: makeContainer(diarys[calendarDate]),
    );
  }
}

class diaryAlysisChart extends StatefulWidget {
  bool isExpanded;
  Map<String, Diary> diarys;
  String selectedDate;
  diaryAlysisChart({
    super.key,
    required this.isExpanded,
    required this.diarys,
    required this.selectedDate,
  });

  @override
  State<diaryAlysisChart> createState() => _diaryAlysisChartState();
}

class _diaryAlysisChartState extends State<diaryAlysisChart> {
  List<String> formatValues = ['오늘', '어제', '그제'];
  late List<emotionData> todayData;
  late List<emotionData> yesterdayData;
  late List<emotionData> beforeYesterdayData;

  Diary todayDiary = Diary(0, '', '', '', DateTime.now(), '', 0, 0, 0, 0, 0);
  String yesterdayDate = '';
  String beforeYesterdayDate = '';
  late SelectionBehavior _toDaySelection;
  late SelectionBehavior _yesterDaySelection;
  late SelectionBehavior _beforeYesterDaySelection;
  int isSelected = 0;

  @override
  void initState() {
    var tempDate = DateFormat('yyyy-MM-dd').parse(widget.selectedDate);
    yesterdayDate =
        DateFormat('yyyy-MM-dd').format(tempDate.add(const Duration(days: -1)));
    beforeYesterdayDate =
        DateFormat('yyyy-MM-dd').format(tempDate.add(const Duration(days: -2)));
    _toDaySelection = selectionBehaviorInit();
    _yesterDaySelection = selectionBehaviorInit();
    _beforeYesterDaySelection = selectionBehaviorInit();
    todayData = dailyDateInit();
    yesterdayData = dailyDateInit();
    beforeYesterdayData = dailyDateInit();
    super.initState();
  }

  changeSelected(int index) {
    setState(() {
      isSelected = index;
      var tempDate = DateFormat('yyyy-MM-dd').parse(widget.selectedDate);
      yesterdayDate = DateFormat('yyyy-MM-dd')
          .format(tempDate.add(const Duration(days: -1)));
      beforeYesterdayDate = DateFormat('yyyy-MM-dd')
          .format(tempDate.add(const Duration(days: -2)));
    });
  }

  List<emotionData> dailyDateInit() {
    return [
      emotionData('기쁨', 0),
      emotionData('분노', 0),
      emotionData('슬픔', 0),
      emotionData('당황', 0),
      emotionData('역겨움', 0)
    ];
  }

  SelectionBehavior selectionBehaviorInit() {
    return SelectionBehavior(
      enable: true,
      toggleSelection: true,
      unselectedOpacity: 0.3,
      selectionController: RangeController(start: 0, end: 4),
    );
  }

  List<emotionData> getEmotionData(Diary targetDiary) {
    return [
      emotionData('기쁨', targetDiary.diary_happiness.toDouble()),
      emotionData('분노', targetDiary.diary_anger.toDouble()),
      emotionData('슬픔', targetDiary.diary_sadness.toDouble()),
      emotionData('당황', targetDiary.diary_embarrassment.toDouble()),
      emotionData('역겨움', targetDiary.diary_disgust.toDouble())
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.diarys.containsKey(widget.selectedDate)) {
      todayDiary = widget.diarys[widget.selectedDate] as Diary;
      todayData = getEmotionData(todayDiary);
    }
    if (widget.diarys.containsKey(yesterdayDate)) {
      Diary yesterdayDiary = widget.diarys[yesterdayDate] as Diary;
      yesterdayData = getEmotionData(yesterdayDiary);
    }
    if (widget.diarys.containsKey(beforeYesterdayDate)) {
      Diary beforeYesterdayDiary = widget.diarys[beforeYesterdayDate] as Diary;
      beforeYesterdayData = getEmotionData(beforeYesterdayDiary);
    }
    var todayColumn =
        makeColumn(_toDaySelection, const Color(0xFFC8E9F3), todayData);
    var yesterDayColumn =
        makeColumn(_yesterDaySelection, const Color(0xFFF6D7E2), yesterdayData);
    var beforeYesterDayColumn = makeColumn(_beforeYesterDaySelection,
        const Color.fromARGB(255, 37, 221, 141), beforeYesterdayData);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(-4.0, -4.0),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: SingleChildScrollView(
        physics: widget.isExpanded
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('yyyy년 MM월 dd일').format(
                        DateFormat('yyyy-MM-dd').parse(widget.selectedDate)),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "오늘의 하루는 '",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    todayDiary.diary_emotion,
                    style: const TextStyle(color: Colors.blue),
                  ),
                  const Text(
                    "'이에요.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: const Text(
                          '오늘의 감정 분표',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff4c4c4c)),
                        ),
                      ),
                    ],
                  ),
                  SfCartesianChart(
                    // 차트 테두리 두께
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                        interactiveTooltip: const InteractiveTooltip(),
                        multiLevelLabels: List.empty(),
                        axisLine: const AxisLine(width: 0, color: Colors.black),
                        majorGridLines: const MajorGridLines(width: 0),
                        majorTickLines: const MajorTickLines(
                          size: 0,
                        )),
                    primaryYAxis: NumericAxis(
                      rangePadding: ChartRangePadding.none,
                      // 라벨 스타일
                      labelStyle: const TextStyle(
                          color: Colors.transparent, fontSize: 0),
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
                    axes: [
                      CategoryAxis(
                        name: 'x_second',
                        opposedPosition: true,
                        majorTickLines: const MajorTickLines(size: 0),
                        labelStyle: const TextStyle(
                            color: Colors.transparent, fontSize: 0),
                        axisLine:
                            const AxisLine(color: Color(0xFFE4E4E4), width: 2),
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      NumericAxis(
                        name: 'y_second',
                        opposedPosition: true,
                        minimum: 0,
                        maximum: 50,
                        interval: 50,
                        axisLine: const AxisLine(color: Colors.transparent),
                        majorTickLines: const MajorTickLines(size: 0),
                        labelStyle: const TextStyle(
                            color: Colors.transparent, fontSize: 0),
                      ),
                    ],
                    series: <ChartSeries<emotionData, String>>[
                      // 오늘
                      todayColumn,
                      if (isSelected == 1)
                        yesterDayColumn
                      else if (isSelected == 2)
                        beforeYesterDayColumn
                    ],
                  ),
                ],
              ),
            ),
            formatSelector(
              changeIndex: changeSelected,
              formatValues: formatValues,
            ),
          ],
        ),
      ),
    );
  }

  ColumnSeries<emotionData, String> makeColumn(
      SelectionBehavior selection, Color graphColor, List<emotionData> data) {
    return ColumnSeries(
      selectionBehavior: selection,
      color: graphColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      dataSource: data,
      xValueMapper: (emotionData eData, _) => eData.labledEmotion,
      yValueMapper: (emotionData eData, _) => eData.frequency,
    );
  }
}

class formatSelector extends StatefulWidget {
  Function changeIndex;
  List<String> formatValues;
  formatSelector({
    required this.changeIndex,
    required this.formatValues,
    super.key,
  });

  @override
  State<formatSelector> createState() => _formatSelectorState();
}

class _formatSelectorState extends State<formatSelector> {
  ButtonStyle unselectedButton = const ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.white),
    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)))),
  );
  ButtonStyle selectedButton = const ButtonStyle();
  List<bool> selected = [true, false, false];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        selectedButton = ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(Theme.of(context).primaryColor),
          shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)))),
        );
      });
    });
  }

  changeSelected(int index) {
    for (int i = 0; i < selected.length; i++) {
      selected[i] = i == index ? true : false;
    }
    widget.changeIndex(index);
    setState(() {
      selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle selectedText = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);
    TextStyle unselectedText = TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 15);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.78,
      height: MediaQuery.of(context).size.height * 0.04,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 1,
              child: TextButton(
                style: selected[0] ? selectedButton : unselectedButton,
                onPressed: () {
                  changeSelected(0);
                },
                child: Text(
                  widget.formatValues[0],
                  style: selected[0] ? selectedText : unselectedText,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextButton(
                style: selected[1] ? selectedButton : unselectedButton,
                onPressed: () {
                  changeSelected(1);
                },
                child: Text(
                  widget.formatValues[1],
                  style: selected[1] ? selectedText : unselectedText,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextButton(
                style: selected[2] ? selectedButton : unselectedButton,
                onPressed: () {
                  changeSelected(2);
                  setState(() {});
                },
                child: Text(
                  widget.formatValues[2],
                  style: selected[2] ? selectedText : unselectedText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget makeContainer(Diary? diary) {
  if (diary != null) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 일기 일자
        Text(DateFormat('yyyy년 MM월 dd일').format(diary.diary_date)),
        const SizedBox(
          height: 20,
        ),
        // 일기 제목
        Text(diary.diary_title),
        const SizedBox(
          height: 20,
        ),
        // 일기 내용
        Text(diary.diary_content),
      ],
    );
  } else {
    return Container(
      child: const Text('아직 일기가 없어요.'),
    );
  }
}
