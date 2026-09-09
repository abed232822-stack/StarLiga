part of 'player_stats_bloc.dart';

sealed class PlayerStatsEvent extends Equatable {
  const PlayerStatsEvent();

  @override
  List<Object> get props => [];
}

class LoadPlayerStatsEvent extends PlayerStatsEvent {}
