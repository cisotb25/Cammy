import 'package:flutter/material.dart';
import '../models/photo_item.dart';

class TrashScreen extends StatelessWidget {
  final List<PhotoItem> trashItems; // The screen now ASKS for data
  final VoidCallback onFeedTrashy;  // The function to empty the trash

  const TrashScreen({
    super.key,
    required this.trashItems,
    required this.onFeedTrashy
  });

  @override
  Widget build(BuildContext context) {
    bool isTrashEmpty = trashItems.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- 1. The Text ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                isTrashEmpty
                    ? "I'm starving!\nGive me something to eat already!"
                    : "You have ${trashItems.length} photos\nready to feed Trashy!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // --- 2. The Mascot ---
            // You can swap the image asset path here later!
            // 'assets/images/trashy_hungry.png' vs 'assets/images/trashy_full.png'
            Container(
              height: 200,
              width: 200,
              child: Image.asset(
                isTrashEmpty ? 'assets/images/trashy.png' : 'assets/images/trashy.png',
                height: 150,
                color: isTrashEmpty ? Colors.grey : Colors.red,
              ),
            ),

            const SizedBox(height: 40),

            // --- 3. The Buttons ---
            if (!isTrashEmpty) ...[
              ElevatedButton.icon(
                onPressed: onFeedTrashy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                icon: const Icon(Icons.local_fire_department, color: Colors.white),
                label: const Text(
                  "FEED ALL",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the "Check List" screen (Future feature)
                },
                child: const Text("CHECK ITEMS", style: TextStyle(color: Colors.grey)),
              )
            ]
          ],
        ),
      ),
    );
  }
}