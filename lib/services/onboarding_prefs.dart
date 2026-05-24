import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPrefs {
  // Versioned key: bump the suffix to force returning users back through
  // onboarding when the flow changes materially.
  static const _keyCompleted = 'onboarding_completed_v1';

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCompleted) ?? false;
  }

  static Future<void> setCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompleted, true);
  }
}
