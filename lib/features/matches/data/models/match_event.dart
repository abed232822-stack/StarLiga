import 'package:equatable/equatable.dart';

class MatchEventModel extends Equatable {
  final int id;
  final String type;
  final int teamId;
  final int playerId;
  final int matchId;
  final DateTime createdAt;
  final String? playerName;

  const MatchEventModel({
    required this.id,
    required this.type,
    required this.teamId,
    required this.playerId,
    required this.matchId,
    required this.createdAt,
    this.playerName,
  });

  factory MatchEventModel.fromJson(Map<String, dynamic> json) {
    return MatchEventModel(
      id: json['id'] as int,
      type: json['type'] as String,
      teamId: json['team_id'] as int,
      playerId: json['player_id'] as int,
      matchId: json['match_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      playerName: (json['player']?['full_name'] as String?)?.trim(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        teamId,
        playerId,
        matchId,
        createdAt,
        playerName,
      ];
}