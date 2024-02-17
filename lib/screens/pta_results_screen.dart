import 'package:flutter/material.dart';
import 'package:freq_fit/widgets/app_bar.dart';

class PtaResultsScreen extends StatelessWidget {
  const PtaResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(80),child: AppBarCustom(title: 'PTA RESULTS'),),
    );
  }
}