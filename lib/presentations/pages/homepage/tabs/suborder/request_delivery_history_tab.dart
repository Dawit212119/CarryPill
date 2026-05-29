import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/presentations/pages/orders/order_history_list.dart';
import 'package:flutter/material.dart';

class RequestDeliveryHistoryTab extends StatelessWidget {
  const RequestDeliveryHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderHistoryList(
      serviceType: ServiceType.requestDelivery,
      emptyTitle: 'No delivery orders',
    );
  }
}
