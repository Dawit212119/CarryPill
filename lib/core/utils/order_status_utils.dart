import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:flutter/material.dart';

class OrderStatusUtils {
  OrderStatusUtils._();

  // Maps internal order states to the short, patient-facing labels shown in
  // the tracking UI. Keep these in sync with the timeline flow.
  static String label(StatusOrder status) {
    switch (status) {
      case StatusOrder.noOrder:
        return 'Placed';
      case StatusOrder.findingDriver:
        return 'Finding rider';
      case StatusOrder.driverFound:
        return 'Rider assigned';
      case StatusOrder.driverToHospital:
        return 'Heading to hospital';
      case StatusOrder.driverQueue:
        return 'In pharmacy queue';
      case StatusOrder.orderPreparing:
        return 'Preparing medication';
      case StatusOrder.outForDelivery:
        return 'Out for delivery';
      case StatusOrder.orderArrived:
        return 'Delivered';
      case StatusOrder.orderCancelled:
        return 'Cancelled';
    }
  }

  static Color color(StatusOrder status) {
    switch (status) {
      case StatusOrder.orderArrived:
        return kcProfit;
      case StatusOrder.orderCancelled:
        return const Color(0xFFE53935);
      case StatusOrder.findingDriver:
        return kcOrange;
      case StatusOrder.outForDelivery:
      case StatusOrder.driverToHospital:
      case StatusOrder.driverQueue:
      case StatusOrder.orderPreparing:
      case StatusOrder.driverFound:
        return kcPrimary;
      default:
        return kcGreyLabel;
    }
  }

  static IconData icon(StatusOrder status) {
    switch (status) {
      case StatusOrder.findingDriver:
        return Icons.search_rounded;
      case StatusOrder.driverFound:
        return Icons.two_wheeler_rounded;
      case StatusOrder.driverToHospital:
        return Icons.local_hospital_outlined;
      case StatusOrder.driverQueue:
        return Icons.hourglass_top_rounded;
      case StatusOrder.orderPreparing:
        return Icons.medication_outlined;
      case StatusOrder.outForDelivery:
        return Icons.local_shipping_outlined;
      case StatusOrder.orderArrived:
        return Icons.check_circle_outline_rounded;
      case StatusOrder.orderCancelled:
        return Icons.cancel_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  static bool canCancel(StatusOrder status) {
    return status == StatusOrder.noOrder || status == StatusOrder.findingDriver;
  }

  static bool isActive(StatusOrder status) {
    return status != StatusOrder.orderArrived &&
        status != StatusOrder.orderCancelled;
  }
}
