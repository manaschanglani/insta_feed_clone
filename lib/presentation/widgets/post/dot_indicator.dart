import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int count;
  final int index;

  const DotIndicator({
    super.key,
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == index ? Colors.blue : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}