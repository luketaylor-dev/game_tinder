import 'package:flutter/material.dart';

/// Reusable gradient icon container
class GradientIconContainer extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;

  const GradientIconContainer({
    super.key,
    required this.icon,
    this.size = 80,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(icon, size: iconSize, color: Colors.white),
    );
  }
}
