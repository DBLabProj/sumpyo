import 'dart:convert';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:sumpyo/apis/api.dart';
import 'package:http/http.dart' as http;
import 'package:sumpyo/models/diary.dart';
import 'package:sumpyo/screens/write_diary_screen.dart';
import 'package:sumpyo/screens/mypage_screen.dart';
import 'package:sumpyo/screens/notice_screen.dart';
import 'package:sumpyo/screens/statistics_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool firstWeek = false;
  bool firstMonth = false;
  double contentHeight = 0.0;
  double monthHeight = 0.0;
  double weekHeight = 0.0;
  double minHeight = 50.0;
  double maxHeight = 500.0;
  double topbarHeight = 0.0;
  CalendarFormat calFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  final GlobalKey _mainCalKey = GlobalKey();
  final GlobalKey contentKey = GlobalKey();
  final Future<Map<String, Diary>> _diarys = getDiary();
  List<String> ableDiaryDays = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      monthHeight = getCalSize();
      contentHeight = getContentSize();
      // _diarys = getDiary();
      setState(() {
        minHeight = contentHeight - monthHeight - topbarHeight - 80;
        print(
          '컨텐츠높이:$contentHeight, 월간달력:$monthHeight, 최소높이:$minHeight',
        );
        _diarys.then((value) => setState(() {
              ableDiaryDays = value.keys.toList();
            }));
      });
    });
  }

  static Future<Map<String, Diary>> getDiary() async {
    Map<String, Diary> diaryInstance = {};
    var res = await http.post(Uri.parse(RestAPI.getDiary),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": "whdduq2302"}));
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

  double getCalSize() {
    RenderBox calBox =
        _mainCalKey.currentContext!.findRenderObject() as RenderBox;
    Size size = calBox.size;
    return size.height;
  }

  double getContentSize() {
    RenderBox calBox =
        contentKey.currentContext!.findRenderObject() as RenderBox;
    Size size = calBox.size;
    return size.height;
  }

  @override
  Widget build(BuildContext context) {
    // // print(ableDiaryDays);
    topbarHeight = MediaQuery.of(context).size.height * 0.15;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: topAppBar(
        appBar: AppBar(),
      ),
      body: SafeArea(
        //--------------------------------슬라이딩 패널--------------------------
        child: SlidingUpPanel(
          onPanelOpened: () {
            setState(() {
              calFormat = CalendarFormat.week;
            });

            if (!firstMonth) {
              firstMonth = !firstMonth;
              Future.delayed(const Duration(milliseconds: 500), () {
                weekHeight = getCalSize();
                setState(() {
                  maxHeight = contentHeight - weekHeight - topbarHeight - 80;
                });
              });
            }
          },
          onPanelClosed: () {
            setState(() {
              calFormat = CalendarFormat.month;
            });
          },
          minHeight: minHeight,
          maxHeight: maxHeight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          color: Colors.white,
          panelBuilder: () {
            return diaryContainer(
              calendarDate: DateFormat("yyyy-MM-dd").format(_selectedDate),
              diarys: _diarys,
            );
          },
          //-------------------------------바디 영역----------------------------
          body: Column(
            key: contentKey,
            children: [
              mainCalendar(
                changeDate: changeDate,
                ableDays: ableDiaryDays,
                calendarFormat: calFormat,
                mainCalKey: _mainCalKey,
              ),
            ],
          ),
        ),
      ),
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
  GlobalKey mainCalKey;
  Function changeDate;
  mainCalendar({
    super.key,
    required this.calendarFormat,
    required this.mainCalKey,
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
      key: widget.mainCalKey,
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
          // border: Border.all(color: const Color(0xFFB9E1EC), width: 3),
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
  final Future<Map<String, Diary>> diarys;
  diaryContainer({
    super.key,
    required this.diarys,
    required this.calendarDate,
  });

  @override
  State<diaryContainer> createState() => _diaryContainerState();
}

class _diaryContainerState extends State<diaryContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height.,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      padding: EdgeInsets.fromLTRB(
          10,
          MediaQuery.of(context).size.width * 0.035,
          MediaQuery.of(context).size.width * 0.035,
          0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: widget.diarys,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return makeContainer(snapshot, widget.calendarDate);
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [Text('아직 일기가 없어요')],
                );
              }),
        ],
      ),
    );
  }
}

Widget makeContainer(
    AsyncSnapshot<Map<String, Diary>> snapshot, String calendarDate) {
  if (snapshot.data!.containsKey(calendarDate)) {
    Diary containerDiary = snapshot.data![calendarDate] as Diary;
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

class Event {
  final String title;
  const Event(this.title);
  @override
  String toString() => title;
}

class _bottomNaviState extends State<bottomNavi> {
  final screens = [
    //이게 하나하나의 화면이되고, Text등을 사용하거나, dart파일에 있는 class를 넣는다.
    const HomeScreen(),
    const noticeScreen(),
    const writeDiaryScreen(),
    const statisticsScreen(),
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
