import 'package:dio/dio.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/matches/data/models/match_model.dart';
import 'package:starliga/features/stats/data/data_sources/standings_service.dart';
import 'package:starliga/features/stats/data/models/team_stats.dart';

class StandingsRepo {
  final StandingsService _service;
  StandingsRepo(this._service);

  Future<DataState<List<City>>> getCities() async {
    try {
      final response = await _service.getCities();
      if (response.statusCode == 200) {
        final List<City> cities = (response.data['data'] as List)
            .map((e) => City.fromJson(e))
            .toList();
        return DataSuccess(cities);
      } else {
        return DataFailed(
          error: DioException(
            requestOptions: response.requestOptions,
            error: 'Failed to load cities',
          ),
          message: 'Failed to load cities',
        );
      }
    } on DioException catch (e) {
      return DataFailed(error: e, message: e.message);
    } catch (e) {
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(path: 'cities'),
          error: e.toString(),
        ),
        message: e.toString(),
      );
    }
  }

  Future<DataState<List<TeamStats>>> getStandings(int? cityId) async {
    try {
      final response = await _service.getStandings();
      if (response.statusCode == 200) {
        List<TeamStats> standings = (response.data['data'] as List)
            .map((e) => TeamStats.fromJson(e))
            .toList();
        if (cityId != null) {
          standings = standings.where((team) => team.cityId == cityId).toList();
        }
        return DataSuccess(standings);
      } else {
        return DataFailed(
          error: DioException(
            requestOptions: response.requestOptions,
            error: 'Failed to load standings',
          ),
          message: 'Failed to load standings',
        );
      }
    } on DioException catch (e) {
      return DataFailed(error: e, message: e.message);
    } catch (e) {
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(path: 'statistics/teams'),
          error: e.toString(),
        ),
        message: e.toString(),
      );
    }
  }

  Future<DataState<List<MatchModel>>> getStandingsByStage(String stage) async {
    try {
      final response = await _service.getMatches();
      if (response.statusCode == 200) {
        final allMatches = [
          ...response.data['tobe'] ?? [],
          ...response.data['now'] ?? [],
          ...response.data['done'] ?? [],
        ];

        List<MatchModel> standings = allMatches
            .map((e) => MatchModel.fromJson(e))
            .where((team) => team.stage == stage)
            .toList();

        return DataSuccess(standings);
      } else {
        return DataFailed(
          error: DioException(
            requestOptions: response.requestOptions,
            error: 'Failed to load standings by stage',
          ),
          message: 'Failed to load standings by stage',
        );
      }
    } on DioException catch (e) {
      return DataFailed(error: e, message: e.message);
    } catch (e) {
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(path: 'matches/all'),
          error: e.toString(),
        ),
        message: e.toString(),
      );
    }
  }
}
