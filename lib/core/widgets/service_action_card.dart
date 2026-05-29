import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const ServiceActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: Colors.white, size: 32.sp),
              ),
              SizedBox(height: 20.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.35,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Text(
                    'Get started',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18.sp),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
