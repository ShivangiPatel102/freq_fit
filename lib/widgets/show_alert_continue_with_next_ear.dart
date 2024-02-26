import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';

import '../screens/audio_chart.dart';

void show_alert_continue_with_next_ear(
    BuildContext context, VoidCallback onContinue) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: kNavyBlueColor,
          content: Container(
            height: 300,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Expanded(
                  child: Text(
                    'Continue with next Ear',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Blinker',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kPureWhiteColor),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onContinue();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteWidgetColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Center(
                          child: Text(
                        'Continue',
                        style: TextStyle(
                            fontFamily: 'Blinker',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kNavyBlueColor),
                      )),
                    ),
                  ),
                ),
                const Expanded(
                    flex: 2,
                    child: Center(
                        child: Text(
                      'Or',
                      style: kAlertCardTextStyle,
                    ))),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AudioChartScreen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteWidgetColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Center(
                        child:
                            Text('End Test', style: kAlertCardButtonTextStyle),
                      ),
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
