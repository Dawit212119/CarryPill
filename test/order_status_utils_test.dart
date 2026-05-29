import 'package:carrypill/core/utils/order_status_utils.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderStatusUtils', () {
    test('label returns human-readable status', () {
      expect(
        OrderStatusUtils.label(StatusOrder.findingDriver),
        'Finding rider',
      );
      expect(
        OrderStatusUtils.label(StatusOrder.orderCancelled),
        'Cancelled',
      );
    });

    test('canCancel only before rider assignment', () {
      expect(OrderStatusUtils.canCancel(StatusOrder.findingDriver), isTrue);
      expect(OrderStatusUtils.canCancel(StatusOrder.driverFound), isFalse);
      expect(OrderStatusUtils.canCancel(StatusOrder.orderCancelled), isFalse);
    });

    test('isActive excludes terminal states', () {
      expect(OrderStatusUtils.isActive(StatusOrder.outForDelivery), isTrue);
      expect(OrderStatusUtils.isActive(StatusOrder.orderArrived), isFalse);
      expect(OrderStatusUtils.isActive(StatusOrder.orderCancelled), isFalse);
    });
  });
}
