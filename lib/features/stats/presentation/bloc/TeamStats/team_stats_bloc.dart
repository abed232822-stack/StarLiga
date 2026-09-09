import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/stats/data/models/team_stats.dart';
import 'package:starliga/features/stats/data/repository/teams_stats_repo.dart';

part 'team_stats_event.dart';
part 'team_stats_state.dart';

class TeamStatsBloc extends Bloc<TeamStatsEvent, TeamStatsState> {
  final TeamsStatsRepo _teamStatsRepo;
  TeamStatsBloc(this._teamStatsRepo) : super(TeamStatsInitial()) {
    on<LoadTeamsStatsEvent>((event, emit) async {
      emit(TeamStatsLoading());
      final response = await _teamStatsRepo.getTeamsStats();
      if (response is DataSuccess) {
        emit(
          TeamStatsSuccess(
            teamsGoalRanking: response.data!.teamsGoalRanking,
            teamsYellowCardsRanking:response.data!.teamsYellowCardsRanking,
            teamsRedCardRanking: response.data!.teamsRedCardRanking
          ),
        );
      } else if (response is DataFailed) {
        emit(TeamStatsError(response.message!, response.error!));
      }
    });
  }
}
