import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/widgets/app_loading_indicator.dart';
import 'package:carrypill/services/onboarding_prefs.dart';
import 'package:carrypill/presentations/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Splash + routes to onboarding or main app.
class Bootstrap extends StatefulWidget {
  const Bootstrap({super.key});

  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  @override
  void initState() {
    super.initState();
    _routeNext();
  }

  Future<void> _routeNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    final done = await OnboardingPrefs.isCompleted();
    if (!mounted) return;
    if (!done) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Wrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kcPrimary, Color(0xFF1A6B85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication_rounded, size: 72.sp, color: Colors.white),
            SizedBox(height: 16.h),
            Text(
              'CarryPill',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Medication pickup & delivery',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            SizedBox(height: 48.h),
            const AppLoadingIndicator(size: 36, center: false),
          ],
        ),
      ),
    );
  }
}
