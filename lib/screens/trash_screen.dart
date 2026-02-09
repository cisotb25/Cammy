import 'package:flutter/material.dart';
import '../models/photo_item.dart';

class TrashScreen extends StatelessWidget {
  final List<PhotoItem> trashItems;
  final VoidCallback onFeedTrashy;

  const TrashScreen({
    super.key,
    required this.trashItems,
    required this.onFeedTrashy
  });

  @override
  Widget build(BuildContext context) {
    bool isTrashEmpty = trashItems.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align to top
            children: [
              // 1. Reduced top spacing to move everything "slightly upwards"
              const SizedBox(height: 40),

              // --- 2. The Text ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  isTrashEmpty
                      ? "I'm starving!\nGive me something to eat already!"
                      : "You have ${trashItems.length} photos\nready to feed Trashy!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // --- 3. The Mascot ---
              Image.asset(
                // Logic kept for when you have the different emotions!
                isTrashEmpty ? 'assets/images/trashy.png' : 'assets/images/trashy.png',
                height: 300,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // --- 4. The Buttons Area ---
              // Using Visibility with maintainSize: true keeps the layout stable
              // so Trashy doesn't "jump" down when the buttons disappear.
              Visibility(
                visible: !isTrashEmpty,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: onFeedTrashy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.local_fire_department, color: Colors.white, size: 22),
                      label: const Text(
                        "FEED ALL",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                          "CHECK ITEMS",
                          style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600)
                      ),
                    ),
                  ],
                ),
              ),

              // This pushes the reserved button space up from the bottom nav
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}