import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  // We'll pass these from MainLayout later
  final int streakCount;
  final int totalPhotos;
  final int todayPhotos;
  final int deletedPhotos;
  final int todayTrash;

  const StatsScreen({
    super.key,
    required this.streakCount,
    required this.totalPhotos,
    required this.todayPhotos,
    required this.deletedPhotos,
    required this.todayTrash,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Allows scrolling on smaller phones
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- 1. THE STREAK ---
            Text(
              "$streakCount",
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
            ),
            const Text(
              "FLASH STREAK",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),

            const SizedBox(height: 20),

            // --- 2. THE MASCOT ---
            Image.asset(
              'assets/images/flashy.png',
              height: 200,
              errorBuilder: (c, o, s) => const Icon(Icons.lightbulb, size: 100, color: Colors.yellow),
            ),

            const SizedBox(height: 30),

            // --- 3. THE STATS GRID ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                shrinkWrap: true, // Needed inside a Column
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: [
                  _statBox("Total pics", totalPhotos.toString()),
                  _statBox("Today's pics", todayPhotos.toString()),
                  _statBox("Pics deleted", deletedPhotos.toString()),
                  _statBox("Today's trash", todayTrash.toString()),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}