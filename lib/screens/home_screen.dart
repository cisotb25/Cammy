import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../widgets/photo_card.dart';
import '../models/photo_item.dart'; // Import the model!

class HomeScreen extends StatefulWidget {
  // Now we ask for data instead of making it ourselves
  final List<PhotoItem> deck;
  final Function(PhotoItem) onSwipeLeft;

  const HomeScreen({
    super.key,
    required this.deck,
    required this.onSwipeLeft
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // We don't need 'List<Color> cards' here anymore, we use 'widget.deck'

  // To track if we are done
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- THE MASCOT AREA ---
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // The Image (Kept logic same as requested!)
                  Image.asset(
                    _isDone ? 'assets/images/cammy.png' : 'assets/images/cammy.png',
                    height: 150,
                    errorBuilder: (c, o, s) => const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  // The Text Bubble
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(2,2))],
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
                  ? const Center(child: Text("🎉 All Clean!"))
                  : CardSwiper(
                cardsCount: widget.deck.length, // Use the data from parent
                numberOfCardsDisplayed: 3,
                cardBuilder: (context, index, _, __) {
                  // Pass the color from the PhotoItem model
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

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.left) {
      // 1. Get the item that was swiped
      PhotoItem swipedItem = widget.deck[previousIndex];

      // 2. Tell MainLayout to put it in the trash
      widget.onSwipeLeft(swipedItem);

      debugPrint("Swiped Left on Photo #${swipedItem.id}");
    }
    return true;
  }
}