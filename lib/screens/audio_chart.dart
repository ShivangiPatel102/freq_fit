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
      appBar: AppBar(
        title: Text('Audio Data Charts'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(),
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
      ),
    );
  }
}