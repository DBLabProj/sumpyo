import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sumpyo/screens/login_screen.dart';

void main() async {
  await initializeDateFormatting();
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
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate
      // ],
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   Locale('ko', 'KO'),
      // ],
      theme: ThemeData(
        primaryColor: const Color(0xFF8AA9DE),
        secondaryHeaderColor: const Color(0xFFE8EEF9),
      ),
      // home: const HomeScreen(),
      home: const loginPage(),
    );
  }
}
