import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';

class ContainerDisplayingFqAndDb extends StatelessWidget {
  const ContainerDisplayingFqAndDb({
    super.key,
    required this.number,
    required this.unit,
  });
  final double number;
  final String unit;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$number',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: kNavyBlueColor),
          ),
          Spacer(),
          Text(
            '$unit',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: kNavyBlueColor),
          ),
        ],
      ),
    );
  }
}
