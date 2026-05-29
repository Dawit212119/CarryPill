import 'package:carrypill/core/utils/order_timeline.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('timeline marks steps complete up to current status', () {
    final steps = OrderTimeline.build(StatusOrder.driverQueue);
    final queueStep = steps.firstWhere((s) => s.status == StatusOrder.driverQueue);
    expect(queueStep.isCurrent, isTrue);
    expect(
      steps.firstWhere((s) => s.status == StatusOrder.findingDriver).isComplete,
      isTrue,
    );
    expect(
      steps.firstWhere((s) => s.status == StatusOrder.outForDelivery).isComplete,
      isFalse,
    );
  });

  test('cancelled order has single cancelled step', () {
    final steps = OrderTimeline.build(StatusOrder.orderCancelled);
    expect(steps.length, 1);
    expect(steps.first.status, StatusOrder.orderCancelled);
  });
}
