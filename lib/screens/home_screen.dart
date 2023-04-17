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
  var slidingMaxHeight = 500.0;
  var slidingMinHeight = 100.0;
  Size? calWeekSize;
  Size? calMonthSize;
  Size? contentSize;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calMonthSize = getMonthCalSize();
      calWeekSize = getWeekCalSize();
      contentSize = getContentSize();
      // getContentSize();
    });
  }

  Size? getWeekCalSize() {
    calFormat = CalendarFormat.week;
    RenderBox calBox =
        _mainCalKey.currentContext!.findRenderObject() as RenderBox;
    Size calWeekSize = calBox.size;
    setState(() {});
    return calWeekSize;
  }

  Size? getMonthCalSize() {
    calFormat = CalendarFormat.month;
    RenderBox calBox =
        _mainCalKey.currentContext!.findRenderObject() as RenderBox;
    Size size = calBox.size;
    setState(() {});
    return size;
  }

  Size? getContentSize() {
    RenderBox calBox =
        contentKey.currentContext!.findRenderObject() as RenderBox;
    Size size = calBox.size;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: topAppBar(
        appBar: AppBar(),
      ),
      bottomNavigationBar: const bottomNav(),
      body: SafeArea(
        child: SlidingUpPanel(
          onPanelOpened: () {
            calFormat = CalendarFormat.week;
            setState(() {});
          },
          onPanelClosed: () {
            calFormat = CalendarFormat.month;
            setState(() {});
          },
          // minHeight: _mainCalendarState().getCalSize()!.height,
          // maxHeight: MediaQuery.of(context).size.height * 0.65,
          maxHeight: slidingMaxHeight,
          minHeight: slidingMinHeight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          panelBuilder: () {
            return const diaryContainer();
          },
          body: GestureDetector(
            onDoubleTap: () {
              slidingMaxHeight = getContentSize()!.height - 0.65;
              slidingMinHeight = getContentSize()!.height * 0.35;
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
      // rowHeight: MediaQuery.of(context).size.height * 0.8,
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
          Text('2023년 04월 06일'),
          SizedBox(
            height: 20,
          ),
          Text('물통 깨뜨린 날...'),
          SizedBox(
            height: 20,
          ),
          Text('오늘 아침에 연구실에 출근하자마자 물통을 떨어뜨려서 바닥이 물범벅이 됐다. 물통 만 오천원이더 ...'),
          // Text('${widget.?}')
        ],
      ),
    );
  }
}

class bottomNav extends StatefulWidget {
  const bottomNav({super.key});

  @override
  State<bottomNav> createState() => _bottomNavState();
}

class _bottomNavState extends State<bottomNav> {
  int current_index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      currentIndex: current_index,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        print('index test : $index');
        setState(() {
          current_index = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month_outlined,
          ),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.insert_drive_file_outlined,
          ),
          label: 'Clip',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            size: 30,
          ),
          label: 'Somthing',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bar_chart_rounded,
          ),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.supervised_user_circle,
          ),
          label: 'MyPage',
        ),
      ],
    );
  }
}
