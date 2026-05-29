import 'package:carrypill/business_logic/provider/order_provider.dart';
import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/constants/constant_widget.dart';
import 'package:carrypill/core/utils/patient_profile_utils.dart';
import 'package:carrypill/core/widgets/home_promo_section.dart';
import 'package:carrypill/core/widgets/profile_completion_banner.dart';
import 'package:carrypill/core/widgets/service_action_card.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTab extends StatefulWidget {
  final Patient patient;

  const HomeTab({super.key, required this.patient});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Patient patient;

  @override
  void initState() {
    super.initState();
    patient = widget.patient;
  }

  void _openProfile() {
    Navigator.of(context).pushNamed(
      '/profileinfo',
      arguments: {'patient': patient},
    );
  }

  void _startOrder(ServiceType type) {
    final uid = Provider.of<PatientUid?>(context, listen: false);
    if (uid?.uid == null) return;

    if (!PatientProfileUtils.isComplete(patient)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Complete your profile (${PatientProfileUtils.missingFields(patient).join(', ')}) before ordering.',
          ),
          action: SnackBarAction(
            label: 'Profile',
            textColor: kcLightYellow,
            onPressed: _openProfile,
          ),
        ),
      );
      return;
    }

    final order = Provider.of<OrderProvider>(context, listen: false);
    order.setServiceType(type);
    order.setPatientRef(uid!.uid!);
    Navigator.of(context).pushNamed('/requestservice');
  }

  @override
  Widget build(BuildContext context) {
    final firstName = patient.name.trim().split(' ').first;
    final displayName =
        firstName.isEmpty || firstName == 'Patient' ? 'there' : firstName;

    return ColoredBox(
      color: kcBgHome1,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kcPrimary, Color(0xFF1A6B85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20.w, 48.h, 20.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, $displayName',
                              style: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Medication pickup & delivery',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Order updates',
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/notifications'),
                        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_rounded, color: kcLightYellow, size: 20.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          patient.address?.trim().isNotEmpty == true
                              ? patient.address!
                              : 'Add your address for accurate delivery',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.95),
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileCompletionBanner(
              patient: patient,
              onCompleteProfile: _openProfile,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ServiceActionCard(
                  title: 'Request pickup',
                  subtitle: 'We collect your medication from the hospital pharmacy.',
                  icon: Icons.store_mall_directory_outlined,
                  gradient: const [kcPrimary, Color(0xFF2A7A96)],
                  onTap: () => _startOrder(ServiceType.requestPickup),
                ),
                SizedBox(height: 12.h),
                ServiceActionCard(
                  title: 'Request delivery',
                  subtitle: 'Medication delivered safely to your home.',
                  icon: Icons.home_work_outlined,
                  gradient: const [Color(0xFFE86A00), kcOrange],
                  onTap: () => _startOrder(ServiceType.requestDelivery),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: HomePromoSection()),
          SliverToBoxAdapter(child: gaphr(h: 24)),
        ],
      ),
    );
  }
}
