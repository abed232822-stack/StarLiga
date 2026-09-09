part of 'team_detail_bloc.dart';

sealed class TeamDetailEvent extends Equatable {
  const TeamDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchTeamDetailsEvent extends TeamDetailEvent {
  final String teamId;

  const FetchTeamDetailsEvent(this.teamId);

  @override
  List<Object?> get props => [teamId];
}
