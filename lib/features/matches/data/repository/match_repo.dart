import 'package:dio/dio.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/matches/data/data_sources/matches_service.dart';
import 'package:starliga/features/matches/data/models/match_model.dart';

class MatchesRepo {
  final MatchesService _matchesService;

  MatchesRepo(this._matchesService);

  Future<DataState<({List<MatchModel> upcoming, List<MatchModel> past})>>
  getMatches() async {
    try {
      final response = await _matchesService.getMatches();
      final List<MatchModel> upcomingMatches = (response.data['tobe'] as List)
          .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final List<MatchModel> pastMatches = (response.data['done'] as List)
          .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return DataSuccess((upcoming: upcomingMatches, past: pastMatches));
    } catch (e) {
      return DataFailed(
        message: e.toString(),
        error: e is DioException ? e : null,
      );
    }
  }

  Future<DataState<MatchModel>> getMatchDetails(int matchId) async {
    try {
      final response = await _matchesService.getMatchDetails(matchId);
      final match = MatchModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      return DataSuccess(match);
    } catch (e) {
      return DataFailed(
        message: e.toString(),
        error: e is DioException ? e : null,
      );
    }
  }
}
