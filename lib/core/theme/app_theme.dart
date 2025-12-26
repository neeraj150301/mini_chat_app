import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF3B82F6), // Royal Blue
      // background: const Color(0xFFF3F4F6), // Light Grey
      surface: Colors.white,
      onSurface: Colors.black87,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF3F4F6),
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor:
          Colors.transparent, // For glass effect if needed, or just clean
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.black87),
    ),
  );
}
