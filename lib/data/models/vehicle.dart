class Vehicle {
  final String? vehiclePlateNum;
  final String? riderLicense;
  final String? vehicleBrand;
  final String? documentID;

  Vehicle({
    this.vehiclePlateNum,
    this.riderLicense,
    this.vehicleBrand,
    this.documentID,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      vehiclePlateNum: map['vehiclePlateNum'],
      riderLicense: map['riderLicense'],
      vehicleBrand: map['vehicleBrand'],
      documentID: map['documentID']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'vehiclePlateNum': vehiclePlateNum,
        'riderLicense': riderLicense,
        'vehicleBrand': vehicleBrand,
      };

  @override
  String toString() {
    return '${vehiclePlateNum.toString()}, ${riderLicense.toString()}, ${vehicleBrand.toString()}, ';
  }

  @override
  bool operator ==(other) => other is Vehicle && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
