import 'package:dio/dio.dart';
import 'package:starliga/core/constants/constatnts.dart';

class StandingsService {
  Future<Response> getStandings() async {
    try {
      return await dio.get(
        'statistics/teams',
        options: Options(
          headers: {'Accept': 'application/json', 'x-app-type': 'admin'},
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getMatches() async {
    try {
      return await dio.get('matches/all');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCities() async {
    try {
      return await dio.get('cities');
    } catch (e) {
      rethrow;
    }
  }
}
