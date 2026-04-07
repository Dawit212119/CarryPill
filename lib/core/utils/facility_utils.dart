import 'package:carrypill/data/models/facility.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/data/repositories/map_repo/location_repo.dart';

class FacilityWithDistance {
  final Facility facility;
  final double? distanceKm;

  const FacilityWithDistance({required this.facility, this.distanceKm});
}

class FacilityUtils {
  FacilityUtils._();

  static List<FacilityWithDistance> sortByDistance(
    List<Facility> facilities,
    GeoPoint? from,
  ) {
    if (from == null) {
      return facilities
          .map((f) => FacilityWithDistance(facility: f))
          .toList();
    }

    final repo = LocationRepo();
    final withDistance = facilities.map((f) {
      final km = repo.calculateDistance(from, f.geoPoint);
      return FacilityWithDistance(facility: f, distanceKm: km);
    }).toList();

    withDistance.sort((a, b) {
      final ad = a.distanceKm ?? double.infinity;
      final bd = b.distanceKm ?? double.infinity;
      return ad.compareTo(bd);
    });
    return withDistance;
  }

  static List<FacilityWithDistance> filterByQuery(
    List<FacilityWithDistance> list,
    String query,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list
        .where(
          (e) =>
              e.facility.facilityName.toLowerCase().contains(q) ||
              e.facility.fullAddress.toLowerCase().contains(q),
        )
        .toList();
  }
}
