import 'dart:io';
import 'package:dio/dio.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/assign_team/data/data_sources/assign_team_service.dart';

class AssignTeamRepo {
  final AssignTeamService _assignTeamService;

  AssignTeamRepo(this._assignTeamService);

  Future<DataState<List<City>>> getAllCities() async {
    try {
      final response = await _assignTeamService.getAllCities();
      final List<City> cities = (response.data['data'] as List)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList();
      return DataSuccess(cities);
    } catch (e) {
      return DataFailed(
        message: e.toString(),
        error: e is DioException ? e : null,
      );
    }
  }

  Future<DataState<dynamic>> assignTeam(
    Team team,
    List<Player> players,
    File? image,
  ) async {
    try {
      final response = await _assignTeamService.assignTeam(team, players, image);
      return DataSuccess(response.data);
    } catch (e) {
      return DataFailed(
        message: e.toString(),
        error: e is DioException ? e : null,
      );
    }
  }
}
