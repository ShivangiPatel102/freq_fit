import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/widgets/app_bar.dart';
import 'package:freq_fit/widgets/container_displaying_fq_and_db.dart';
import 'package:freq_fit/widgets/container_frequency_button.dart';
import 'package:freq_fit/widgets/my_drawer.dart';
import 'package:freq_fit/widgets/reusable_container_for_buttons.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:sound_generator/sound_generator.dart';
import 'package:sound_generator/waveTypes.dart';
import 'package:freq_fit/widgets/show_Alert_Check_Headphone.dart';
import 'package:freq_fit/widgets/show_Alert_Select_Ear.dart';
import 'package:headset_connection_event/headset_event.dart';

class PureToneScreen extends StatefulWidget {
  @override
  State<PureToneScreen> createState() => _PureToneScreenState();
}

class _PureToneScreenState extends State<PureToneScreen> {
  final _headsetPlugin = HeadsetEvent();
  HeadsetState? _headsetState;

  // Define variables for frequency, decibel, and other state values
  bool isPlaying = false;
  double frequency = 200;
  int balance = 0;
  double volume = 0;
  waveTypes waveType = waveTypes.SINUSOIDAL;
  int sampleRate = 96000;
  List<int>? oneCycleData;
  String buttonText = 'Start';

  void _checkAndShowAlert() {
    if (_headsetState != HeadsetState.CONNECT) {
      show_Alert_Check_Headphone(context);
    } else if (_headsetState == HeadsetState.CONNECT) {
      balance = show_Alert_Select_Ear(context);
    }
  }

  @override
  void initState() {
    super.initState();

    _headsetPlugin.requestPermission();
    _headsetPlugin.getCurrentState.then((val) {
      setState(() {
        _headsetState = val;
      });
    });

    _headsetPlugin.setListener((val) {
      setState(() {
        _headsetState = val;
        Navigator.pop(context);
        _checkAndShowAlert();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowAlert();
    });

    SoundGenerator.init(sampleRate);
    SoundGenerator.onIsPlayingChanged.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    SoundGenerator.onOneCycleDataHandler.listen((value) {
      setState(() {
        oneCycleData = value;
      });
    });

    SoundGenerator.setAutoUpdateOneCycleSample(true);
    //Force update for one time
    SoundGenerator.refreshOneCycleData();
    SoundGenerator.setWaveType(waveTypes.SINUSOIDAL);
  }

  @override
  Widget build(BuildContext context) {
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
                    initialLabelIndex: balance,
                    totalSwitches: 2,
                    labels: ['L', 'R'],
                    radiusStyle: true,
                    onToggle: (index) {
                      print('switched to: $index');
                      setState(() {
                        if (index == 0) {
                          balance = 0;
                          SoundGenerator.setBalance(1);
                        } else {
                          balance = 1;
                          SoundGenerator.setBalance(-1);
                        }
                      });
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
                          number: frequency,
                          unit: 'hz',
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 5,
                        child: ContainerDisplayingFqAndDb(
                          number: volume,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
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
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (frequency < 1000) {
                                      frequency += 200;
                                    } else if (frequency >= 1000 &&
                                        frequency < 2000) {
                                      frequency += 1000;
                                    } else if (frequency >= 2000 &&
                                        frequency < 12000) {
                                      frequency += 2000;
                                    }
                                    SoundGenerator.setFrequency(frequency);
                                  });
                                },
                                child: const ContainerFrequenyButton(
                                  iconData: Icons.arrow_drop_up_sharp,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (frequency > 2000 &&
                                          frequency <= 12000) {
                                        frequency -= 2000;
                                      } else if (frequency > 1000 &&
                                          frequency <= 2000) {
                                        frequency -= 1000;
                                      } else if (frequency > 200 &&
                                          frequency <= 1000) {
                                        frequency -= 200;
                                      }
                                      SoundGenerator.setFrequency(frequency);
                                    });
                                  },
                                  child: const ContainerFrequenyButton(
                                    iconData: Icons.arrow_drop_down_sharp,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    // Stop and Start Button
                    Expanded(
                        flex: 6,
                        child: GestureDetector(
                          onTap: () {
                            // SoundGenerator.setBalance(0);
                            // SoundGenerator.setVolume(1.0);
                            // SoundGenerator.setFrequency(150.0);
                            if (!isPlaying) {
                              SoundGenerator.play();
                              isPlaying = true;
                              buttonText = 'Stop';
                            } else {
                              SoundGenerator.stop();
                              isPlaying = false;
                              buttonText = 'Start';
                            }
                          },
                          child: ReusableContainerForButtons(
                            colour: kRedColor,
                            containerChild: Text(
                              buttonText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kPureWhiteColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 28, horizontal: 0),
                          ),
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
                                  onTap: () {
                                    setState(() {
                                      if (volume < 90) {
                                        volume += 10;
                                      }
                                      SoundGenerator.setVolume(volume);
                                    });
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
                                  onTap: () {
                                    setState(() {
                                      if (volume > 0) {
                                        volume -= 10;
                                      }
                                      SoundGenerator.setVolume(volume);
                                    });
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
                  margin: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  colour: kLightGreyColor,
                  width: double.infinity,
                  containerChild: Center(
                    child: Text(
                      'Finish',
                      style: TextStyle(
                          color: Color(0xff28334A50),
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
