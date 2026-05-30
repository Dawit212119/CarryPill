import 'package:carrypill/core/utils/delivery_eta_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeliveryEtaUtils', () {
    test('estimateMinutes scales with distance', () {
      expect(DeliveryEtaUtils.estimateMinutes(0), 1);
      expect(DeliveryEtaUtils.estimateMinutes(5), greaterThan(5));
    });

    test('formatDuration handles sub-hour and hour values', () {
      expect(DeliveryEtaUtils.formatDuration(15), '15 min');
      expect(DeliveryEtaUtils.formatDuration(60), '1h');
      expect(DeliveryEtaUtils.formatDuration(75), '1h 15m');
    });

    test('formatDistance shows meters for short trips', () {
      expect(DeliveryEtaUtils.formatDistance(0.4), '400 m');
      expect(DeliveryEtaUtils.formatDistance(2.3), '2.3 km');
    });
  });
}
