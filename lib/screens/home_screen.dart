import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../photo_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for now
    List<Color> cards = [Colors.red, Colors.blue, Colors.green, Colors.orange];

    return Scaffold(
      // We don't need an AppBar here because the MainLayout will handle the look
      body: Column(
        children: [
          // 1. The Mascot Area (Top of your mockup)
          Container(
            height: 150,
            alignment: Alignment.center,
            child: const Text("📸 Cammy is Happy! (Mascot Here)"),
          ),

          // 2. The Swipe Area
          Expanded(
            child: CardSwiper(
              cardsCount: cards.length,
              cardBuilder: (context, index, _, __) => PhotoCard(color: cards[index], index: index),
              onSwipe: (prev, current, direction) {
                return true;
              },
            ),
          ),
        ],
      ),
    );
  }
}