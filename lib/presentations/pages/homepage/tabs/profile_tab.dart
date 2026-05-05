import 'package:carrypill/business_logic/provider/patient_provider.dart';
import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/data/models/clinic.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:carrypill/data/repositories/supabase_repo/auth_repo.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  Patient patient;
  ProfileTab({Key? key, required this.patient}) : super(key: key);
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Patient get patient => widget.patient;
  late List<Clinic> clinicList;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    clinicList = widget.patient.clinicList;
    _selectedDay = widget.patient.appointment;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.patient != widget.patient) {
      setState(() {
        clinicList = widget.patient.clinicList;
        _selectedDay = widget.patient.appointment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PatientUid auth = Provider.of<PatientUid>(context);

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

              // Header
              Row(children: [
                Text('Profile', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: kcWhite, letterSpacing: -0.5)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/profileinfo', arguments: {'patient': patient}),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(color: kcAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8.r)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('Edit Profile', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: kcAccent)),
                      SizedBox(width: 4.w),
                      Icon(Icons.edit_rounded, color: kcAccent, size: 14.sp),
                    ]),
                  ),
                ),
              ]),

              SizedBox(height: 24.h),

              // Profile card with avatar
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(20.r)),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(patient.name, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: kcWhite)),
                    SizedBox(height: 6.h),
                    Text(patient.phoneNum.isNotEmpty ? patient.phoneNum : 'No phone set',
                      style: TextStyle(fontSize: 13.sp, color: kcGreyLabel)),
                    if (patient.address != null && patient.address!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(patient.address!, style: TextStyle(fontSize: 12.sp, color: kcGreyLabel),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ])),
                  Container(
                    width: 56.w, height: 56.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kcAccent.withValues(alpha: 0.15),
                      image: patient.profileImageUrl != null ? DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(patient.profileImageUrl!)) : null,
                    ),
                    child: patient.profileImageUrl == null ? Center(
                      child: Text(patient.name.isNotEmpty ? patient.name[0].toUpperCase() : 'P',
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: kcAccent)),
                    ) : null,
                  ),
                ]),
              ),

              SizedBox(height: 14.h),

              // Two info cards side by side (like Diabetes type / Blood type)
              Row(children: [
                Expanded(child: _InfoCard(label: 'Patient ID', value: patient.patientId ?? 'Not set')),
                SizedBox(width: 12.w),
                Expanded(child: _InfoCard(label: 'IC Number', value: patient.icNum.isNotEmpty ? patient.icNum : 'Not set')),
              ]),

              SizedBox(height: 24.h),

              // Clinics section
              _SectionHeader(title: 'Follow Up Clinics', trailing: '${clinicList.where((c) => c.status).length} selected'),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  children: clinicList.asMap().entries.map((e) {
                    final i = e.key;
                    final c = e.value;
                    return Column(children: [
                      InkWell(
                        onTap: () => setState(() => clinicList[i].status = !clinicList[i].status),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          child: Row(children: [
                            Container(
                              width: 22.w, height: 22.w,
                              decoration: BoxDecoration(
                                color: c.status ? kcAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: c.status ? kcAccent : kcGreyLabel, width: 1.5),
                              ),
                              child: c.status ? Icon(Icons.check_rounded, color: kcBgDark, size: 15.sp) : null,
                            ),
                            SizedBox(width: 14.w),
                            Text(c.clinicName, style: TextStyle(fontSize: 14.sp, color: kcWhite, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                      ),
                      if (i < clinicList.length - 1) Divider(color: kcBorder, height: 1, indent: 52.w),
                    ]);
                  }).toList(),
                ),
              ),

              SizedBox(height: 24.h),

              // Additional section (like Go Premium, Health info, Settings)
              _SectionHeader(title: 'Additional'),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(16.r)),
                child: Column(children: [
                  _ListTile(icon: Icons.save_rounded, label: 'Save Profile', onTap: () async {
                    if (_selectedDay != null || !clinicList.every((e) => e.status == false)) {
                      if (_selectedDay != null) await DatabaseRepo(uid: auth.uid).updateAppointment(_selectedDay!);
                      await DatabaseRepo(uid: auth.uid).updateClinic(clinicList);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select appointment or clinic first')));
                    }
                  }),
                  Divider(color: kcBorder, height: 1, indent: 56.w),
                  _ListTile(icon: Icons.history_rounded, label: 'Order History', onTap: () => Navigator.of(context).pushNamed('/orders')),
                  Divider(color: kcBorder, height: 1, indent: 56.w),
                  _ListTile(icon: Icons.logout_rounded, label: 'Sign Out', color: kcRed, onTap: () => AuthRepo().logout()),
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

class _InfoCard extends StatelessWidget {
  final String label, value;
  const _InfoCard({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(14.r)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 12.sp, color: kcGreyLabel)),
        SizedBox(height: 6.h),
        Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: kcWhite)),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  const _SectionHeader({required this.title, this.trailing});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: kcWhite)),
      if (trailing != null) ...[const Spacer(), Text(trailing!, style: TextStyle(fontSize: 12.sp, color: kcGreyLabel))],
    ]);
  }
}

class _ListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _ListTile({required this.icon, required this.label, this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = color ?? kcWhite;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(children: [
          Container(
            width: 34.w, height: 34.w,
            decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
            child: Icon(icon, color: c, size: 18.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: c))),
          Icon(Icons.chevron_right_rounded, color: kcGreyLabel, size: 20.sp),
        ]),
      ),
    );
  }
}
