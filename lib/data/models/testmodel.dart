import 'dart:convert';

class Testmodel {
  final String? name;
  final String? documentID;

  Testmodel({
    this.name,
    this.documentID,
  });

  factory Testmodel.fromMap(Map<String, dynamic> map) {
    return Testmodel(
      name: map['name'],
      documentID: map['documentID']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
      };

  String toJson() => json.encode(toMap());

  factory Testmodel.fromJson(String source) =>
      Testmodel.fromMap(json.decode(source));

  @override
  bool operator ==(other) =>
      other is Testmodel && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
