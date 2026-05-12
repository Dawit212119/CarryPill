import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/constants/constant_widget.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentPage extends StatefulWidget {
  final Patient patient;
  const AppointmentPage({super.key, required this.patient});
  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _doctorCon = TextEditingController();
  final _reasonCon = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.patient.appointment;
  }

  Future<void> _save() async {
    if (_selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }
    final uid = Provider.of<PatientUid>(context, listen: false).uid;
    setState(() => _saving = true);
    try {
      await DatabaseRepo(uid: uid).updateAppointment(_selectedDay!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment saved')));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final prev = widget.patient.appointment;

    return Scaffold(
      backgroundColor: kcBgDark,
      appBar: AppBar(
        backgroundColor: kcBgDark, elevation: 0, scrolledUnderElevation: 0,
        foregroundColor: kcWhite,
        title: Text('Appointment', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? SizedBox(width: 18.w, height: 18.w, child: const CircularProgressIndicator(color: kcAccent, strokeWidth: 2))
                : Text('Save', style: TextStyle(color: kcAccent, fontWeight: FontWeight.w700, fontSize: 14.sp)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),

            // Previous appointment
            if (prev != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: kcAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14.r)),
                child: Row(children: [
                  Container(
                    width: 40.w, height: 40.w,
                    decoration: BoxDecoration(color: kcAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12.r)),
                    child: Icon(Icons.history_rounded, color: kcAccent, size: 20.sp),
                  ),
                  SizedBox(width: 14.w),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Current Appointment', style: TextStyle(fontSize: 12.sp, color: kcGreyLabel)),
                    SizedBox(height: 4.h),
                    Text(DateFormat('EEEE, d MMMM yyyy').format(prev),
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: kcAccent)),
                  ]),
                ]),
              ),
              SizedBox(height: 20.h),
            ],

            // Date picker
            Text('Select Date', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: kcWhite)),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(18.r)),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.now().subtract(const Duration(days: 30)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (sel, foc) => setState(() { _selectedDay = sel; _focusedDay = foc; }),
                onPageChanged: (foc) => _focusedDay = foc,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: kcWhite),
                  leftChevronIcon: Icon(Icons.chevron_left_rounded, color: kcWhite, size: 24.sp),
                  rightChevronIcon: Icon(Icons.chevron_right_rounded, color: kcWhite, size: 24.sp),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontSize: 12.sp, color: kcGreyLabel, fontWeight: FontWeight.w600),
                  weekendStyle: TextStyle(fontSize: 12.sp, color: kcGreyLabel, fontWeight: FontWeight.w600),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: kcAccent.withValues(alpha: 0.2), shape: BoxShape.circle),
                  todayTextStyle: TextStyle(fontSize: 14.sp, color: kcAccent, fontWeight: FontWeight.w700),
                  selectedDecoration: const BoxDecoration(color: kcAccent, shape: BoxShape.circle),
                  selectedTextStyle: TextStyle(fontSize: 14.sp, color: kcBgDark, fontWeight: FontWeight.w700),
                  defaultTextStyle: TextStyle(fontSize: 14.sp, color: kcWhite),
                  weekendTextStyle: TextStyle(fontSize: 14.sp, color: kcWhite),
                  outsideTextStyle: TextStyle(fontSize: 14.sp, color: kcGreyLabel.withValues(alpha: 0.4)),
                  disabledTextStyle: TextStyle(fontSize: 14.sp, color: kcGreyLabel.withValues(alpha: 0.3)),
                ),
              ),
            ),

            if (_selectedDay != null) ...[
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(12.r)),
                child: Row(children: [
                  Icon(Icons.event_available_rounded, color: kcAccent, size: 20.sp),
                  SizedBox(width: 10.w),
                  Text(DateFormat('EEEE, d MMMM yyyy').format(_selectedDay!),
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: kcWhite)),
                ]),
              ),
            ],

            SizedBox(height: 24.h),

            // Doctor / Clinic
            Text('Doctor / Clinic', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: kcWhite)),
            SizedBox(height: 12.h),
            _DarkField(controller: _doctorCon, hint: 'e.g. Dr. Abebe - ENT Clinic', icon: Icons.medical_services_outlined),

            SizedBox(height: 20.h),

            // Reason
            Text('Reason for Visit', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: kcWhite)),
            SizedBox(height: 12.h),
            _DarkField(controller: _reasonCon, hint: 'e.g. Follow-up checkup, medication refill', icon: Icons.notes_rounded, lines: 3),

            SizedBox(height: 32.h),

            // Save button
            SizedBox(
              width: double.infinity, height: 52.h,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kcAccent, foregroundColor: kcBgDark, elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                ),
                child: Text('Save Appointment', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int lines;
  const _DarkField({required this.controller, required this.hint, required this.icon, this.lines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: lines,
      style: TextStyle(fontSize: 14.sp, color: kcWhite, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        prefixIcon: lines == 1 ? Icon(icon, color: kcGreyLabel, size: 20.sp) : null,
        hintText: hint,
        hintStyle: TextStyle(color: kcGreyLabel, fontSize: 13.sp),
        filled: true, fillColor: kcCardDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide(color: kcBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide(color: kcBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide(color: kcAccent, width: 1.5)),
      ),
    );
  }
}
