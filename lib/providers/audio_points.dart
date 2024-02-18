import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freq_fit/models/AudioData.dart';

class AudioPoints extends ChangeNotifier {

  List<AudioData> leftEarPoints = [];
  List<AudioData> rightEarPoints = [];
  
  void setLeftEarPoints(List<AudioData> leftEarPoints) {
    leftEarPoints = leftEarPoints;
    notifyListeners();
  }
  void setBookingData(List<AudioData> rightEarPoints) {
    rightEarPoints = rightEarPoints;
    notifyListeners();
  }
  
}


final audioDataPointsProvider = ChangeNotifierProvider<AudioPoints>((ref) {
  return AudioPoints();
});