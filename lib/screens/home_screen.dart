import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current_index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: topAppBar(
        appBar: AppBar(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        currentIndex: current_index,
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
      ),
      body: Column(
        children: const [
          mainCalendar(),
        ],
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
  const mainCalendar({super.key});

  @override
  State<mainCalendar> createState() => _mainCalendarState();
}

class _mainCalendarState extends State<mainCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2050, 12, 31),
      calendarFormat: _calendarFormat,
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
          _calendarFormat = CalendarFormat.week;
          this.selectedDay = selectedDay;
          this.focusedDay = focusedDay;
        });
      },
    );
  }
}
