import 'package:flutter/material.dart';

class VerticalSpacingWidget extends StatelessWidget {
  const VerticalSpacingWidget({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}