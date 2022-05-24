// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    required this.fullName,
    required this.email,
    //required this.cars,
  });

  String fullName;
  String email;
  //List<Car> cars;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    fullName: json["full_name"],
    email: json["email"],
    //cars: List<Car>.from(json["cars"].map((x) => Car.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "email": email,
    //"cars": List<dynamic>.from(cars.map((x) => x.toJson())),
  };
}

class Car {
  Car({
    required this.licensePlate,
    required this.state,
  });

  String licensePlate;
  String state;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    licensePlate: json["license_plate"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "license_plate": licensePlate,
    "state": state,
  };
}
