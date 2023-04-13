import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sumpyo/screens/home_screen.dart';

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
      theme: ThemeData(
        primaryColor: const Color(0xFF8AA9DE),
      ),
      home: const HomeScreen(),
    );
  }
}
