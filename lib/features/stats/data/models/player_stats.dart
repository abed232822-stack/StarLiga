import 'package:starliga/core/models/player.dart';
import 'package:starliga/core/models/team.dart';

class PlayerStats extends Player {
  final int? totalGoals;
  final int? totalYellowCards;
  final int? totalRedCards;

  PlayerStats({
    super.id,
    required super.fullName,
    super.middleName,
    required super.role,
    required super.age,
    super.fatherName,
    super.image,
    super.teamId,
    super.team,
    required this.totalGoals,
    this.totalYellowCards,
    this.totalRedCards,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      id: json['id'] as int?,
      fullName: json['full_name'] as String? ?? '',
      middleName: json['midle_name'] as String?,
      role: json['role'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      fatherName: json['father_name'] as String?,
      image: json['image_url'] as String?,
      teamId: json['team_id'] as int?,
      team: json['team'] != null ? Team.fromJson(json['team']) : null,
      totalGoals: json['total_goals'] as int? ?? 0,
      totalYellowCards: json['total_yellow_cards'] as int? ?? 0,
      totalRedCards: json['total_red_cards'] as int? ?? 0,  
    );
  }

}