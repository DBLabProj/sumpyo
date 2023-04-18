import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat calFormat = CalendarFormat.month;
  final GlobalKey _mainCalKey = GlobalKey();
  final GlobalKey contentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: topAppBar(
        appBar: AppBar(),
      ),
      bottomNavigationBar: const bottomNavi(),
      body: SafeArea(
        //--------------------------------슬라이딩 패널--------------------------
        child: SlidingUpPanel(
          onPanelOpened: () {
            calFormat = CalendarFormat.week;
            setState(() {});
          },
          onPanelClosed: () {
            calFormat = CalendarFormat.month;
            setState(() {});
          },
          minHeight: MediaQuery.of(context).size.height * 0.3,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          panelBuilder: () {
            return const writeDiary();
          },
          //-------------------------------바디 영역----------------------------
          body: GestureDetector(
            onDoubleTap: () {
              setState(
                () {},
              );
            },
            child: Column(
              key: contentKey,
              children: [
                mainCalendar(
                  calendarFormat: calFormat,
                  mainCalKey: _mainCalKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------상단 바------------------------------------
class topAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  const topAppBar({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              ))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

// -----------------------------------달력--------------------------------------
class mainCalendar extends StatefulWidget {
  CalendarFormat calendarFormat;
  GlobalKey mainCalKey;
  mainCalendar({
    super.key,
    required this.calendarFormat,
    required this.mainCalKey,
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
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2050, 12, 31),
      calendarFormat: widget.calendarFormat,
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
        });
      },
    );
  }
}

// -----------------------------------일기 화면----------------------------------
class diaryContainer extends StatefulWidget {
  const diaryContainer({super.key});

  @override
  State<diaryContainer> createState() => _diaryContainerState();
}

class _diaryContainerState extends State<diaryContainer> {
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
      // EdgeInsets.symmetric(
      //     horizontal: MediaQuery.of(context).size.width * 0.07),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // 일기 일자
          Text('2023년 04월 06일'),
          SizedBox(
            height: 20,
          ),
          // 일기 제목
          Text('물통 깨뜨린 날...'),
          SizedBox(
            height: 20,
          ),
          // 일기 내용
          Text('오늘 아침에 연구실에 출근하자마자 물통을 떨어뜨려서 바닥이 물범벅이 됐다. 물통 만 오천원이더 ...'),
          // Text('${widget.?}')
        ],
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

class bottomNavi extends StatefulWidget {
  const bottomNavi({super.key});

  @override
  State<bottomNavi> createState() => _bottomNaviState();
}

class _bottomNaviState extends State<bottomNavi> {
  int visit = 0;
  double height = 30;
  Color bgColor = Colors.white;
  Color color2 = Colors.black;
  @override
  Widget build(BuildContext context) {
    Color colorSelect = Theme.of(context).primaryColor;
    return SizedBox(
      height: 60,
      child: BottomBarCreative(
        backgroundColor: bgColor,
        items: items,
        color: color2,
        colorSelected: colorSelect,
        indexSelected: visit,
        // styleDivider: StyleDivider.bottom,
        isFloating: true,
        highlightStyle: const HighlightStyle(elevation: 2, sizeLarge: true),
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
