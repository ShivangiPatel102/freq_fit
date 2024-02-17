import 'package:freq_fit/constants.dart';
import 'package:freq_fit/widgets/app_bar.dart';
import 'package:freq_fit/widgets/reusable_container_for_buttons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/AudioData.dart';
import 'package:flutter/material.dart';

class AudioChartScreen extends StatelessWidget {
  final List<AudioData> leftEar;
  final List<AudioData> rightEar;

  AudioChartScreen({required this.leftEar, required this.rightEar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarCustom(title: 'PTA Results')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: ReusableContainerForButtons(containerChild: Center(child: Text('Patient Name',style: kWhiteButtonTextStyle,)),)),
          const Spacer(),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: const NumericAxis(),
              series: <CartesianSeries>[
                LineSeries<AudioData, double>(
                  dataSource: leftEar,
                  xValueMapper: (AudioData data, _) => data.freq,
                  yValueMapper: (AudioData data, _) => data.db,
                  name: 'Left Ear',
                ),
                LineSeries<AudioData, double>(
                  dataSource: rightEar,
                  xValueMapper: (AudioData data, _) => data.freq,
                  yValueMapper: (AudioData data, _) => data.db,
                  name: 'Right Ear',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}