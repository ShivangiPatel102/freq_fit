import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';

import '../screens/audio_chart.dart';

void show_alert_continue_with_next_ear (BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        //canPop: false,
        child: AlertDialog(
          backgroundColor: kNavyBlueColor ,
          content: Container(
            height: 300,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Expanded(child: Text('Continue with next Ear',style: kAlertCardButtonTextStyle)),
                const Spacer(flex: 2,),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/pureTone');
                    },
                    child: Container(
                      // height: 83,
                      // width: 90,
                      decoration: BoxDecoration(
                        color: kWhiteWidgetColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Center(child: Text('Continue',style: TextStyle(fontFamily: 'Blinker',fontWeight: FontWeight.bold,fontSize: 20,color: kNavyBlueColor),)),
                    ),
                  ),
                ),
                const Expanded(flex:2,child: Center(child: Text('Or',style: kAlertCardTextStyle,))),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      // height: 83,
                      // width: 90,
                      decoration: BoxDecoration(
                        color: kWhiteWidgetColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Center(child: Text('End Test',style: kAlertCardButtonTextStyle)),
                    ),
                  ),
                ),



              ],
            ),
          ),
        ),
      );
    },
  );
}