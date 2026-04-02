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

class _AuthenticateState extends State<Authenticate>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kcPrimary.withValues(alpha: 0.92),
                  kcPrimary.withValues(alpha: 0.97),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildTabSwitcher(),
                SizedBox(height: 16.h),
                Expanded(child: _buildFormCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: kcWhite.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: kcWhite.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.medical_services_rounded,
              color: kcLightYellow,
              size: 34.sp,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'CarryPill',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: kcWhite,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Medication delivery for follow-up patients',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: kcWhite.withValues(alpha: 0.85),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: kcWhite.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: kcWhite.withValues(alpha: 0.2)),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: kcWhite,
            borderRadius: BorderRadius.circular(11.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: kcPrimary,
          unselectedLabelColor: kcWhite.withValues(alpha: 0.9),
          labelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Sign In'),
            Tab(text: 'Sign Up'),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kcWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        child: TabBarView(
          controller: _tabController,
          children: [
            Login(onGoToSignUp: () => _tabController.animateTo(1)),
            Register(onGoToSignIn: () => _tabController.animateTo(0)),
          ],
        ),
      ),
    );
  }
}
