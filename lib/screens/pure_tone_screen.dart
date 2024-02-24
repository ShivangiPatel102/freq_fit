import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/providers/audio_points.dart';
import 'package:freq_fit/widgets/app_bar.dart';
import 'package:freq_fit/widgets/button_for_save_and_finish.dart';
import 'package:freq_fit/widgets/container_displaying_fq_and_db.dart';
import 'package:freq_fit/widgets/container_frequency_button.dart';
import 'package:freq_fit/widgets/my_drawer.dart';
import 'package:freq_fit/widgets/reusable_container_for_buttons.dart';
import 'package:freq_fit/widgets/show_alert_continue_with_next_ear.dart';
import 'package:freq_fit/widgets/show_finish_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:sound_generator/sound_generator.dart';
import 'package:sound_generator/waveTypes.dart';
import 'package:freq_fit/widgets/show_alert_check_headphone.dart';
import 'package:freq_fit/widgets/show_alert_select_ear.dart';
import 'package:headset_connection_event/headset_event.dart';

import '../models/AudioData.dart';
import 'audio_chart.dart';

class PureToneScreen extends ConsumerStatefulWidget {
  @override
  _PureToneScreenState createState() => _PureToneScreenState();
}

class _PureToneScreenState extends ConsumerState<PureToneScreen> {
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
  bool isFinishButtonActive = false;
  Color buttonColor = kButtonColor;
  // int toggleSwitchIndex = 0;
  int finishButtonPressCount = 0;

  void _handleFinishButtonPress() {
    setState(() {
      finishButtonPressCount++;

      if (finishButtonPressCount == 1) {
        // show_alert_continue_with_next_ear(context);
        show_alert_continue_with_next_ear(context, () {
          
            setState(() {
               balance = 1;
              print(balance);
            });
          
        });
      } else if (finishButtonPressCount > 1) {
        show_finish_alert(context);
      }
    });
    print(finishButtonPressCount);
  }

  void _checkAndShowAlert() {
    if (_headsetState != HeadsetState.CONNECT) {
      show_Alert_Check_Headphone(context);
    } else if (_headsetState == HeadsetState.CONNECT) {
      show_Alert_Select_Ear(context);
    }
  }

  @override
  void initState() {
    super.initState();

    _headsetPlugin.requestPermission();
    _headsetPlugin.getCurrentState.then((val) {
      setState(() {
        _headsetState = val;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // _checkAndShowAlert();
        });
      });
    });

    _headsetPlugin.setListener((val) {
      setState(() {
        _headsetState = val;
        if (_headsetState != HeadsetState.CONNECT) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            show_Alert_Check_Headphone(context);
          });
        } else {
          Navigator.pop(context);
        }

        // _checkAndShowAlert();
      });
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
    SoundGenerator.setFrequency(0);
    SoundGenerator.setVolume(0);
  }

  @override
  Widget build(BuildContext context) {
    List<AudioData> leftEar = ref.read(audioDataPointsProvider).leftEarPoints;
    List<AudioData> rightEar = ref.read(audioDataPointsProvider).rightEarPoints;
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
                    activeBgColor: const [kRedColor],
                    customTextStyles: const [
                      TextStyle(fontWeight: FontWeight.bold),
                      TextStyle(fontWeight: FontWeight.bold),
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: kNavyBlueColor,
                    inactiveFgColor: kNavyBlueColor,
                    initialLabelIndex: balance,
                    totalSwitches: 2,
                    labels: const ['L', 'R'],
                    radiusStyle: true,
                    onToggle: (index) {
                      // print('switched to: $index');
                      setState(() {
                        if (index == 0) {
                          balance = 0;
                          SoundGenerator.setBalance(-1);
                        } else {
                          balance = 1;
                          SoundGenerator.setBalance(1);
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            // frequency and decibel
            Expanded(
              flex: 7,
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

            const Spacer(),

            // Control Buttons
            Expanded(
              flex: 5,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                child: Row(
                  children: [
                    // Frequency Buttons
                    Expanded(
                      flex: 3,
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
                              child: ReusableContainerForButtons(
                                width: 60,
                                containerChild: Center(
                                  child: Image.asset(
                                    'assets/icons/caret-up.png',
                                    height: 25,
                                  ),
                                ),
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
                                    } else if (frequency == 12000) {
                                      isFinishButtonActive = true;
                                    }
                                    SoundGenerator.setFrequency(frequency);
                                  });
                                },
                                child: ReusableContainerForButtons(
                                  width: 60,
                                  containerChild: Center(
                                    child: Image.asset(
                                      'assets/icons/caret-down.png',
                                      height: 25,
                                    ),
                                  ),
                                ),
                              )),
                        ],
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
                              // AudioData audio = AudioData(freq: frequency, db: volume);
                              // if(balance==0)
                              // {
                              //   leftEar.add(audio);
                              // }
                              // else if(balance==1)
                              // {
                              //   rightEar.add(audio);
                              // }
                            }
                          },
                          child: ReusableContainerForButtons(
                            colour: kRedColor,
                            containerChild: Text(
                              buttonText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: kPureWhiteColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.symmetric(
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
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (volume < 90) {
                                      volume += 5;
                                    }
                                    SoundGenerator.setVolume(volume/100);
                                  });
                                },
                                child: ReusableContainerForButtons(
                                  containerChild: Center(
                                    child: Image.asset(
                                      'assets/icons/volumeUp.png',
                                      height: 25,
                                    ),
                                  ),
                                  width: 60,
                                  colour: kNavyBlueColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (volume > 0) {
                                      volume -= 5;
                                    }
                                    SoundGenerator.setVolume(volume/100);
                                  });
                                },
                                child: ReusableContainerForButtons(
                                  containerChild: Center(
                                    child: Image.asset(
                                      'assets/icons/volumeDown.png',
                                      height: 25,
                                    ),
                                  ),
                                  width: 60,
                                  colour: kNavyBlueColor,
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

            const Spacer(),

            Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Center(
                          child: Container(
                        width: double.infinity,
                        child: ButtonForSaveAndFinish(
                          title: 'Save',
                          onPressed: () {
                            AudioData audio =
                                AudioData(freq: frequency, db: volume);
                            if (balance == 0) {
                              leftEar.add(audio);
                            } else if (balance == 1) {
                              rightEar.add(audio);
                            }
                          },
                        ),
                      )),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 6,
                      child: Center(
                          child: Container(
                        width: double.infinity,
                        child: ButtonForSaveAndFinish(
                          title: 'Finish',
                          onPressed: () {
                            _handleFinishButtonPress();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => AudioChartScreen(),
                            //   ),
                            // );
                          },
                        ),
                      )),
                    ),
                  ],
                )),
            // const Spacer(),
          ],
        ),
      ),
    );
  }
}
