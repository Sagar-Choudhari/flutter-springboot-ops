import 'dart:convert';

List<Lang> langFromJson(String str) =>
    List<Lang>.from(json.decode(str).map((x) => Lang.fromJson(x)));

String langToJson(List<Lang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lang {
  Lang({
    this.id,
    required this.title,
    required this.description,
  });

  int? id;
  String title;
  String description;

  factory Lang.fromJson(Map<String, dynamic> json) => Lang(
        id: json["id"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
      };
}
