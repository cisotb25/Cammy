import 'package:flutter/material.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(const CammyApp());
}

class CammyApp extends StatelessWidget {
  const CammyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cammy',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, // All screens white
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent, // No more tint!
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const MainLayout(),
    );
  }
}