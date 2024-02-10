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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //width: 126,
        //height: 151,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
                color: Color(0xfffdfcfc), spreadRadius: 1.0, blurRadius: 3.0)
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(imagePath,
                  fit: BoxFit.cover),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Rubik',
                      color: Color.fromRGBO(40, 51, 74, 1))),
            ),
          ],
        ),
      ),
    );
  }
}