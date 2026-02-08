import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'photo_card.dart';

void main() => runApp(const MaterialApp(home: CammyHome()));

class CammyHome extends StatelessWidget {
  const CammyHome({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> cards = [Colors.red, Colors.blue, Colors.green, Colors.orange];

    return Scaffold(
      appBar: AppBar(title: const Text("Cammy Cleanup")),
      body: Center(
        child: SizedBox(
          height: 500,
          child: CardSwiper(
            cardsCount: cards.length,
            cardBuilder: (context, index, _, __) => PhotoCard(color: cards[index], index: index),
            onSwipe: (prev, current, direction) {
              print("Swiped ${direction.name}");
              return true;
            },
          ),
        ),
      ),
    );
  }
}