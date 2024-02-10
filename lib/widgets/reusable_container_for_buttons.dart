import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';

class ReusableContainerForButtons extends StatelessWidget {
  const ReusableContainerForButtons({
    super.key,
    @required this.containerChild,
    @required this.colour,
    @required this.padding,
    @required this.margin,
    @required this.width,
  });

  final Widget? containerChild;
  final Color? colour;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(0),
      margin: margin ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: colour ?? kNavyBlueColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            20,
          ),
        ),
      ),
      child: containerChild,
    );
  }
}
