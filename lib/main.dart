import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sumpyo/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sumpyo/notification.dart';
import 'package:sumpyo/screens/intro_screen.dart';
import 'package:sumpyo/screens/notice_screen.dart';
import 'package:sumpyo/screens/write_diary_screen.dart';
import 'package:sumpyo/screens/home_screen.dart';
import 'package:sumpyo/screens/mypage_screen.dart';
import 'package:sumpyo/screens/analysis_screen.dart';

void main() {
  runApp(const loginApp());
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    FlutterNotification.init();
    Future.delayed(const Duration(seconds: 3),
        FlutterNotification.requestNotificationPermission());
    super.initState();
  }

  double panelMaxHeight = 0.0;
  double panelMinHeight = 0.0;
  int visit = 0;
  final screens = [
    //이게 하나하나의 화면이되고, Text등을 사용하거나, dart파일에 있는 class를 넣는다.
    const HomeScreen(),
    const AnalysisScreen(),
    const writeDiaryScreen(),
    noticeScreen(),
    const myPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[visit],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomBarCreative(
          backgroundColor: Colors.white,
          items: items,
          color: Colors.black,
          colorSelected: Theme.of(context).primaryColor,
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

class loginApp extends StatefulWidget {
  const loginApp({super.key});

  @override
  State<loginApp> createState() => _loginAppState();
}

class _loginAppState extends State<loginApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const introScreen(),
    );
  }
}
