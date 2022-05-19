// To parse this JSON data, do
//
//     final activities = activitiesFromJson(jsonString);

import 'dart:convert';

Activities activitiesFromJson(String str) =>
    Activities.fromJson(json.decode(str));

String activitiesToJson(Activities data) => json.encode(data.toJson());

class Activities {
  Activities({
    required this.count,
    required this.next,
    this.previous,
    required this.results,
  });

  int count;
  String next;
  dynamic previous;
  List<Result> results;

  factory Activities.fromJson(Map<String, dynamic> json) => Activities(
        count: json["count"],
        next: json["next"] != null ? json["next"] : '',
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.licensePlate,
    required this.arrival,
    required this.departure,
    required this.cost,
  });

  String licensePlate;
  DateTime arrival;
  DateTime departure;
  String cost;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        licensePlate: json["license_plate"],
        arrival: DateTime.parse(json["arrival"]),
        departure: DateTime.parse(json["departure"]),
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "license_plate": licensePlate,
        "arrival": arrival.toIso8601String(),
        "departure": departure.toIso8601String(),
        "cost": cost,
      };
}
