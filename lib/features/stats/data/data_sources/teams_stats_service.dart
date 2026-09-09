import 'package:dio/dio.dart';
import 'package:starliga/core/constants/constatnts.dart';

class TeamsStatsService {
  Future<Response> getTeamsGoalsRanking() async {
    try {
      return await dio.get('statistics/teams/goals-ranking');
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getTeamsYellowCardsRanking() async {
    try {
      return await dio.get('statistics/teams/yellow-cards-ranking');
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getTeamsRedCardsRanking() async {
    try {
      return await dio.get('statistics/teams/red-cards-ranking');
    } catch (e) {
      rethrow;
    }
  }
  
}
