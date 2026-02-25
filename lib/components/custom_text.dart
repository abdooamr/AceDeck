import 'package:flutter/material.dart';

class textcustom extends StatelessWidget {
  final String data;
  final double size;

  const textcustom({
    super.key,
    required this.data,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      data,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
