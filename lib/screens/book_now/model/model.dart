// To parse this JSON data, do
//
//     final reservation = reservationFromJson(jsonString);

import 'dart:convert';

Reservation reservationFromJson(String str) => Reservation.fromJson(json.decode(str));

String reservationToJson(Reservation data) => json.encode(data.toJson());

class Reservation {
  Reservation({
    required this.active,
    required this.data,
  });

  bool active;
  Data data;

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    active: json["active"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.licensePlate,
    required this.site,
    required this.state,
    required this.arrival,
    required this.departure,
  });

  String licensePlate;
  String site;
  String state;
  DateTime arrival;
  DateTime departure;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    licensePlate: json["license_plate"],
    site: json["site"],
    state: json["state"],
    arrival: DateTime.parse(json["arrival"]),
    departure: DateTime.parse(json["departure"]),
  );

  Map<String, dynamic> toJson() => {
    "license_plate": licensePlate,
    "site": site,
    "state": state,
    "arrival": arrival.toIso8601String(),
    "departure": departure.toIso8601String(),
  };
}
