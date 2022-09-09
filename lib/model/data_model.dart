class DataModel {
  DataModel({
    this.name,
    this.city,
    this.age,
  });

  final String? name;
  final String? city;
  final int? age;

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
        name: json["name"],
        city: json["city"],
        age: json["age"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "city": city,
        "age": age,
      };
}
