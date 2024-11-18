import 'package:flutter/material.dart';
class AppColors {

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF8932E1), // Starting color (Hex: #8932E1)
      Color(0xFF140023), // Ending color (Hex: #140023)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color secondary = Color(0xFF4E0189); // Teal
  static const Color textPrimary = Color(0xFF757575); // Grey
}