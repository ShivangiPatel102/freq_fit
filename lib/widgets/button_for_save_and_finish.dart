import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';

class ButtonForSaveAndFinish extends StatelessWidget {
  const ButtonForSaveAndFinish({
    super.key,
    required this.title,
    required this.onPressed,
    
  });
  final String title;
  final VoidCallback onPressed;
  // final Color buttonColor;
  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        foregroundColor: kNavyBlueColor,
        backgroundColor: kWhiteWidgetColor,
        // overlayColor: MaterialStateProperty.all<Color?>(Colors.green),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        // maximumSize: ,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(title,
          textAlign: TextAlign.center, style: kWhiteButtonTextStyle),
    );
  }
}
