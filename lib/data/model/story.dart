class Story {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;
  String? address;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
     this.lat,
     this.lon,
    this.address,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    photoUrl: json["photoUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
  );
}