import 'package:equatable/equatable.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/features/matches/data/models/match_event.dart';

class MatchModel extends Equatable {
  final int id;
  final String place;
  final int team1Id;
  final int team2Id;
  final DateTime timeDate;
  final int cityId;
  final int team1Goals;
  final int team2Goals;
  final int team1GoalsReceived;
  final int team2GoalsReceived;
  final DateTime? startedAt;
  final String state;
  final String stage;
  final Team team1;
  final Team team2;
  final City city;
  final List<Player> team1Players;
  final List<Player> team2Players;
  final List<MatchEventModel> events;

  const MatchModel({
    required this.id,
    required this.place,
    required this.team1Id,
    required this.team2Id,
    required this.timeDate,
    required this.cityId,
    required this.team1Goals,
    required this.team2Goals,
    required this.team1GoalsReceived,
    required this.team2GoalsReceived,
    this.startedAt,
    required this.state,
    required this.stage,
    required this.team1,
    required this.team2,
    required this.city,
    required this.team1Players,
    required this.team2Players,
    required this.events,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as int? ?? 0,
      place: json['place'] as String? ?? '',
      team1Id: json['team_1_id'] as int? ?? 0,
      team2Id: json['team_2_id'] as int? ?? 0,
      timeDate: json['time_date'] != null
          ? DateTime.tryParse(json['time_date']) ?? DateTime.now()
          : DateTime.now(),
      cityId: json['city_id'] as int? ?? 0,
      team1Goals: json['team_1_goals'] as int? ?? 0,
      team2Goals: json['team_2_goals'] as int? ?? 0,
      team1GoalsReceived: json['team_1_goals_received'] as int? ?? 0,
      team2GoalsReceived: json['team_2_goals_received'] as int? ?? 0,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'])
          : null,
      state: json['state'] as String? ?? '',
      stage: json['stage'] as String? ?? '',
      team1: Team.fromJson(json['team1'] as Map<String, dynamic>? ?? {}),
      team2: Team.fromJson(json['team2'] as Map<String, dynamic>? ?? {}),
      city: City.fromJson(json['city'] as Map<String, dynamic>? ?? {}),
      team1Players: (json['team1']?['players'] as List<dynamic>?)
              ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      team2Players: (json['team2']?['players'] as List<dynamic>?)
              ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => MatchEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
        id,
        place,
        team1Id,
        team2Id,
        timeDate,
        cityId,
        team1Goals,
        team2Goals,
        team1GoalsReceived,
        team2GoalsReceived,
        startedAt,
        state,
        stage,
        team1,
        team2,
        city,
        team1Players,
        team2Players,
        events,
      ];
}
