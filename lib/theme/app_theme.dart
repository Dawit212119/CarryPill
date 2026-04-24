import 'package:carrypill/constants/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kcBgDark,
      colorSchemeSeed: kcAccent,
      appBarTheme: const AppBarTheme(
        elevation: 0, scrolledUnderElevation: 0,
        backgroundColor: kcBgDark, foregroundColor: kctextDark,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
      ),
      cardTheme: CardThemeData(elevation: 0, color: kcCardDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), margin: EdgeInsets.zero),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        backgroundColor: kcAccent, foregroundColor: kcBgDark, elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      )),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: kcCardDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: kcBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: kcBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: kcAccent, width: 1.5)),
        hintStyle: const TextStyle(color: kcGreyLabel),
      ),
      snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      dividerTheme: const DividerThemeData(color: kcDivider, thickness: 1),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: kcCardDark),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: kcCardDark),
      dialogTheme: DialogThemeData(backgroundColor: kcCardDark),
    );
  }
}
