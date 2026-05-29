class License {
  final String? licenseClass;
  final String? licenseType;
  final String? licenseImageUrl;
  final DateTime? licenseExpirationDate;
  final String? documentID;

  License({
    this.licenseClass,
    this.licenseType,
    this.licenseImageUrl,
    this.licenseExpirationDate,
    this.documentID,
  });

  factory License.fromMap(Map<String, dynamic> map) {
    return License(
      licenseClass: map['licenseClass'],
      licenseType: map['licenseType'],
      licenseImageUrl: map['licenseImageUrl'],
      licenseExpirationDate: map['licenseExpirationDate'] != null
          ? DateTime.tryParse(map['licenseExpirationDate'].toString())
          : null,
      documentID: map['documentID']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'licenseClass': licenseClass,
        'licenseType': licenseType,
        'licenseImageUrl': licenseImageUrl,
        'licenseExpirationDate': licenseExpirationDate?.toIso8601String(),
      };

  @override
  bool operator ==(other) => other is License && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
