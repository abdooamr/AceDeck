import 'package:flutter/material.dart';

class customalertdialog extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final String content;

  const customalertdialog({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: isDark
          ? const Color(0xFF1A1A2E)
          : Theme.of(context).dialogTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.white.withValues(alpha: isDark ? 0.15 : 0.0),
          width: 1.2,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : null,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: isDark ? Colors.white70 : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'No',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white54 : null,
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Yes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
