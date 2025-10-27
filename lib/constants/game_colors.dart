import 'package:flutter/material.dart';

/// Game color constants
class GameColors {
  static const List<Color> colors = [
    Color(0xFFEF4444), // Red
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Orange
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Cyan
    Color(0xFF84CC16), // Lime
  ];

  static Color getColor(int index) {
    return colors[index % colors.length];
  }
}

