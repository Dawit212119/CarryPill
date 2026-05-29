import 'package:carrypill/data/models/geo_point.dart';

class Facility {
  final String facilityName;
  final GeoPoint geoPoint;
  final String fullAddress;
  final String? documentID;

  Facility({
    required this.facilityName,
    required this.geoPoint,
    required this.fullAddress,
    this.documentID,
  });

  factory Facility.fromMap(Map<String, dynamic> map) {
    return Facility(
      facilityName: map['facilityName'] ?? map['facility_name'] ?? '',
      geoPoint: map['geoPoint'] != null
          ? GeoPoint.fromMap(map['geoPoint'])
          : GeoPoint(
              (map['geo_lat'] as num).toDouble(),
              (map['geo_lng'] as num).toDouble(),
            ),
      fullAddress: map['fullAddress'] ?? map['full_address'] ?? '',
      documentID: map['documentID'] ?? map['id']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'facilityName': facilityName,
        'geoPoint': geoPoint.toMap(),
        'fullAddress': fullAddress,
      };

  Facility copyWith({
    String? facilityName,
    GeoPoint? geoPoint,
    String? fullAddress,
  }) {
    return Facility(
      facilityName: facilityName ?? this.facilityName,
      geoPoint: geoPoint ?? this.geoPoint,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }

  @override
  String toString() {
    return '${facilityName.toString()}, ${geoPoint.toString()}, ';
  }

  @override
  bool operator ==(other) =>
      other is Facility && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
