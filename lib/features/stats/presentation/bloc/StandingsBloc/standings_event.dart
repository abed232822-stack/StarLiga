part of 'standings_bloc.dart';

sealed class StandingsEvent extends Equatable {
  const StandingsEvent();

  @override
  List<Object?> get props => [];
}

final class InitStandingsEvent extends StandingsEvent {}

class LoadStandingsEvent extends StandingsEvent {
  final int? cityId;
  const LoadStandingsEvent({required this.cityId});

  @override
  List<Object?> get props => [cityId];
}

class LoadStandingsByStageEvent extends StandingsEvent {
  final String stage;
  const LoadStandingsByStageEvent({required this.stage});

  @override
  List<Object?> get props => [stage];
}

final class ChangeCityEvent extends StandingsEvent {
  final City city;
  const ChangeCityEvent(this.city);

  @override
  List<Object?> get props => [city];
}

final class ChangeStageEvent extends StandingsEvent {
  final TournamentStage stage;
  const ChangeStageEvent(this.stage);

  @override
  List<Object?> get props => [stage];
}

final class RetryStandingsEvent extends StandingsEvent {}