class Team {
  Team({
    this.id,
    required this.name,
    this.cityId,
    this.cityName,
    this.imageUrl,
    this.favCount,
    this.goalCount,
    this.playedMatchCount,
    this.wins,
    this.losses,
    this.draws,
    this.phoneNumber,
  });

  int? id;
  int? cityId;
  String? cityName;
  String name;
  String? imageUrl;
  int? favCount = 0;
  int? goalCount = 0;
  int? playedMatchCount = 0;
  int? wins = 0;
  int? losses = 0;
  int? draws = 0;
  String? phoneNumber;

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      cityId: json['city'] != null
          ? (json['city']['id'] ?? 0)
          : (json['city_id'] ?? 0),
      cityName: json['city'] != null
          ? (json['city']['name'] ?? '')
          : (json['city_name'] ?? ''),
      imageUrl: json['image_url'],
      favCount: json['fav_count'] ?? 0,
      goalCount: json['gaul_event_count'] ?? 0,
      playedMatchCount: json['played_match_count'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      draws: json['draws'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'city_id': cityId, 'phone_number': phoneNumber};
  }
}
