class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint(this.latitude, this.longitude);

  // Tolerant parser: accepts an existing GeoPoint or a map using any of the
  // latitude/longitude key spellings the backend and client have used.
  factory GeoPoint.fromMap(dynamic map) {
    if (map == null) {
      throw ArgumentError('GeoPoint map is null');
    }
    if (map is GeoPoint) return map;
    if (map is Map) {
      return GeoPoint(
        (map['latitude'] ?? map['lat'] ?? map['geo_lat']).toDouble(),
        (map['longitude'] ?? map['lng'] ?? map['geo_lng']).toDouble(),
      );
    }
    throw ArgumentError('Invalid GeoPoint map: $map');
  }

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      latitude == other.latitude &&
      longitude == other.longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
