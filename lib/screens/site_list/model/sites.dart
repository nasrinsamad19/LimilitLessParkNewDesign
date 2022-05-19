// To parse this JSON data, do
//
//     final sites = sitesFromJson(jsonString);

import 'dart:convert';

Sites sitesFromJson(String str) => Sites.fromJson(json.decode(str));

String sitesToJson(Sites data) => json.encode(data.toJson());

class Sites {
  Sites({
    required this.sites,
  });

  List<String> sites;

  factory Sites.fromJson(Map<String, dynamic> json) => Sites(
    sites: List<String>.from(json["sites"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "sites": List<dynamic>.from(sites.map((x) => x)),
  };
}
