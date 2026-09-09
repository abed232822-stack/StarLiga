part of 'team_stats_bloc.dart';


sealed class TeamStatsState extends Equatable {
  const TeamStatsState();

  @override
  List<Object> get props => [];
}

final class TeamStatsInitial extends TeamStatsState {}

final class TeamStatsLoading extends TeamStatsState {}


final class TeamStatsSuccess extends TeamStatsState {
  final List<TeamStats> teamsYellowCardsRanking;
  final List<TeamStats> teamsRedCardRanking;
  final List<TeamStats> teamsGoalRanking;

  const TeamStatsSuccess({
    required this.teamsYellowCardsRanking,
    required this.teamsRedCardRanking,
    required this.teamsGoalRanking,
  });
}

final class TeamStatsError extends TeamStatsState {
  final String message;
  final DioException error;
  const TeamStatsError(this.message,this.error);
}
