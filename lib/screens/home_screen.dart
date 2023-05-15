import 'dart:convert';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sumpyo/apis/api.dart';
import 'package:http/http.dart' as http;
import 'package:sumpyo/models/diary.dart';
import 'package:sumpyo/notification.dart';
import 'package:sumpyo/screens/dev_Screen.dart';
import 'package:sumpyo/screens/write_diary_screen.dart';
import 'package:sumpyo/screens/mypage_screen.dart';
import 'package:sumpyo/screens/notice_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat calFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  List<String> ableDiaryDays = [];
  dynamic userInfo = '';
  String userName = '';
  Map<String, Diary> _diarys = {};

  static const storage = FlutterSecureStorage();
  @override
  void initState() {
    FlutterNotification.showNotification();
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
        print(diarys);
        for (var diary in diarys) {
          final instance = Diary.fromJson(diary);
          String diaryDate =
              DateFormat('yyyy-MM-dd').format(instance.diary_date);
          print(instance.diary_content);
          diaryInstance.addAll({diaryDate: instance});
        }
        print(diaryInstance);
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
                details.localPosition.dy > 0
                    ? calFormat = CalendarFormat.month
                    : calFormat = CalendarFormat.week;
              });
            },
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
                  color: Colors.amber,
                ),
                child: diaryContainer(
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

// -----------------------------------하단 바-----------------------------------
const List<TabItem> items = [
  TabItem(icon: Icons.calendar_month_outlined),
  TabItem(icon: Icons.notifications_none_outlined),
  TabItem(icon: Icons.circle),
  TabItem(icon: Icons.bar_chart_rounded),
  TabItem(icon: Icons.supervised_user_circle),
];

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
  String calendarDate;
  final Map<String, Diary> diarys;
  diaryContainer({
    super.key,
    required this.diarys,
    required this.calendarDate,
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
      const diaryAlysisChart()
    ];
    return CardSwiper(
      scale: 1,
      // maxAngle: 360,
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      isHorizontalSwipingEnabled: false,
      cardBuilder: (context, index) => cards[index],
      // direction: CardSwiperDirection.bottom,
      cardsCount: cards.length,
      numberOfCardsDisplayed: 2,
      backCardOffset: const Offset(0, -30),
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
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      padding: EdgeInsets.fromLTRB(
          10,
          MediaQuery.of(context).size.width * 0.035,
          MediaQuery.of(context).size.width * 0.035,
          0),
      child: makeContainer(diarys, calendarDate),
    );
  }
}

class diaryAlysisChart extends StatelessWidget {
  const diaryAlysisChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> items = ['오늘', '어제', '일주일'];
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '2023년 04월 06일',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '오늘의 하루는 "슬픔"이에요.',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SfCartesianChart(
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
                color: const Color(0xFFC8E9F3),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
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
        ],
      ),
    );
  }
}

Widget makeContainer(Map<String, Diary> diarys, String calendarDate) {
  if (diarys.containsKey(calendarDate)) {
    Diary containerDiary = diarys[calendarDate] as Diary;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 일기 일자
        Text(DateFormat('yyyy년 MM월 dd일').format(containerDiary.diary_date)),
        const SizedBox(
          height: 20,
        ),
        // 일기 제목
        Text(containerDiary.diary_title),
        const SizedBox(
          height: 20,
        ),
        // 일기 내용
        Text(containerDiary.diary_content),
      ],
    );
  }
  return Container(
    child: const Text('아직 일기가 없어요.'),
  );
}

class bottomNavi extends StatefulWidget {
  const bottomNavi({super.key});

  @override
  State<bottomNavi> createState() => _bottomNaviState();
}

class _bottomNaviState extends State<bottomNavi> {
  final screens = [
    //이게 하나하나의 화면이되고, Text등을 사용하거나, dart파일에 있는 class를 넣는다.
    const HomeScreen(),
    noticeScreen(),
    const writeDiaryScreen(),
    const devScreen(),
    const myPage(),
  ];
  int visit = 0;
  double height = 30;
  Color bgColor = Colors.white;
  Color color2 = Colors.black;
  @override
  Widget build(BuildContext context) {
    Color colorSelect = Theme.of(context).primaryColor;
    return SizedBox(
      height: 80,
      child: BottomBarCreative(
        backgroundColor: bgColor,
        items: items,
        color: color2,
        colorSelected: colorSelect,
        indexSelected: visit,
        // styleDivider: StyleDivider.bottom,
        isFloating: true,
        highlightStyle: const HighlightStyle(
          elevation: 2,
          sizeLarge: true,
        ),
        onTap: (index) => setState(
          () {
            visit = index;
          },
        ),
      ),
    );
  }
}

// -----------------------------------일기 작성----------------------------------
class writeDiary extends StatefulWidget {
  const writeDiary({super.key});

  @override
  State<writeDiary> createState() => writeDiaryState();
}

class writeDiaryState extends State<writeDiary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height.,
      decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      padding: EdgeInsets.fromLTRB(
          10,
          MediaQuery.of(context).size.width * 0.035,
          MediaQuery.of(context).size.width * 0.035,
          0),
      // EdgeInsets.symmetric(
      //     horizontal: MediaQuery.of(context).size.width * 0.07),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '2023년 04월 06일',
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: '제목: 2023.04.06 일기',
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
            ),
          ),
          SizedBox(
            child: TextFormField(
              minLines: 10,
              maxLines: 15,
              decoration: const InputDecoration(
                hintText: '내용을 입력해주세요.',
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
