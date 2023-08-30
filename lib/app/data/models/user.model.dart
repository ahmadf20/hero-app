class User {
  User({this.name, this.height, this.weight, this.birthDate});

  String? name;
  double? height;
  double? weight;
  DateTime? birthDate;

  factory User.fromJson(Map<String, Object?> json) => User(
        name: json['name'] as String?,
        height: json['height'] as double?,
        weight: json['weight'] as double?,
        birthDate: json['birth_date'] == null
            ? null
            : DateTime.parse(json['birth_date']! as String),
      );

  Map<String, Object?> toJson() => {
        'name': name,
        'height': height,
        'weight': weight,
        'birth_date': birthDate?.toIso8601String(),
      };
}
