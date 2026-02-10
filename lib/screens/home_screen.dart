import 'package:cammy/screens/photo_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../widgets/photo_card.dart';
import '../models/photo_item.dart';

class HomeScreen extends StatefulWidget {
  final List<PhotoItem> deck;
  final Function(PhotoItem) onSwipeLeft;
  final Function(PhotoItem) onSwipeRight;

  const HomeScreen({
    super.key,
    required this.deck,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Track if the user has finished the current deck
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match the MainLayout for seamless look
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. THE MASCOT AREA (CAMMY) ---
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/cammy.png',
                    height: 150,
                    // If image is missing, show an icon placeholder
                    errorBuilder: (c, o, s) => const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  // The Text Bubble logic from your mockup
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, offset: Offset(2, 2))
                      ],
                    ),
                    child: Text(
                      _isDone
                          ? "You organized everything!\nThank you! :)"
                          : "Let's clean up!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. THE SWIPE AREA (REAL PHOTOS) ---
            Expanded(
              flex: 3,
              child: _isDone || widget.deck.isEmpty
                  ? const Center(
                child: Text(
                    "🎉 All Clean!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
              )
                  : CardSwiper(
                cardsCount: widget.deck.length,
                numberOfCardsDisplayed: widget.deck.length >= 3 ? 3 : widget.deck.length,
                // The Card Builder now passes the real photo asset
                cardBuilder: (context, index, horizontalOffset, verticalOffset) {
                  return GestureDetector(
                    onTap: () {
                      // Open full screen preview on tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoViewerScreen(asset: widget.deck[index].asset),
                        ),
                      );
                    },
                    child: PhotoCard(
                      photoItem: widget.deck[index],
                      index: index,
                    ),
                  );
                },
                onSwipe: _onSwipe,
                isLoop: false,
                onEnd: () {
                  setState(() {
                    _isDone = true; // Shows the "Happy Cammy" state
                  });
                },
              ),
            ),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }

  /// Handles the swipe logic and tells MainLayout to update stats/trash
  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    final swipedPhoto = widget.deck[previousIndex];

    if (direction == CardSwiperDirection.left) {
      // Photo sent to Trashy
      widget.onSwipeLeft(swipedPhoto);
    } else if (direction == CardSwiperDirection.right) {
      // Photo kept in Gallery
      widget.onSwipeRight(swipedPhoto);
    }

    return true; // Return true to confirm the swipe animation
  }
}