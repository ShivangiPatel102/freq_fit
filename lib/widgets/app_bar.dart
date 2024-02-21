import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/widgets/letter_avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      leading: GestureDetector(
        onTap: (){
          Scaffold.of(context).openDrawer();
        },
        child: Container(
        padding: const EdgeInsetsDirectional.only(start: 37.0,top: 17.0,bottom: 10.0),
        child: FaIcon(FontAwesomeIcons.bars,size: 23.0,),
      ),),
      shape: const RoundedRectangleBorder(
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
              text: const TextSpan(
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

      actions: const [
        LetterAvatar(name: 'Shivangi'),
        SizedBox(
          width: 25,
        ),
      ],
    );
  }
}
