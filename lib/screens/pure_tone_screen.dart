import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/widgets/app_bar.dart';
import 'package:freq_fit/widgets/container_displaying_fq_and_db.dart';
import 'package:freq_fit/widgets/container_frequency_button.dart';
import 'package:freq_fit/widgets/my_drawer.dart';
import 'package:freq_fit/widgets/reusable_container_for_buttons.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:freq_fit/riverpod/freqDb.dart';

class PureToneScreen extends ConsumerWidget {

  // Define variables for frequency, decibel, and other state values
  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final freqDb = ref.watch(freqDbProvider);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80), // Adjust height as needed
        child: AppBarCustom(
          title: 'PURE TONE',
        ),
      ), 
      drawer: const MyDrawer(),
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
                      const TextStyle(fontWeight: FontWeight.bold),
                      const TextStyle(fontWeight: FontWeight.bold),
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
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
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
                          number: freqDb.freq,
                          unit: 'hz',
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 5,
                        child: ContainerDisplayingFqAndDb(
                          number: freqDb.db,
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
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                child: Row(
                  children: [
                    // Frequency Buttons
                    Expanded(
                      flex: 3,
                      child: Container(
                        // padding: EdgeInsets.all(7),

                            child:  Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: (){
                                      ref.read(freqDbProvider).incrementFreq();
                                    },
                                    child: ContainerFrequenyButton(
                                      iconData: Icons.arrow_drop_up_sharp,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: (){
                                        ref.read(freqDbProvider).decrementFreq();
                                      },
                                      child: ContainerFrequenyButton(
                                        iconData: Icons.arrow_drop_down_sharp,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        // Stop and Start Button
                        const Expanded(
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 28, horizontal: 0),
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
                                    containerChild: GestureDetector(
                                      onTap: (){
                                        ref.read(freqDbProvider).incrementDb();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(15),
                                        child: const FaIcon(
                                          FontAwesomeIcons.volumeHigh,
                                          color: kPureWhiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 3,
                                  child: ReusableContainerForButtons(
                                    containerChild: GestureDetector(
                                      onTap: (){
                                        ref.read(freqDbProvider).decrementDb();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(19),
                                        child: const FaIcon(
                                          FontAwesomeIcons.volumeLow,
                                          color: kPureWhiteColor,
                                          // size: 25,
                                        ),
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
                const Expanded(
                    flex: 2,
                    child: ReusableContainerForButtons(
                      // padding:
                      margin: EdgeInsets.symmetric(
                          vertical: 18, horizontal: 10),
                      colour: kLightGreyColor,
                      width: double.infinity,
                      containerChild: Center(
                        child: Text(
                          'Finish',
                          style: TextStyle(color: Color(0xff28334A50),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
                const Spacer(),
              ],
            ),
          ),
    );
  }
}
