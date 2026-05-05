import 'package:carrypill/business_logic/provider/order_provider.dart';
import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/utils/patient_profile_utils.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class HomeTab extends StatelessWidget {
  final Patient patient;
  const HomeTab({super.key, required this.patient});

  void _openProfile(BuildContext ctx) =>
      Navigator.of(ctx).pushNamed('/profileinfo', arguments: {'patient': patient});

  void _startOrder(BuildContext ctx, ServiceType type) {
    final uid = Provider.of<PatientUid?>(ctx, listen: false);
    if (uid?.uid == null) return;
    if (!PatientProfileUtils.isComplete(patient)) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Complete your profile first'),
        action: SnackBarAction(label: 'Go', textColor: kcAccent, onPressed: () => _openProfile(ctx)),
      ));
      return;
    }
    final order = Provider.of<OrderProvider>(ctx, listen: false);
    order.setServiceType(type);
    order.setPatientRef(uid!.uid!);
    Navigator.of(ctx).pushNamed('/requestservice');
  }

  @override
  Widget build(BuildContext context) {
    final firstName = patient.name.trim().split(' ').first;
    final name = firstName.isEmpty || firstName == 'Patient' ? 'there' : firstName;
    final now = DateTime.now();
    final dayNames = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final monthNames = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final profilePct = PatientProfileUtils.completionPercent(patient);

    return Scaffold(
      backgroundColor: kcBgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // ── Header ──
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Hi, $name!', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: kcWhite, letterSpacing: -0.5)),
                  SizedBox(height: 4.h),
                  Text('${dayNames[now.weekday - 1]}, ${now.day} ${monthNames[now.month]}',
                    style: TextStyle(fontSize: 14.sp, color: kcGreyLabel)),
                ])),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/notifications'),
                  child: Container(width: 44.w, height: 44.w,
                    decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(14.r)),
                    child: Icon(Icons.notifications_none_rounded, color: kcWhite, size: 22.sp)),
                ),
              ]),

              SizedBox(height: 24.h),

              // ── Summary Card (like the "Eaten" card) ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(20.r)),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Profile', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: kcWhite)),
                    SizedBox(height: 8.h),
                    RichText(text: TextSpan(children: [
                      TextSpan(text: '$profilePct%', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: kcAccent)),
                      TextSpan(text: ' complete', style: TextStyle(fontSize: 14.sp, color: kcGreyLabel)),
                    ])),
                    SizedBox(height: 6.h),
                    Text(profilePct >= 100 ? 'Ready to order!' : 'Tap to finish setup',
                      style: TextStyle(fontSize: 12.sp, color: kcGreyLabel)),
                    if (profilePct < 100) ...[
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () => _openProfile(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(color: kcAccent, borderRadius: BorderRadius.circular(8.r)),
                          child: Text('Complete', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: kcBgDark)),
                        ),
                      ),
                    ],
                  ])),
                  SizedBox(width: 16.w),
                  // Circular progress ring
                  SizedBox(
                    width: 80.w, height: 80.w,
                    child: CustomPaint(
                      painter: _RingPainter(profilePct / 100, kcAccent),
                      child: Center(child: Text('$profilePct%',
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: kcWhite))),
                    ),
                  ),
                ]),
              ),

              SizedBox(height: 20.h),

              // ── 2x2 Stat Cards (like Glucose, Pills, Activity, Carbs) ──
              Row(children: [
                Expanded(child: _StatCard(
                  emoji: '🏥', label: 'Pickup', value: 'Pharmacy',
                  onTap: () => _startOrder(context, ServiceType.requestPickup),
                )),
                SizedBox(width: 12.w),
                Expanded(child: _StatCard(
                  emoji: '🛵', label: 'Delivery', value: 'Home',
                  onTap: () => _startOrder(context, ServiceType.requestDelivery),
                )),
              ]),
              SizedBox(height: 12.h),
              Row(children: [
                Expanded(child: _StatCard(
                  emoji: '📅', label: 'Appointment', value: patient.appointment != null
                    ? '${patient.appointment!.day}/${patient.appointment!.month}' : 'Not set',
                  onTap: () => Navigator.of(context).pushNamed('/appointment', arguments: {'patient': patient}),
                )),
                SizedBox(width: 12.w),
                Expanded(child: _StatCard(
                  emoji: '📋', label: 'Orders', value: 'History',
                  onTap: () => Navigator.of(context).pushNamed('/orders'),
                )),
              ]),

              SizedBox(height: 28.h),

              // ── Info Section (like Blood Sugar chart area) ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(20.r)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('Quick Tips', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: kcWhite)),
                    const Spacer(),
                    Text('CarryPill', style: TextStyle(fontSize: 12.sp, color: kcGreyLabel)),
                  ]),
                  SizedBox(height: 16.h),
                  _TipItem(icon: Icons.qr_code_scanner_rounded, color: kcOrange, text: 'Upload queue token for faster pickup'),
                  Divider(color: kcBorder, height: 24.h),
                  _TipItem(icon: Icons.gps_fixed_rounded, color: kcAccent, text: 'Enable GPS for accurate delivery'),
                  Divider(color: kcBorder, height: 24.h),
                  _TipItem(icon: Icons.medication_rounded, color: kcPurple, text: 'Set clinic follow-ups in your profile'),
                ]),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

// Circular progress ring painter
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _RingPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final bgPaint = Paint()..color = kcBorder..style = PaintingStyle.stroke..strokeWidth = 8..strokeCap = StrokeCap.round;
    final fgPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 8..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}

// Stat card like Glucose/Pills/Activity/Carbs
class _StatCard extends StatelessWidget {
  final String emoji, label, value;
  final VoidCallback onTap;
  const _StatCard({required this.emoji, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(16.r)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: kcGreyLabel)),
            const Spacer(),
            Text(emoji, style: TextStyle(fontSize: 22.sp)),
          ]),
          SizedBox(height: 12.h),
          Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: kcWhite)),
        ]),
      ),
    );
  }
}

// Tip row item
class _TipItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _TipItem({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 36.w, height: 36.w,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10.r)),
        child: Icon(icon, color: color, size: 18.sp),
      ),
      SizedBox(width: 12.w),
      Expanded(child: Text(text, style: TextStyle(fontSize: 13.sp, color: kcWhite.withValues(alpha: 0.8)))),
    ]);
  }
}
