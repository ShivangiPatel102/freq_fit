import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/providers/audio_points.dart';
import 'package:freq_fit/widgets/app_bar.dart';
import 'package:freq_fit/widgets/reusable_container_for_buttons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/AudioData.dart';
import 'package:flutter/material.dart';

class AudioChartScreen extends ConsumerWidget {
  // AudioChartScreen({required this.leftEar, required this.rightEar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<AudioData> leftEar =
        ref.read(audioDataPointsProvider).leftEarPoints;
    final List<AudioData> rightEar =
        ref.read(audioDataPointsProvider).rightEarPoints;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarCustom(title: 'PTA Results')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Expanded(
              child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: ReusableContainerForButtons(
              colour: kPureWhiteColor,
              containerChild: Center(
                  child: Text(
                'Patient Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              )),
            ),
          )),
          const Spacer(),
          Expanded(
            flex: 9,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: kPureWhiteColor,
              child: Container(
                color: kPureWhiteColor,
                padding: EdgeInsets.fromLTRB(0, 20, 20, 10),
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(
                    title: AxisTitle(text: 'Frequency'),
                    interval: 500,
                  ),
                  primaryYAxis: const NumericAxis(
                    title: AxisTitle(text: 'Volume'),
                    interval: 5,
                  ),
                  series: <CartesianSeries>[
                    LineSeries<AudioData, double>(
                      dataSource: leftEar,
                      xValueMapper: (AudioData data, _) => data.freq,
                      yValueMapper: (AudioData data, _) => data.db,
                      name: 'Left Ear',
                      markerSettings: MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.diamond,
                        color: Colors.blue, // Customize marker color
                      ),
                    ),
                    LineSeries<AudioData, double>(
                      dataSource: rightEar,
                      xValueMapper: (AudioData data, _) => data.freq,
                      yValueMapper: (AudioData data, _) => data.db,
                      name: 'Right Ear',
                      markerSettings: MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.diamond,
                        color: Colors.red, // Customize marker color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              margin: EdgeInsets.symmetric(horizontal: 30),
              
              child: ReusableContainerForButtons(
                padding:EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                colour: kPureWhiteColor,
                containerChild: Text(
                  'Doctor\'s Remark',
                  // textAlign: Text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
