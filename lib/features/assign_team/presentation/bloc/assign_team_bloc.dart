import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/assign_team/data/repository/assign_team_repo.dart';

part 'assign_team_event.dart';
part 'assign_team_state.dart';

class AssignTeamBloc extends Bloc<AssignTeamEvent, AssignTeamState> {
  final AssignTeamRepo _assignTeamRepo;

  AssignTeamBloc(this._assignTeamRepo) : super(AssignTeamInitialState()) {
    on<CreateTeamEvent>((event, emit) async {
      emit(AssignTeamSubmittingState());
      final result = await _assignTeamRepo.assignTeam(
        event.team,
        event.players,
        event.image,
      );
      if (result is DataSuccess) {
        emit(AssignTeamSuccessState(result.data));
      } else if (result is DataFailed) {
        emit(
          AssignTeamFailureState(
            result.message ?? 'فشل في إنشاء الفريق',
            error: result.error,
          ),
        );
      }
    });

    on<FetchCitiesEvent>((event, emit) async {
      emit(CitiesLoadingState());
      final result = await _assignTeamRepo.getAllCities();
      if (result is DataSuccess) {
        emit(CitiesLoadedState(cities: result.data!));
      } else if (result is DataFailed) {
        emit(
          CitiesErrorState(
            result.message ?? 'فشل في تحميل المدن',
            error: result.error,
          ),
        );
      }
    });
  }
}
