import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/data/models/clinic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Summary of selected follow-up departments (medication checklist).
class ClinicMedicationChecklist extends StatelessWidget {
  final List<Clinic> clinics;

  const ClinicMedicationChecklist({super.key, required this.clinics});

  int get _selectedCount => clinics.where((c) => c.status).length;

  @override
  Widget build(BuildContext context) {
    final selected = clinics.where((c) => c.status).toList();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: kcPrimary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: kcPrimary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medication_outlined, size: 20.sp, color: kcPrimary),
              SizedBox(width: 8.w),
              Text(
                'Medication checklist',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: kcPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$_selectedCount selected',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: kcOrange),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Select departments you visited so the pharmacy can prepare the right medications.',
            style: TextStyle(fontSize: 11.sp, color: kctextgrey, height: 1.35),
          ),
          if (selected.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: selected
                  .map(
                    (c) => Chip(
                      label: Text(c.clinicName, style: TextStyle(fontSize: 11.sp)),
                      backgroundColor: kcWhite,
                      side: BorderSide(color: kcPrimary.withValues(alpha: 0.3)),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
