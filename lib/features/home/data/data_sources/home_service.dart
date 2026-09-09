import 'package:dio/dio.dart';
import 'package:starliga/core/constants/constatnts.dart';

class HomeService {
  Future<Response> getHomeData() async {
    try {
      return await dio.get('home');
    } catch (e) {
      rethrow;
    }
  }
}
