import 'package:flutter/material.dart';

class HorizontalSpacingWidget extends StatelessWidget {
  const HorizontalSpacingWidget({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
