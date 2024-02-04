import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FreqDb extends ChangeNotifier{
  double _Freq = 100.0;
  double _Db = 10.0;

  double get Freq => _Freq;
  double get Db => _Db;

  void incrementFreq(){
    _Freq = _Freq + 100.0;
    notifyListeners();
  }

  void incrementDb(){
    _Db = _Db + 10.0;
    notifyListeners();
  }

  void decrementFreq(){
    _Freq = _Freq - 100.0;
    notifyListeners();
  }

  void decrementDb(){
    _Freq = _Freq - 10.0;
    notifyListeners();
  }

  final freqDbProvider = ChangeNotifierProvider<FreqDb>((ref) {
    return FreqDb();
  });

}