import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sumpyo/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sumpyo/notification.dart';
import 'package:sumpyo/screens/intro_screen.dart';
import 'package:sumpyo/screens/analysis_screen.dart';
import 'package:sumpyo/screens/login_screen.dart';
import 'package:sumpyo/screens/signup_screen.dart';
import 'package:sumpyo/screens/write_diary_screen.dart';
import 'package:sumpyo/screens/home_screen.dart';
import 'package:sumpyo/screens/mypage_screen.dart';
import 'package:sumpyo/screens/notice_screen.dart';

void main() {
  runApp(const App());
}

class appFrame extends StatefulWidget {
  int visit;
  DateTime selectedDate;
  appFrame({super.key, frame, this.visit = 0, selectedDate})
      : selectedDate = (selectedDate ?? DateTime.now());
  @override
  State<appFrame> createState() => _appFrameState();
}

class _appFrameState extends State<appFrame> {
  GlobalKey bottom = GlobalKey();
  @override
  void initState() {
    FlutterNotification.init();
    Future.delayed(const Duration(seconds: 3),
        FlutterNotification.requestNotificationPermission());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // final screens = [
  //   //이게 하나하나의 화면이되고, Text등을 사용하거나, dart파일에 있는 class를 넣는다.
  //   HomeScreen(),
  //   const noticeScreen(),
  //   const writeDiaryScreen(),
  //   const analysisScreen(),
  //   const myPage(),
  // ];
  @override
  Widget build(BuildContext context) {
    viewDiary(DateTime date) {
      setState(() {
        widget.visit = 0;
        widget.selectedDate = date;
      });
    }

    var screens = [
      //이게 하나하나의 화면이되고, Text등을 사용하거나, dart파일에 있는 class를 넣는다.
      HomeScreen(selectedDate: widget.selectedDate),
      noticeScreen(viewDiary: viewDiary),
      const writeDiaryScreen(),
      const analysisScreen(),
      const myPage(),
    ];
    return Scaffold(
      body: screens[widget.visit],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomBarDefault(
          backgroundColor: Colors.white,
          items: items,
          color: Colors.black.withOpacity(0.5),
          colorSelected: Theme.of(context).primaryColor,
          indexSelected: widget.visit,
          onTap: (index) => setState(
            () {
              if (index == 0) widget.selectedDate = DateTime.now();
              widget.visit = index;
            },
          ),
        ),
      ),
    );
  }
}

// ---------------------------------하단 바 아이템---------------------------------
const List<TabItem> items = [
  TabItem(icon: Icons.calendar_month_outlined),
  TabItem(icon: Icons.notifications_none_outlined),
  TabItem(icon: Icons.open_in_new_rounded),
  TabItem(icon: Icons.bar_chart_rounded),
  TabItem(icon: Icons.supervised_user_circle),
];

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/': (context) => appFrame(),
        '/login': (context) => const loginScreen(),
        '/splash': (context) => const introScreen(),
        '/writeDiary': (context) => const writeDiaryScreen(),
        '/mypage': (context) => const myPage(),
        '/notice': (context) => noticeScreen(),
        '/analysis': (context) => const analysisScreen(),
        '/signup': (context) => const signUpPage(),
        '/signup/sec': (context) => const secondPage(),
      },
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF8AA9DE),
        secondaryHeaderColor: const Color(0xFFE8EEF9),
        dividerColor: const Color(0xffCCCCCC),
      ),
    );
  }
}
