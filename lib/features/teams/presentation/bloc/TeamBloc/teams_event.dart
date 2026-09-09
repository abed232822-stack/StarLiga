part of 'teams_bloc.dart';

sealed class TeamsEvent extends Equatable {
  const TeamsEvent();

  @override
  List<Object?> get props => [];
}

class FetchCitiesAndTeamsEvent extends TeamsEvent {}

class SelectCityEvent extends TeamsEvent {
  final City city;

  const SelectCityEvent(this.city);

  @override
  List<Object?> get props => [city];
}
