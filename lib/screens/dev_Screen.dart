import 'package:flutter/material.dart';
import 'package:sumpyo/screens/home_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class devScreen extends StatefulWidget {
  const devScreen({super.key});

  @override
  State<devScreen> createState() => _devScreenState();
}

class _devScreenState extends State<devScreen> {
  DateTime _selectedDate = DateTime.now();
  final GlobalKey calKey = GlobalKey();
  CalendarFormat calFormat = CalendarFormat.month;
  changeDate(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Colors.amber,
      child: Column(
        children: [
          mainCalendar(
              calendarFormat: calFormat,
              ableDays: const [],
              changeDate: changeDate),
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
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 50,
                  height: 10,
                  child: Container(
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
            child: Card(
              child: Container(
                color: Colors.black,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: TextButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        child: const Text('Change'),
                        onPressed: () {
                          calFormat == CalendarFormat.month
                              ? calFormat = CalendarFormat.week
                              : calFormat = CalendarFormat.month;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
