// To parse this JSON data, do
//
//     final myCar = myCarFromJson(jsonString);

import 'dart:convert';

MyCar myCarFromJson(String str) => MyCar.fromJson(json.decode(str));

String myCarToJson(MyCar data) => json.encode(data.toJson());

class MyCar {
  MyCar({
    required this.cars,
  });

  List<Car> cars;

  factory MyCar.fromJson(Map<String, dynamic> json) => MyCar(
    cars: List<Car>.from(json["cars"].map((x) => Car.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cars": List<dynamic>.from(cars.map((x) => x.toJson())),
  };
}

class Car {
  Car({
    required this.name,
    required this.licensePlate,
    required this.state,
  });

  String name;
  String licensePlate;
  String state;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    name: json["name"],
    licensePlate: json["license_plate"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "license_plate": licensePlate,
    "state": state,
  };
}
