import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/widgets/app_bar.dart';
import 'package:freq_fit/widgets/container_displaying_fq_and_db.dart';
import 'package:freq_fit/widgets/container_frequency_button.dart';
import 'package:freq_fit/widgets/my_drawer.dart';
import 'package:freq_fit/widgets/reusable_container_for_buttons.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PureToneScreen extends StatelessWidget {
  // Define variables for frequency, decibel, and other state values
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Adjust height as needed
        child: AppBarCustom(
          title: 'PURE TONE',
        ),
      ), 
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            // toggle switch for selecting ear
            Expanded(
              flex: 2,
              child: Container(
                // color: Colors.blue,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ToggleSwitch(
                    minWidth: 38,
                    minHeight: 28,
                    cornerRadius: 20.0,
                    activeBgColor: [kRedColor],
                    customTextStyles: [
                      TextStyle(fontWeight: FontWeight.bold),
                      TextStyle(fontWeight: FontWeight.bold),
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: kNavyBlueColor,
                    inactiveFgColor: kNavyBlueColor,
                    initialLabelIndex: 0,
                    totalSwitches: 2,
                    labels: ['L', 'R'],
                    radiusStyle: true,
                    onToggle: (index) {
                      // print('switched to: $index');
                    },
                  ),
                ),
              ),
            ),
            // frequency and decibel
            Expanded(
              flex: 6,
              child: Card(
                elevation: 10,
                shadowColor: Colors.black,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: kWhiteWidgetColor,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ContainerDisplayingFqAndDb(
                          number: 100,
                          unit: 'hz',
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 5,
                        child: ContainerDisplayingFqAndDb(
                          number: 10,
                          unit: 'dB',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Control Buttons
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                child: Row(
                  children: [
                    // Frequency Buttons
                    Expanded(
                      flex: 3,
                      child: Container(
                        // padding: EdgeInsets.all(7),

                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ContainerFrequenyButton(
                                iconData: Icons.arrow_drop_up_sharp,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                                flex: 3,
                                child: ContainerFrequenyButton(
                                  iconData: Icons.arrow_drop_down_sharp,
                                )),
                          ],
                        ),
                      ),
                    ),
                    // Stop and Start Button
                    Expanded(
                        flex: 6,
                        child: ReusableContainerForButtons(
                          colour: kRedColor,
                          containerChild: Text(
                            'Stop',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kPureWhiteColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 28, horizontal: 0),
                        )),
                    // Decibel Buttons
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ReusableContainerForButtons(
                                containerChild: Container(
                                  margin: EdgeInsets.all(15),
                                  child: FaIcon(
                                    FontAwesomeIcons.volumeHigh,
                                    color: kPureWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 3,
                              child: ReusableContainerForButtons(
                                containerChild: Container(
                                  margin: EdgeInsets.all(19),
                                  child: FaIcon(
                                    FontAwesomeIcons.volumeLow,
                                    color: kPureWhiteColor,
                                    // size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Finish Button
            Expanded(
                flex: 2,
                child: ReusableContainerForButtons(
                  // padding:
                  margin: EdgeInsets.symmetric(vertical: 18,horizontal: 10),
                  colour: kLightGreyColor,
                  width: double.infinity,
                  containerChild: Center(
                    child: Text(
                      'Finish',
                      style: TextStyle(color: Color(0xff28334A50),fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
