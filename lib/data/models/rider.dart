import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/data/models/profile.dart';
import 'package:carrypill/data/models/vehicle.dart';

class Rider {
  final String firstName;
  final String lastName;
  final String phoneNum;
  final String vehicleType;
  final String workingStatus;
  final bool isWorking;
  final bool autoAccept;
  final GeoPoint? currrentLocation;
  final bool? isProfileComplete;
  final String? currentOrderId;
  final DateTime? startWorkingDate;
  final List<String>? orderCancelId;
  final Profile? profile;
  final Vehicle? vehicle;
  final double earning;
  final String? documentID;

  Rider({
    required this.firstName,
    required this.lastName,
    required this.phoneNum,
    required this.vehicleType,
    required this.workingStatus,
    required this.isWorking,
    required this.autoAccept,
    this.currrentLocation,
    this.isProfileComplete,
    this.startWorkingDate,
    this.currentOrderId,
    this.orderCancelId,
    this.profile,
    this.vehicle,
    this.earning = 0,
    this.documentID,
  });

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNum': phoneNum,
        'vehicleType': vehicleType,
        'workingStatus': workingStatus,
        'isWorking': isWorking,
        'currrentLocation': currrentLocation?.toMap(),
        'isProfileComplete': isProfileComplete,
        'autoAccept': autoAccept,
        'startWorkingDate': startWorkingDate?.toIso8601String(),
        'currentOrderId': currentOrderId,
        'orderCancelId': orderCancelId,
        'profile': profile?.toMap(),
        'vehicle': vehicle?.toMap(),
      };

  @override
  String toString() {
    return '${firstName.toString()}, ${lastName.toString()}, ${phoneNum.toString()}, ${vehicleType.toString()}, ${workingStatus.toString()}, ${isWorking.toString()}, ${currrentLocation.toString()}, ';
  }

  @override
  bool operator ==(other) => other is Rider && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
