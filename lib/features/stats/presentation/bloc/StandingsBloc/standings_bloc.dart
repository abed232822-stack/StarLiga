import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starliga/core/enums/tournament_stages.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/matches/data/models/match_model.dart';
import 'package:starliga/features/stats/data/models/team_stats.dart';
import 'package:starliga/features/stats/data/repository/standing_repo.dart';

part 'standings_event.dart';
part 'standings_state.dart';

class StandingsBloc extends Bloc<StandingsEvent, StandingsState> {
  final StandingsRepo _standingsRepo;
  List<City> cities = [];
  City? selectedCity;
  TournamentStage selectedStage = TournamentStage.groupStage;

  StandingsBloc(this._standingsRepo) : super(StandingsInitial()) {
    on<InitStandingsEvent>(_onInitStandings);
    on<LoadStandingsEvent>(_onLoadStandings);
    on<LoadStandingsByStageEvent>(_onLoadStandingsByStage);
    on<ChangeCityEvent>(_onChangeCity);
    on<ChangeStageEvent>(_onChangeStage);
    on<RetryStandingsEvent>(_onRetry);
  }

  Future<void> _onInitStandings(
    InitStandingsEvent event,
    Emitter<StandingsState> emit,
  ) async {
    emit(StandingsLoading());
    final citiesResult = await _standingsRepo.getCities();
    if (citiesResult is DataFailed) {
      emit(StandingsError(
        citiesResult.message ?? 'فشل في تحميل المدن',
        citiesResult.error,
      ));
      return;
    }

    cities = citiesResult.data ?? [];
    if (cities.isEmpty) {
      emit(const StandingsSuccess([]));
      return;
    }

    selectedCity = cities.first;
    selectedStage = TournamentStage.groupStage;

    final standingsResult = await _standingsRepo.getStandings(selectedCity!.id);
    if (standingsResult is DataFailed) {
      emit(StandingsError(
        standingsResult.message ?? 'فشل في تحميل الترتيب',
        standingsResult.error,
      ));
      return;
    }

    emit(StandingsSuccess(standingsResult.data ?? []));
  }

  Future<void> _onLoadStandings(
    LoadStandingsEvent event,
    Emitter<StandingsState> emit,
  ) async {
    emit(StandingsLoading());
    final response = await _standingsRepo.getStandings(event.cityId);
    if (response is DataSuccess) {
      emit(StandingsSuccess(response.data!));
    } else if (response is DataFailed) {
      emit(StandingsError(response.message!, response.error));
    }
  }

  Future<void> _onLoadStandingsByStage(
    LoadStandingsByStageEvent event,
    Emitter<StandingsState> emit,
  ) async {
    emit(StandingsLoading());
    final response = await _standingsRepo.getStandingsByStage(event.stage);
    if (response is DataSuccess) {
      emit(StandingsByStageSuccess(response.data!));
    } else if (response is DataFailed) {
      emit(StandingsError(response.message!, response.error));
    }
  }

  Future<void> _onChangeCity(
    ChangeCityEvent event,
    Emitter<StandingsState> emit,
  ) async {
    selectedCity = event.city;
    add(LoadStandingsEvent(cityId: event.city.id));
  }

  Future<void> _onChangeStage(
    ChangeStageEvent event,
    Emitter<StandingsState> emit,
  ) async {
    selectedStage = event.stage;
    if (event.stage == TournamentStage.groupStage) {
      add(LoadStandingsEvent(cityId: selectedCity?.id));
    } else {
      add(LoadStandingsByStageEvent(stage: event.stage.code));
    }
  }

  Future<void> _onRetry(
    RetryStandingsEvent event,
    Emitter<StandingsState> emit,
  ) async {
    if (selectedStage == TournamentStage.groupStage) {
      if (cities.isEmpty) {
        add(InitStandingsEvent());
      } else {
        add(LoadStandingsEvent(cityId: selectedCity?.id));
      }
    } else {
      add(LoadStandingsByStageEvent(stage: selectedStage.code));
    }
  }
}
