part of 'team_detail_bloc.dart';

sealed class TeamDetailsState extends Equatable {
  const TeamDetailsState();

  @override
  List<Object?> get props => [];
}

final class TeamDetailsInitial extends TeamDetailsState {}

final class TeamDetailsLoading extends TeamDetailsState {}

final class TeamDetailsSuccess extends TeamDetailsState {
  final Team team;
  final List<Player> players;
  final City city;

  const TeamDetailsSuccess({
    required this.team,
    required this.players,
    required this.city,
  });

  @override
  List<Object?> get props => [team, players, city];
}

final class TeamDetailsError extends TeamDetailsState {
  final String teamId;
  final String errorMessage;
  final DioException? error;

  const TeamDetailsError({
    required this.teamId,
    required this.errorMessage,
    this.error,
  });

  @override
  List<Object?> get props => [teamId, errorMessage, error];
}
