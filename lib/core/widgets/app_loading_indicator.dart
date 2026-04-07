import 'package:carrypill/constants/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Branded loading indicator — works without Rive assets.
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final bool center;

  const AppLoadingIndicator({
    super.key,
    this.size = 48,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size.w,
      height: size.w,
      child: const CircularProgressIndicator(
        color: kcPrimary,
        strokeWidth: 3,
      ),
    );
    if (center) return Center(child: indicator);
    return indicator;
  }
}
