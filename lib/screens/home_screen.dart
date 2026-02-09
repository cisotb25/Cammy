import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../widgets/photo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy data for now
  List<Color> cards = [Colors.red, Colors.blue, Colors.green, Colors.orange];

  // To track if we are done
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // Keeps Cammy from being hidden behind the notch
        child: Column(
          children: [
            // --- THE MASCOT AREA ---
            Expanded(
              flex: 2, // Takes up 2/5 of the screen
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // The Image
                  Image.asset(
                    _isDone ? 'assets/images/cammy.png' : 'assets/images/cammy.png',
                    height: 150,
                    // If you don't have the image yet, use this error builder to prevent crash:
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
              flex: 3, // Takes up 3/5 of the screen
              child: _isDone
                  ? const Center(child: Text("🎉 All Clean!"))
                  : CardSwiper(
                cardsCount: cards.length,
                numberOfCardsDisplayed: 3,
                cardBuilder: (context, index, _, __) => PhotoCard(color: cards[index], index: index),
                onSwipe: _onSwipe,
                isLoop: false, // Don't loop photos, we want to finish them!
                onEnd: () {
                  setState(() {
                    _isDone = true; // Trigger the "Happy Cammy" state
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
    // Logic later: Delete or Keep
    return true;
  }
}