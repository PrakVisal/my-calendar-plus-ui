import 'package:flutter/material.dart';

/// A row of small colored dots representing the categories/colors of events on a given day.
class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    required this.colors,
    this.maxDots = 4,
  });

  final List<Color> colors;
  final int maxDots;

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) return const SizedBox(height: 6);

    final displayColors = colors.take(maxDots).toList();

    return SizedBox(
      height: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: displayColors.map((color) {
          return Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          );
        }).toList(),
      ),
    );
  }
}
