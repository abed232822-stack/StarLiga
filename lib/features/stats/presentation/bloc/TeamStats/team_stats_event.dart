part of 'team_stats_bloc.dart';



sealed class TeamStatsEvent extends Equatable {
  const TeamStatsEvent();

  @override
  List<Object> get props => [];
}

class LoadTeamsStatsEvent extends TeamStatsEvent {}
