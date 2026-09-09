import 'package:starliga/core/models/team.dart';

class TeamStats extends Team {
  int? totalGoals;
  int? totalYellowCards;
  int? totalRedCards;
  int? goalScored;
  int? goalReceived;
  TeamStats({
    super.id,
    required super.name,
    super.cityId,
    super.cityName,
    super.imageUrl,
    super.favCount,
    super.goalCount,
    super.playedMatchCount,
    super.wins,
    super.losses,
    super.draws,
    super.phoneNumber,
    this.totalGoals,
    this.totalRedCards,
    this.totalYellowCards,
    this.goalReceived,
    this.goalScored,
  });
  int get points => ((wins ?? 0) * 3) + (draws ?? 0);
  int get goalDifference => (goalScored ?? 0) - (goalReceived ?? 0);
  factory TeamStats.fromJson(Map<String, dynamic> json) {
    return TeamStats(
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
      totalGoals: json['total_goals'] ?? 0,
      totalYellowCards: json['total_yellow_cards'] ?? 0,
      totalRedCards: json['total_red_cars'] ?? 0,
    );
  }
}
