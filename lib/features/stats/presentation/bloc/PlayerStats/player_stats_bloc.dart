import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/stats/data/models/player_stats.dart';
import 'package:starliga/features/stats/data/repository/playres_stats_repo.dart';

part 'player_stats_event.dart';
part 'player_stats_state.dart';

class PlayerStatsBloc extends Bloc<PlayerStatsEvent, PlayerStatsState> {
  final PlayerStatsRepo _playerStatsRepo;
  PlayerStatsBloc(this._playerStatsRepo) : super(PlayerStatsInitial()) {
    on<LoadPlayerStatsEvent>((event, emit) async {
      emit(PlayerStatsLoading());
      final response = await _playerStatsRepo.getPlayersStats();
      if (response is DataSuccess) {
        emit(
          PlayerStatsSuccess(
            playersGoalRanking: response.data!.playersGoalRanking,
            playersYellowCardsRanking:response.data!.playersYellowCardsRanking,
            playersRedCardRanking: response.data!.playersRedCardRanking
          ),
        );
      } else if (response is DataFailed) {
        emit(PlayerStatsError(response.message!, response.error!));
      }
    });
  }
}
