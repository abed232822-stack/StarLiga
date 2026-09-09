part of 'standings_bloc.dart';

sealed class StandingsState extends Equatable {
  const StandingsState();

  @override
  List<Object?> get props => [];
}

final class StandingsInitial extends StandingsState {}

class StandingsLoading extends StandingsState {}

class StandingsError extends StandingsState {
  final String message;
  final DioException? error;
  const StandingsError(this.message, [this.error]);

  @override
  List<Object?> get props => [message, error];
}

class StandingsSuccess extends StandingsState {
  final List<TeamStats> standings;
  const StandingsSuccess(this.standings);

  @override
  List<Object?> get props => [standings];
}

class StandingsByStageSuccess extends StandingsState {
  final List<MatchModel> standings;
  const StandingsByStageSuccess(this.standings);

  @override
  List<Object?> get props => [standings];
}
