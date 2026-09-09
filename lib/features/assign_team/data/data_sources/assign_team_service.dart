import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:starliga/core/constants/constatnts.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/core/models/team.dart';

class AssignTeamService {
  Future<Response> getAllCities() async {
    try {
      return await dio.get('cities');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> assignTeam(
    Team team,
    List<Player> players,
    File? image,
  ) async {
    try {
      final Map<String, dynamic> dataMap = {
        'team': jsonEncode(team.toJson()),
        'players': jsonEncode(
          players.map((player) => player.toJson()).toList(),
        ),
      };

      if (image != null) {
        dataMap['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(dataMap);
      return await dio.post('teams', data: formData);
    } catch (e) {
      rethrow;
    }
  }
}
