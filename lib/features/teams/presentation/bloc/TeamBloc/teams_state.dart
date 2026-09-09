part of 'teams_bloc.dart';

sealed class TeamsState extends Equatable {
  const TeamsState();

  @override
  List<Object?> get props => [];
}

final class TeamsInitial extends TeamsState {}

final class TeamsLoading extends TeamsState {
  final City selectedCity;

  const TeamsLoading({required this.selectedCity});

  @override
  List<Object?> get props => [selectedCity];
}

final class TeamsSuccess extends TeamsState {
  final City selectedCity;
  final List<Team> teams;
  final List<City> cities;

  const TeamsSuccess({
    required this.selectedCity,
    required this.teams,
    required this.cities,
  });

  @override
  List<Object?> get props => [selectedCity, teams, cities];
}

final class TeamsError extends TeamsState {
  final City selectedCity;
  final String errorMessage;
  final DioException? error;

  const TeamsError({
    required this.selectedCity,
    required this.errorMessage,
    this.error,
  });

  @override
  List<Object?> get props => [selectedCity, errorMessage, error];
}
