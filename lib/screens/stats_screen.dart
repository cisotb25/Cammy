import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // --- 1. THE STREAK ---
            Text(
              "$streakCount",
              style: const TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
                height: 1.0, // Tighter spacing
              ),
            ),
            const Text(
              "FLASH STREAK",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),

            // --- 2. THE MASCOT ---
            Image.asset(
              'assets/images/flashy.png',
              height: 160,
              errorBuilder: (c, o, s) => const Icon(Icons.lightbulb, size: 80, color: Colors.yellow),
            ),

            // --- 3. THE CALENDAR SECTION ---
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Jan 2026",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildCalendarGrid(),

            const SizedBox(height: 20),

            // --- 4. THE STATS GRID ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.8, // Slightly flatter boxes
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

  // --- CALENDAR BUILDER ---
  Widget _buildCalendarGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 31, // January has 31 days
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 7 days a week
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          int day = index + 1;
          // For the prototype, let's highlight days 1 through 15 as "streak days"
          bool isStreakDay = day <= 15;

          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isStreakDay ? Colors.orangeAccent : Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "$day",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isStreakDay ? Colors.white : Colors.black54,
              ),
            ),
          );
        },
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
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}