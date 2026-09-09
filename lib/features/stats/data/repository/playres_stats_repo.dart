import 'package:dio/dio.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/stats/data/data_sources/players_stats_service.dart';
import 'package:starliga/features/stats/data/models/player_stats.dart';

class PlayerStatsRepo {
  final PlayersStatsService _playersStatsService;
  PlayerStatsRepo(this._playersStatsService);
  Future<
    DataState<
      ({
        List<PlayerStats> playersYellowCardsRanking,
        List<PlayerStats> playersRedCardRanking,
        List<PlayerStats> playersGoalRanking,
      })
    >
  >
  getPlayersStats() async {
    try {
      final playersYellowCardsRanking = getPlayersYellowCardsRanking();
      final playersRedCardRanking = getPlayersRedCardsRanking();
      final playersGoalRanking = getPlayersGoalsRanking();
      final value = await Future.wait([
        playersYellowCardsRanking,
        playersRedCardRanking,
        playersGoalRanking,
      ]);
      return DataSuccess((
        playersYellowCardsRanking: value[0],
        playersRedCardRanking: value[1],
        playersGoalRanking: value[2],
      ));
    } catch (e) {
      return DataFailed(message: e.toString(),error: e is DioException ? e : null);
    }
  }

  Future<List<PlayerStats>> getPlayersGoalsRanking() async {
    try {
      final response = await _playersStatsService.getPlayersGoalsRanking();
      return (response.data['data'] as List)
          .map((e) => PlayerStats.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PlayerStats>> getPlayersYellowCardsRanking() async {
    try {
      final response = await _playersStatsService
          .getPlayersYellowCardsRanking();
      return (response.data['data'] as List)
          .map((e) => PlayerStats.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PlayerStats>> getPlayersRedCardsRanking() async {
    try {
      final response = await _playersStatsService.getPlayersRedCardsRanking();
      return (response.data['data'] as List)
          .map((e) => PlayerStats.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
