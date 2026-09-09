import 'package:dio/dio.dart';
import 'package:starliga/core/constants/constatnts.dart';

class PlayersStatsService {
  Future<Response> getPlayersGoalsRanking() async {
    try {
      return await dio.get('statistics/players/goals-ranking');
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getPlayersYellowCardsRanking() async {
    try {
      return await dio.get('statistics/players/yellow-cards-ranking');
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getPlayersRedCardsRanking() async {
    try {
      return await dio.get('statistics/players/red-cards-ranking');
    } catch (e) {
      rethrow;
    }
  }
  
}
