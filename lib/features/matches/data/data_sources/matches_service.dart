import 'package:dio/dio.dart';
import 'package:starliga/core/constants/constatnts.dart';

class MatchesService {
  Future<Response> getMatches() async {
    try {
      return await dio.get('matches/all');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getMatchDetails(int matchId) async {
    try {
      return await dio.get('matches/$matchId');
    } catch (e) {
      rethrow;
    }
  }
}
