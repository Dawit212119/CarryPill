import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalePrefs {
  static const _keyLanguageCode = 'app_locale_v1';

  static Future<Locale?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLanguageCode);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  static Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguageCode, locale.languageCode);
  }
}
