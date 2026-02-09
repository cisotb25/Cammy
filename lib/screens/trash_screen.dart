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
      body: SafeArea(
        // 1. SizedBox.expand or width: double.infinity ensures content is centered horizontally
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Force horizontal centering
            children: [
              // --- 1. The Text ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  isTrashEmpty
                      ? "I'm starving!\nGive me something to eat already!"
                      : "You have ${trashItems.length} photos\nready to feed Trashy!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Made text slightly bigger
                ),
              ),

              const SizedBox(height: 30),

              // --- 2. The Mascot ---
              // REMOVED the Container wrapper that was limiting the size!
              // Now Trashy can breathe.
              Image.asset(
                isTrashEmpty ? 'assets/images/trashy.png' : 'assets/images/trashy.png',
                height: 350, // Much bigger!
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 50),

              // --- 3. The Buttons ---
              if (!isTrashEmpty) ...[
                ElevatedButton.icon(
                  onPressed: onFeedTrashy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    // Bigger button to match the bigger mascot
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.local_fire_department, color: Colors.white, size: 28),
                  label: const Text(
                    "FEED ALL",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigate to the "Check List" screen (Future feature)
                  },
                  child: const Text(
                      "CHECK ITEMS",
                      style: TextStyle(color: Colors.grey, fontSize: 16)
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}