import 'package:dio/dio.dart';
import 'package:starliga/core/constants/constatnts.dart';

class TeamsService {
  Future<Response> getAllCities() async {
    try {
      return await dio.get('cities');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllTeams() async {
    try {
      return await dio.get('teams');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getTeamDetails(String teamId) async {
    try {
      return await dio.get('teams/$teamId');
    } catch (e) {
      rethrow;
    }
  }
}
