import 'package:carrypill/core/utils/order_status_utils.dart';
import 'package:carrypill/data/models/all_enum.dart';

class OrderTimelineStep {
  final StatusOrder status;
  final String label;
  final bool isComplete;
  final bool isCurrent;

  const OrderTimelineStep({
    required this.status,
    required this.label,
    required this.isComplete,
    required this.isCurrent,
  });
}

class OrderTimeline {
  OrderTimeline._();

  static const _flow = [
    StatusOrder.findingDriver,
    StatusOrder.driverFound,
    StatusOrder.driverToHospital,
    StatusOrder.driverQueue,
    StatusOrder.orderPreparing,
    StatusOrder.outForDelivery,
    StatusOrder.orderArrived,
  ];

  static List<OrderTimelineStep> build(StatusOrder current) {
    if (current == StatusOrder.orderCancelled) {
      return [
        OrderTimelineStep(
          status: StatusOrder.orderCancelled,
          label: OrderStatusUtils.label(StatusOrder.orderCancelled),
          isComplete: true,
          isCurrent: true,
        ),
      ];
    }

    final currentIndex = _flow.indexOf(current);
    return _flow.map((status) {
      final index = _flow.indexOf(status);
      final isComplete = currentIndex >= 0 && index <= currentIndex;
      final isCurrent = status == current;
      return OrderTimelineStep(
        status: status,
        label: OrderStatusUtils.label(status),
        isComplete: isComplete || current == StatusOrder.orderArrived,
        isCurrent: isCurrent,
      );
    }).toList();
  }
}
