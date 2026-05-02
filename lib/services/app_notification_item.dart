import 'package:carrypill/core/utils/order_status_utils.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/data/models/order_service.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final String? orderId;
  final StatusOrder status;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.orderId,
    required this.status,
  });

  // Derives notification items from orders; orders without a documentID are
  // skipped since they can't be deep-linked back to a detail screen.
  static List<AppNotificationItem> fromOrders(List<OrderService> orders) {
    final items = <AppNotificationItem>[];
    for (final order in orders) {
      if (order.documentID == null) continue;
      final facility = order.facility?.facilityName ?? 'Your order';
      items.add(
        AppNotificationItem(
          id: order.documentID!,
          title: facility,
          body: OrderStatusUtils.label(order.statusOrder),
          time: order.orderDate ?? DateTime.now(),
          orderId: order.documentID,
          status: order.statusOrder,
        ),
      );
    }
    items.sort((a, b) => b.time.compareTo(a.time));
    return items;
  }
}
