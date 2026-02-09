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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}