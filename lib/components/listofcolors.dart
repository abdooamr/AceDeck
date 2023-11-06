import 'package:flutter/material.dart';

List<Color> toColors(String pattern) {
  switch (pattern) {
    case 'color1':
      return [
        const Color.fromARGB(255, 171, 134, 195),
        const Color.fromARGB(255, 159, 104, 195),
        const Color.fromARGB(255, 115, 3, 192),
      ];
    case 'color2':
      return [
        Color.fromARGB(255, 87, 27, 130),
        const Color.fromARGB(255, 195, 20, 50),
      ];
    default:
      return [];
  }
}
