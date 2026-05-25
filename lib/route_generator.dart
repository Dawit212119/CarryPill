import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/presentations/pages/appointment/appointment_page.dart';
import 'package:carrypill/presentations/custom_widgets/error_page.dart';
import 'package:carrypill/presentations/pages/bootstrap.dart';
import 'package:carrypill/presentations/pages/homepage/tabs/subprofile/profile_info.dart';
import 'package:carrypill/presentations/pages/homepage/tabs/subhome/request_service.dart';
import 'package:carrypill/presentations/pages/notifications/notifications_page.dart';
import 'package:carrypill/presentations/pages/onboarding/onboarding_page.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/presentations/pages/orders/order_detail_page.dart';
import 'package:carrypill/presentations/pages/orders/order_tracking_page.dart';
import 'package:carrypill/presentations/pages/homepage/tabs/suborder/request_delivery_history_tab.dart';
import 'package:carrypill/presentations/pages/homepage/tabs/suborder/request_pickup_history_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => const Bootstrap());
      case '/onboarding':
        return CupertinoPageRoute(builder: (_) => const OnboardingPage());
      case '/requestservice':
        return CupertinoPageRoute(builder: (_) => const RequestDelivery());
      case '/profileinfo':
        return CupertinoPageRoute(
          builder: (_) => ProfileInfo(arg: args as Map<String, dynamic>),
        );
      case '/orderdetail':
        final map = args as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (_) => OrderDetailPage(order: map['order'] as OrderService),
        );
      case '/notifications':
        return CupertinoPageRoute(builder: (_) => const NotificationsPage());
      case '/orders':
        return CupertinoPageRoute(builder: (_) => const _StandaloneOrderTab());
      case '/appointment':
        final map = args as Map<String, dynamic>;
        return CupertinoPageRoute(builder: (_) => AppointmentPage(patient: map['patient'] as Patient));
      case '/trackorder':
        final map = args as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (_) => OrderTrackingPage(
            order: map['order'] as OrderService,
            patientLocation: map['patientLocation'] as GeoPoint?,
          ),
        );
      default:
        return CupertinoPageRoute(builder: (_) => const ErrorPage());
    }
  }
}

class _StandaloneOrderTab extends StatelessWidget {
  const _StandaloneOrderTab();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Delivery', icon: Icon(Icons.delivery_dining_rounded)),
              Tab(text: 'Pickup', icon: Icon(Icons.store_mall_directory_outlined)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RequestDeliveryHistoryTab(),
            RequestPickupHistoryTab(),
          ],
        ),
      ),
    );
  }
}
