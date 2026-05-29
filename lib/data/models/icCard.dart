class IcCard {
  final String? icFrontImageUrl;
  final String? icBackImageUrl;
  final String? icNumber;
  final String? documentID;

  IcCard({
    this.icFrontImageUrl,
    this.icBackImageUrl,
    this.icNumber,
    this.documentID,
  });

  Map<String, dynamic> toMap() => {
        'icFrontImageUrl': icFrontImageUrl,
        'icBackImageUrl': icBackImageUrl,
        'icNumber': icNumber,
      };

  @override
  bool operator ==(other) => other is IcCard && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
