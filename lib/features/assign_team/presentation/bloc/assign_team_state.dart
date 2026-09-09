part of 'assign_team_bloc.dart';

sealed class AssignTeamState extends Equatable {
  const AssignTeamState();

  @override
  List<Object?> get props => [];
}

final class AssignTeamInitialState extends AssignTeamState {}

final class CitiesLoadingState extends AssignTeamState {}

final class CitiesLoadedState extends AssignTeamState {
  final List<City> cities;

  const CitiesLoadedState({required this.cities});

  @override
  List<Object?> get props => [cities];
}

final class CitiesErrorState extends AssignTeamState {
  final String errorMessage;
  final DioException? error;

  const CitiesErrorState(this.errorMessage, {this.error});

  @override
  List<Object?> get props => [errorMessage, error];
}

final class AssignTeamSubmittingState extends AssignTeamState {}

final class AssignTeamSuccessState extends AssignTeamState {
  final dynamic responseData;

  const AssignTeamSuccessState(this.responseData);

  @override
  List<Object?> get props => [responseData];
}

final class AssignTeamFailureState extends AssignTeamState {
  final String errorMessage;
  final DioException? error;

  const AssignTeamFailureState(this.errorMessage, {this.error});

  @override
  List<Object?> get props => [errorMessage, error];
}
