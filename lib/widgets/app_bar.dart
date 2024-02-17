import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/widgets/letter_avatar.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    super.key,
    @required this.title,
  });
  final String? title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kWhiteWidgetColor,
      elevation: 1,
      shadowColor: Colors.black,
      // toolbarHeight: 80.0,
      centerTitle: true,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
      ),
      title: title != null
          ? Text(
              '$title',
              style: kTitleOfAppBarTextStyle,
            )
          : RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    style: TextStyle(color: kNavyBlueColor),
                    text: "Freq",
                  ),
                  TextSpan(
                    style: TextStyle(color: kRedColor),
                    text: "Fit",
                  ),
                ],
              ),
            ),

      actions: [
        LetterAvatar(name: 'Shivangi'),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
