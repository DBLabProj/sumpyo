import 'package:flutter/material.dart';
import 'package:sumpyo/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sumpyo/screens/mypage_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
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
      // home: const HomeScreen(),
      home: const myPage(),
    );
  }
}
