import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FreqDb extends ChangeNotifier{
  double _freq = 100.0;
  double _db = 10.0;

  double get freq => _freq;
  double get db => _db;

  void incrementFreq(){
    _freq = _freq + 100.0;
    notifyListeners();
  }

  void incrementDb(){
    _db = _db + 10.0;
    notifyListeners();
  }

  void decrementFreq(){
    _freq = _freq - 100.0;
    notifyListeners();
  }

  void decrementDb(){
    _db = _db - 10.0;
    notifyListeners();
  }



}

final freqDbProvider = ChangeNotifierProvider<FreqDb>((ref) {
  return FreqDb();
});