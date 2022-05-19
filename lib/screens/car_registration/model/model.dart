// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

CarRegistrationModel userFromJson(String str) =>
    CarRegistrationModel.fromJson(json.decode(str));

String carRegistrationModelToJson(CarRegistrationModel data) =>
    json.encode(data.toJson());

class CarRegistrationModel {
  CarRegistrationModel({
    required this.license_plate,
  });

  String license_plate;

  factory CarRegistrationModel.fromJson(Map<String, dynamic> json) =>
      CarRegistrationModel(
        license_plate: json["license_plate"],
      );

  Map<String, dynamic> toJson() => {
        "license_plate": license_plate,
      };
}
// To parse this JSON data, do
//
//     final states = statesFromJson(jsonString);


States statesFromJson(String str) => States.fromJson(json.decode(str));

String statesToJson(States data) => json.encode(data.toJson());

class States {
  States({
    required this.states,
  });

  List<state> states;

  factory States.fromJson(Map<String, dynamic> json) => States(
    states: List<state>.from(json["states"].map((x) => state.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "states": List<dynamic>.from(states.map((x) => x.toJson())),
  };
}

class state {
  state({
    required this.stateName,
    required this.plateCodes,
  });

  String stateName;
  List<String> plateCodes;

  factory state.fromJson(Map<String, dynamic> json) => state(
    stateName: json["state_name"],
    plateCodes: List<String>.from(json["plate_codes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "state_name": stateName,
    "plate_codes": List<dynamic>.from(plateCodes.map((x) => x)),
  };
}
