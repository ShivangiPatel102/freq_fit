import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';

class LetterAvatar extends StatelessWidget {
  final String name;

  const LetterAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final firstLetter = name.substring(0, 1);
    final color = kLightGreyColor;

    return CircleAvatar(
      backgroundColor: color,
      child: Text(
        firstLetter,
        style: TextStyle(color: kRedColor, fontSize: 20),
      ),
    );
  }
}