import 'package:carrypill/services/locale_prefs.dart';
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _load();
  }

  Future<void> _load() async {
    _locale = await LocalePrefs.getLocale();
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale?.languageCode == locale.languageCode) return;
    _locale = locale;
    await LocalePrefs.setLocale(locale);
    notifyListeners();
  }
}
