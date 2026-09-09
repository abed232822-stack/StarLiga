part of 'player_stats_bloc.dart';

sealed class PlayerStatsState extends Equatable {
  const PlayerStatsState();

  @override
  List<Object> get props => [];
}

final class PlayerStatsInitial extends PlayerStatsState {}

final class PlayerStatsLoading extends PlayerStatsState {}


final class PlayerStatsSuccess extends PlayerStatsState {
  final List<PlayerStats> playersYellowCardsRanking;
  final List<PlayerStats> playersRedCardRanking;
  final List<PlayerStats> playersGoalRanking;

  const PlayerStatsSuccess({
    required this.playersYellowCardsRanking,
    required this.playersRedCardRanking,
    required this.playersGoalRanking,
  });
}

final class PlayerStatsError extends PlayerStatsState {
  final String message;
  final DioException error;
  const PlayerStatsError(this.message,this.error);
}
