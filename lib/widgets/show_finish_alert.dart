import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/screens/audio_chart.dart';

void show_finish_alert(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: kNavyBlueColor,
              content: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'We are Done with Testing',
                        textAlign: TextAlign.center,
                        style: kAlertCardTextStyle,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioChartScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: kWhiteWidgetColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Center(
                            child: Text(
                          'End Test',
                          style: kAlertCardButtonTextStyle,
                        )),
                      ),
                    ))
                  ],
                ),
              ),
            ));
      });
}
