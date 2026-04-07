import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/utils/patient_profile_utils.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCompletionBanner extends StatelessWidget {
  final Patient patient;
  final VoidCallback onCompleteProfile;

  const ProfileCompletionBanner({
    super.key,
    required this.patient,
    required this.onCompleteProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (PatientProfileUtils.isComplete(patient)) {
      return const SizedBox.shrink();
    }

    final percent = PatientProfileUtils.completionPercent(patient);
    final missing = PatientProfileUtils.missingFields(patient);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onCompleteProfile,
          borderRadius: BorderRadius.circular(16.r),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kcOrange.withValues(alpha: 0.12),
                  kcPrimary.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: kcOrange.withValues(alpha: 0.35)),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment_outlined, color: kcPrimary, size: 22.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Complete your profile',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: kctextDark,
                        ),
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: kcOrange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 5.h,
                    backgroundColor: kcWhite,
                    color: kcOrange,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Add ${missing.take(2).join(', ')}${missing.length > 2 ? '…' : ''} before your first order.',
                  style: TextStyle(fontSize: 12.sp, color: kctextgrey, height: 1.35),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Continue →',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: kcPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
