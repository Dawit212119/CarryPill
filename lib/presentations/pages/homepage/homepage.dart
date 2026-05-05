import 'package:carrypill/business_logic/provider/patient_provider.dart';
import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:provider/provider.dart';
import 'tabs/home_tab.dart';
import 'tabs/order_tab.dart';
import 'tabs/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  final Patient patient;
  const HomePage({super.key, required this.patient});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _i = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientProvider>(context, listen: false).updatePatient(widget.patient);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcBgDark,
      body: IndexedStack(index: _i, children: [
        HomeTab(key: ValueKey('h_${widget.patient.hashCode}'), patient: widget.patient),
        const OrderTab(),
        ProfileTab(key: ValueKey('p_${widget.patient.hashCode}'), patient: widget.patient),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: kcCardDark),
        padding: EdgeInsets.only(top: 8.h),
        child: SafeArea(
          child: SizedBox(
            height: 56.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavBtn(icon: Icons.home_rounded, active: _i == 0, onTap: () => setState(() => _i = 0)),
                _NavBtn(icon: Icons.receipt_long_rounded, active: _i == 1, onTap: () => setState(() => _i = 1)),
                // Center accent button
                GestureDetector(
                  onTap: () => setState(() => _i = 0),
                  child: Container(
                    width: 48.w, height: 48.w,
                    decoration: BoxDecoration(color: kcAccent, borderRadius: BorderRadius.circular(16.r)),
                    child: Icon(Icons.add_rounded, color: kcBgDark, size: 26.sp),
                  ),
                ),
                _NavBtn(icon: Icons.chat_bubble_outline_rounded, active: false, onTap: () => Navigator.of(context).pushNamed('/notifications')),
                _NavBtn(icon: Icons.person_rounded, active: _i == 2, onTap: () => setState(() => _i = 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 48.w,
        child: Icon(icon, size: 24.sp, color: active ? kcAccent : kcGreyLabel),
      ),
    );
  }
}
