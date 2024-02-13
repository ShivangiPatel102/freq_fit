import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';


void show_finish_alert(BuildContext context){
  showDialog(context: context, builder: (BuildContext context){
    return PopScope(child: AlertDialog(
      backgroundColor: kNavyBlueColor,
      content: Container(
        height: 200,
        child:  Column(
          children: [
            const Spacer(),
            const Expanded(child: Text('We are Done with Testing',style:kAlertCardTextStyle,)),
            const Spacer(),
            Expanded(child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/ptaTest');

              },
              child: Container(
                decoration: BoxDecoration(
                  color: kWhiteWidgetColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Center(child: Text('End Test', style: kAlertCardButtonTextStyle,)),
              ),
            ))
          ],
        ),
      ),
    ));
  });
}