import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/screens/pure_tone_screen.dart';
import 'package:freq_fit/widgets/reusable_container_for_buttons.dart';

class ContainerFrequenyButton extends StatelessWidget {
  const ContainerFrequenyButton({
    super.key,
    required this.iconData,
  });
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return ReusableContainerForButtons(
      containerChild: Container(
        margin: EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
          color: kPureWhiteColor,
        ),
        child: Icon(
          iconData,
          color: kNavyBlueColor,
          // size: 30,
        ),
      ),
    );
  }
}
