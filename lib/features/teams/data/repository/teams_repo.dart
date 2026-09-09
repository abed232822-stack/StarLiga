import 'package:dio/dio.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/teams/data/data_sources/teams_service.dart';

class TeamsRepo {
  final TeamsService _teamsService;

  TeamsRepo(this._teamsService);

  Future<DataState<({List<Team> teams, List<City> cities})>>
  getCitiesAndAcceptedTeams() async {
    try {
      final citiesFuture = _teamsService.getAllCities();
      final teamsFuture = _teamsService.getAllTeams();

      final results = await Future.wait([citiesFuture, teamsFuture]);
      final citiesResponse = results[0];
      final teamsResponse = results[1];

      final List<City> cities = (citiesResponse.data['data'] as List)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList();

      final List rawTeams = teamsResponse.data['data'] as List;
      final List<Team> acceptedTeams = rawTeams
          .where((item) => item['state'] == 'accepted')
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList();

      return DataSuccess((teams: acceptedTeams, cities: cities));
    } catch (e) {
      return DataFailed(
        message: e.toString(),
        error: e is DioException ? e : null,
      );
    }
  }

  Future<DataState<({Team team, List<Player> players, City city})>>
  getTeamDetails(String teamId) async {
    try {
      final response = await _teamsService.getTeamDetails(teamId);
      final data = response.data['data'] as Map<String, dynamic>;

      final List<Player> players = (data['players'] as List)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList();
      final Team team = Team.fromJson(data);
      final City city = City.fromJson(data['city'] as Map<String, dynamic>);

      return DataSuccess((team: team, players: players, city: city));
    } catch (e) {
      return DataFailed(
        message: e.toString(),
        error: e is DioException ? e : null,
      );
    }
  }
}
