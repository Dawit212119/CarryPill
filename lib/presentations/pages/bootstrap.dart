import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/services/onboarding_prefs.dart';
import 'package:carrypill/presentations/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bootstrap extends StatefulWidget {
  const Bootstrap({super.key});
  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    _routeNext();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _routeNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    final done = await OnboardingPrefs.isCompleted();
    if (!mounted) return;
    if (!done) { Navigator.of(context).pushReplacementNamed('/onboarding'); return; }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcBgDark,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 80.w, height: 80.w,
              decoration: BoxDecoration(color: kcAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(24.r)),
              child: Icon(Icons.medication_rounded, size: 44.sp, color: kcAccent),
            ),
            SizedBox(height: 20.h),
            Text('CarryPill', style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800, color: kcWhite, letterSpacing: -0.5)),
            SizedBox(height: 8.h),
            Text('Medication pickup & delivery', style: TextStyle(fontSize: 14.sp, color: kcGreyLabel)),
            SizedBox(height: 48.h),
            SizedBox(width: 28.w, height: 28.w, child: const CircularProgressIndicator(color: kcAccent, strokeWidth: 2.5)),
          ]),
        ),
      ),
    );
  }
}
