import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/presentations/pages/wrapper.dart';
import 'package:carrypill/services/onboarding_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      icon: Icons.medication_liquid_outlined,
      title: 'Hospital medication,\nsimplified',
      body:
          'Book pharmacy pickup or home delivery after your follow-up visit — no more long queues.',
      color: kcPrimary,
    ),
    _Slide(
      icon: Icons.local_shipping_outlined,
      title: 'Track every step',
      body:
          'See when your rider is assigned, in queue at the pharmacy, and on the way to you.',
      color: Color(0xFF2A7A96),
    ),
    _Slide(
      icon: Icons.verified_user_outlined,
      title: 'Built for patients',
      body:
          'Secure profile, clinic checklist, and appointment reminders — all in one app.',
      color: kcOrange,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await OnboardingPrefs.setCompleted();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Wrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcBgHome1,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  'Skip',
                  style: TextStyle(color: kcGreyLabel, fontSize: 14.sp),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => Container(
                  width: _page == i ? 24.w : 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: _page == i ? kcPrimary : kcGreyLabel.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              child: FilledButton(
                onPressed: () {
                  if (_page < _slides.length - 1) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  } else {
                    _finish();
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 52.h),
                  backgroundColor: kcPrimary,
                ),
                child: Text(
                  _page < _slides.length - 1 ? 'Next' : 'Get started',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  final IconData icon;
  final String title;
  final String body;
  final Color color;

  const _Slide({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });
}

class _SlideView extends StatelessWidget {
  final _Slide slide;

  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: slide.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 72.sp, color: slide.color),
          ),
          SizedBox(height: 40.h),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: kctextDark,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            slide.body,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.sp, color: kctextgrey, height: 1.45),
          ),
        ],
      ),
    );
  }
}
