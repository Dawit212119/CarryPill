import 'dart:math';

/// Distance-based delivery ETA helpers (urban motorcycle ~25 km/h).
class DeliveryEtaUtils {
  static const double averageSpeedKmh = 25;

  static double distanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static int estimateMinutes(double distanceKm) {
    if (distanceKm <= 0) return 1;
    final minutes = (distanceKm / averageSpeedKmh * 60).ceil();
    return minutes.clamp(1, 180);
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remainder = minutes % 60;
    if (remainder == 0) return '${hours}h';
    return '${hours}h ${remainder}m';
  }

  static String formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }
}
