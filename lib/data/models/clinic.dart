class Clinic {
  String clinicName;
  bool status;
  String? documentID;

  Clinic({
    required this.clinicName,
    required this.status,
    this.documentID,
  });

  // Accepts both camelCase and snake_case keys so rows from older and newer
  // backend schemas deserialize without a migration.
  factory Clinic.fromMap(Map<String, dynamic> map) {
    return Clinic(
      clinicName: map['clinicName'] ?? map['clinic_name'] ?? '',
      status: map['status'] ?? false,
      documentID: map['documentID'] ?? map['id']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'clinicName': clinicName,
        'status': status,
      };

  Clinic copyWith({
    required String clinicName,
    required bool status,
  }) {
    return Clinic(
      clinicName: clinicName,
      status: status,
    );
  }

  @override
  String toString() {
    return '${clinicName.toString()}, ${status.toString()}, ';
  }

  @override
  bool operator ==(other) => other is Clinic && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
