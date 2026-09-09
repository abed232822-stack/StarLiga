part of 'assign_team_bloc.dart';

sealed class AssignTeamEvent extends Equatable {
  const AssignTeamEvent();

  @override
  List<Object?> get props => [];
}

class CreateTeamEvent extends AssignTeamEvent {
  final Team team;
  final List<Player> players;
  final File? image;

  const CreateTeamEvent({
    required this.team,
    required this.players,
    required this.image,
  });

  @override
  List<Object?> get props => [team, players, image];
}

class FetchCitiesEvent extends AssignTeamEvent {}
