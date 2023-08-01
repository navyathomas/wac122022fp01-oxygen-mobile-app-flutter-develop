import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'font_palette.dart';

class ColorPalette {
  static ThemeData get themeData => ThemeData(
      primarySwatch: ColorPalette.materialPrimary,
      fontFamily: FontPalette.themeFont,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return ColorPalette.primaryColor;
              } else if (states.contains(MaterialState.disabled)) {
                return ColorPalette.primaryColor;
              }
              return ColorPalette.primaryColor;
            },
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark)),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.black));

  static Color get primaryColor => const Color(0xFFE50019);

  static Color get primaryShadowColor => const Color(0xFFFACCD1);

  static Color get secondaryColor => const Color(0xFFE50019);

  static Color get pageBgColor => const Color(0xFFF2F4F5);

  static Color get shimmerHighlightColor => shimmerBaseColor.withOpacity(0.5);

  static Color get shimmerBaseColor => const Color(0xFFF4F4F4);

  static Color get redColor => const Color(0xFFE50019);

  static const MaterialColor materialPrimary = MaterialColor(
    0xFFE50019,
    <int, Color>{
      50: Color(0xFFE50019),
      100: Color(0xFFE50019),
      200: Color(0xFFE50019),
      300: Color(0xFFE50019),
      400: Color(0xFFE50019),
      500: Color(0xFFE50019),
      600: Color(0xFFE50019),
      700: Color(0xFFE50019),
      800: Color(0xFFE50019),
      900: Color(0xFFE50019),
    },
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
