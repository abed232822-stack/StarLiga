import 'package:dio/dio.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/stats/data/data_sources/teams_stats_service.dart';
import 'package:starliga/features/stats/data/models/team_stats.dart';

class TeamsStatsRepo {
  final TeamsStatsService _teamsStatsService;
  TeamsStatsRepo(this._teamsStatsService);
  Future<
    DataState<
      ({
        List<TeamStats> teamsYellowCardsRanking,
        List<TeamStats> teamsRedCardRanking,
        List<TeamStats> teamsGoalRanking,
      })
    >
  >
  getTeamsStats() async {
    try {
      final teamsYellowCardsRanking = getTeamssYellowCardsRanking();
      final teamsRedCardRanking = getTeamsRedCardsRanking();
      final teamsGoalRanking = getTeamsGoalsRanking();
      final value = await Future.wait([
        teamsYellowCardsRanking,
        teamsRedCardRanking,
        teamsGoalRanking,
      ]);
      return DataSuccess((
        teamsYellowCardsRanking: value[0],
        teamsRedCardRanking: value[1],
        teamsGoalRanking: value[2],
      ));
    } catch (e) {
      return DataFailed(message: e.toString(),error: e is DioException ? e : null);
    }
  }

  Future<List<TeamStats>> getTeamsGoalsRanking() async {
    try {
      final response = await _teamsStatsService.getTeamsGoalsRanking();
      return (response.data['data'] as List)
          .map((e) => TeamStats.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TeamStats>> getTeamssYellowCardsRanking() async {
    try {
      final response = await _teamsStatsService.getTeamsYellowCardsRanking();
      return (response.data['data'] as List)
          .map((e) => TeamStats.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TeamStats>> getTeamsRedCardsRanking() async {
    try {
      final response = await _teamsStatsService.getTeamsRedCardsRanking();
      return (response.data['data'] as List)
          .map((e) => TeamStats.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
