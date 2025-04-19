import 'package:flutter/material.dart';

class TrackerTheme {
  static Color primary = const Color(0xFF1d61e7);
  static Color secondary = const Color(0xFF4b81ec);
  static Color green = const Color(0xFF001f40);
  static Color orange = const Color(0xFFFFA500);
  static Color red = const Color(0xFFFF0000);
  static Color white = const Color(0xFFFFFFFF);
  static Color black = const Color(0xFF000000);
  static Color grey = const Color(0xFF808080);
  static Color lightGrey = const Color(0xFFD3D3D3);
  static Color background = const Color(0xFFF6F8FA);
}

class AppTextStyles {
  static TextStyle heading = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );
  static TextStyle title = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  static TextStyle body = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static TextStyle label = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
  static TextStyle button = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

///
/// Definition of App spacings, in pixels.
/// Bascially small (S), medium (m), large (l), extra large (x), extra extra large (xxl)
///
class AppSpacings {
  static const double s = 12;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 40;

  static const double radius = 16;
  static const double radiusLarge = 24;
}

class DertamSize {
  static const double icon = 24;
}

///
/// Definition of App Theme.
///
ThemeData appTheme = ThemeData(
  fontFamily: 'Eesti',
  scaffoldBackgroundColor: Colors.white,
);
