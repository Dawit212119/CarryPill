class Profile {
  final String? profileImageUrl;
  final DateTime? birthDate;
  final String? gender;
  final String? icNum;
  final String? address;
  final String? race;
  final String? documentID;

  Profile({
    this.profileImageUrl,
    this.birthDate,
    this.gender,
    this.icNum,
    this.address,
    this.race,
    this.documentID,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      profileImageUrl: map['profileImageUrl'],
      birthDate: _parseDate(map['birthDate']),
      gender: map['gender'],
      icNum: map['icNum'],
      address: map['address'],
      race: map['race'],
      documentID: map['documentID']?.toString(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toMap() => {
        'profileImageUrl': profileImageUrl,
        'birthDate': birthDate?.toIso8601String(),
        'gender': gender,
        'icNum': icNum,
        'address': address,
        'race': race,
      };

  @override
  String toString() {
    return '${profileImageUrl.toString()}, ${birthDate.toString()}, ${gender.toString()}, ';
  }

  @override
  bool operator ==(other) => other is Profile && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
