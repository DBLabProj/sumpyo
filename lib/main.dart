import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sumpyo/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sumpyo/screens/dummy_screen.dart';
import 'package:sumpyo/screens/home_screen.dart';
import 'package:sumpyo/screens/login_screen.dart';
import 'package:sumpyo/screens/notice_screen.dart';
import 'package:sumpyo/screens/statistics_screen.dart';

void main() {
  runApp(const loginApp());
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int visit = 0;
  final screens = [
    //이게 하나하나의 화면이되고, Text등을 사용하거나, dart파일에 있는 class를 넣는다.
    const HomeScreen(),
    const noticeScreen(),
    const dummyScreen(),
    const statisticsScreen(),
    const myPage(),
  ];
  @override
  Widget build(BuildContext context) {
    Color colorSelect = Theme.of(context).primaryColor;
    return MaterialApp(
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
      home: Scaffold(
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: loginScreen()),
    );
  }
}
