import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/presentations/custom_widgets/error_page.dart';
import 'package:carrypill/presentations/pages/bootstrap.dart';
import 'package:carrypill/presentations/pages/homepage/tabs/subprofile/profile_info.dart';
import 'package:carrypill/presentations/pages/homepage/tabs/subhome/request_service.dart';
import 'package:carrypill/presentations/pages/notifications/notifications_page.dart';
import 'package:carrypill/presentations/pages/onboarding/onboarding_page.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/presentations/pages/orders/order_detail_page.dart';
import 'package:carrypill/presentations/pages/orders/order_tracking_page.dart';
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
