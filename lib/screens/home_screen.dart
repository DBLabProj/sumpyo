import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: current_index,
        onTap: (index) {
          print('index test : $index');
          setState(() {
            current_index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFF8AA9DE),
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.insert_drive_file_outlined,
              color: Color(0xFF8AA9DE),
            ),
            label: 'Clip',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart_rounded,
              color: Color(0xFF8AA9DE),
            ),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervised_user_circle,
              color: Color(0xFF8AA9DE),
            ),
            label: 'MyPage',
          ),
        ],
      ),
      body: Column(
        children: const [
          Text('Data'),
        ],
      ),
    );
  }
}
