import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/teams/data/repository/teams_repo.dart';

part 'teams_event.dart';
part 'teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  final TeamsRepo _teamsRepo;
  List<Team> _allTeams = [];
  List<City> _allCities = [];
  static const City allCity = City(name: 'الكل', id: 0);

  TeamsBloc(this._teamsRepo) : super(TeamsInitial()) {
    on<FetchCitiesAndTeamsEvent>((event, emit) async {
      emit(const TeamsLoading(selectedCity: allCity));
      final result = await _teamsRepo.getCitiesAndAcceptedTeams();
      if (result is DataSuccess) {
        _allCities = result.data!.cities;
        _allTeams = result.data!.teams;
        emit(
          TeamsSuccess(
            selectedCity: allCity,
            teams: _allTeams,
            cities: [allCity, ..._allCities],
          ),
        );
      } else if (result is DataFailed) {
        emit(
          TeamsError(
            selectedCity: allCity,
            errorMessage: result.message ?? 'حدث خطأ أثناء جلب البيانات',
            error: result.error,
          ),
        );
      }
    });

    on<SelectCityEvent>((event, emit) {
      if (state is TeamsSuccess) {
        final filteredTeams = event.city.id == 0
            ? _allTeams
            : _allTeams.where((team) => team.cityId == event.city.id).toList();

        emit(
          TeamsSuccess(
            selectedCity: event.city,
            teams: filteredTeams,
            cities: [allCity, ..._allCities],
          ),
        );
      }
    });
  }
}
