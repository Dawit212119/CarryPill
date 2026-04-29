import 'login.dart';
import 'register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/constant_color.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);
  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcBgDark,
      body: SafeArea(
        child: Column(children: [
          SizedBox(height: 32.h),
          // Logo
          Container(
            width: 60.w, height: 60.w,
            decoration: BoxDecoration(color: kcAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(18.r)),
            child: Icon(Icons.medication_rounded, color: kcAccent, size: 32.sp),
          ),
          SizedBox(height: 14.h),
          Text('CarryPill', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w800, color: kcWhite)),
          SizedBox(height: 6.h),
          Text('Medication delivery for patients', style: TextStyle(fontSize: 13.sp, color: kcGreyLabel)),
          SizedBox(height: 28.h),

          // Tab switcher
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(14.r)),
              child: TabBar(
                controller: _tab,
                indicator: BoxDecoration(color: kcAccent, borderRadius: BorderRadius.circular(11.r)),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: kcBgDark,
                unselectedLabelColor: kcGreyLabel,
                labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                tabs: const [Tab(text: 'Sign In'), Tab(text: 'Sign Up')],
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // Form
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                color: kcCardDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                child: TabBarView(controller: _tab, children: [
                  Login(onGoToSignUp: () => _tab.animateTo(1)),
                  Register(onGoToSignIn: () => _tab.animateTo(0)),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
