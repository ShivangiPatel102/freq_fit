import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap; // Add this line if you want the card to be tappable

  const SmallCard({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onTap, // Add this argument if needed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(color: Color(0xFFEEEEEE), spreadRadius: 1.0, blurRadius: 3.0)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(imagePath, width: 80.0, height: 80.0, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10.0),
            Text(text, style: const TextStyle(fontSize: 16.0,fontFamily: 'Rubik',color: Color.fromRGBO(40, 51, 74, 1))),
          ],
        ),
      ),
    );
  }
}
