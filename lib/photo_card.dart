import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
  final Color color;
  final int index;

  const PhotoCard({super.key, required this.color, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        "Photo #$index",
        style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}



