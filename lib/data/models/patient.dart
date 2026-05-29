import 'dart:convert';

import 'package:carrypill/data/models/clinic.dart';
import 'package:carrypill/data/models/geo_point.dart';

class Patient {
  String name;
  String icNum;
  String phoneNum;
  String? patientId;
  String? address;
  List<Clinic> clinicList;
  DateTime? appointment;
  GeoPoint? geoPoint;
  String? profileImageUrl;
  String? documentID;

  Patient({
    required this.name,
    required this.icNum,
    required this.phoneNum,
    this.patientId,
    this.address,
    this.clinicList = const [],
    this.appointment,
    this.geoPoint,
    this.profileImageUrl,
    this.documentID,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      name: map['name'] ?? '',
      icNum: map['icNum'] ?? map['ic_num'] ?? '',
      phoneNum: map['phoneNum'] ?? map['phone_num'] ?? '',
      patientId: map['patientId'] ?? map['patient_id'],
      address: map['address'],
      clinicList: map['clinicList'] != null || map['clinic_list'] != null
          ? (map['clinicList'] ?? map['clinic_list'])
              .map<Clinic>((item) => Clinic.fromMap(Map<String, dynamic>.from(item)))
              .toList()
          : [],
      appointment: _parseDate(map['appointment']),
      geoPoint: map['geoPoint'] != null
          ? GeoPoint.fromMap(map['geoPoint'])
          : map['geo_lat'] != null && map['geo_lng'] != null
              ? GeoPoint(
                  (map['geo_lat'] as num).toDouble(),
                  (map['geo_lng'] as num).toDouble(),
                )
              : null,
      profileImageUrl: map['profileImageUrl'] ?? map['profile_image_url'],
      documentID: map['documentID'] ?? map['uid']?.toString(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'icNum': icNum,
        'phoneNum': phoneNum,
        'patientId': patientId,
        'address': address,
        'clinicList': clinicList.map((e) => e.toMap()).toList(),
        'appointment': appointment?.toIso8601String(),
        'geoPoint': geoPoint?.toMap(),
        'profileImageUrl': profileImageUrl,
      };

  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) =>
      Patient.fromMap(json.decode(source));

  @override
  String toString() {
    return '${name.toString()}, ${icNum.toString()}, ${phoneNum.toString()}, ${patientId.toString()}, ${address.toString()}, ${clinicList.toString()}, ${appointment.toString()}, ';
  }

  @override
  bool operator ==(other) => other is Patient && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
