import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../widgets/photo_card.dart';
import '../models/photo_item.dart';

class HomeScreen extends StatefulWidget {
  final List<PhotoItem> deck;
  final Function(PhotoItem) onSwipeLeft;
  // 1. Define the new parameter here!
  final Function(PhotoItem) onSwipeRight;

  const HomeScreen({
    super.key,
    required this.deck,
    required this.onSwipeLeft,
    required this.onSwipeRight, // 2. Add it to the constructor
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Keep it seamless
      body: SafeArea(
        child: Column(
          children: [
            // --- THE MASCOT AREA ---
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/cammy.png',
                    height: 150,
                    errorBuilder: (c, o, s) => const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [const BoxShadow(color: Colors.black12, offset: Offset(2,2))],
                    ),
                    child: Text(
                      _isDone ? "You organized everything!\nThank you! :)" : "Let's clean up!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // --- THE SWIPE AREA ---
            Expanded(
              flex: 3,
              child: _isDone
                  ? const Center(child: Text("🎉 All Clean!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
                  : CardSwiper(
                cardsCount: widget.deck.length,
                numberOfCardsDisplayed: 3,
                cardBuilder: (context, index, _, __) {
                  return PhotoCard(
                      color: widget.deck[index].color,
                      index: index
                  );
                },
                onSwipe: _onSwipe,
                isLoop: false,
                onEnd: () {
                  setState(() {
                    _isDone = true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Update the swipe logic to handle both directions
  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.left) {
      widget.onSwipeLeft(widget.deck[previousIndex]);
    } else if (direction == CardSwiperDirection.right) {
      // Trigger the keep logic!
      widget.onSwipeRight(widget.deck[previousIndex]);
    }
    return true;
  }
}