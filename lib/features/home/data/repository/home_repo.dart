import 'package:dio/dio.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/home/data/data_sources/home_service.dart';
import 'package:starliga/features/home/data/models/news.dart';

class HomeRepo {
  final HomeService _homeService;
  HomeRepo(this._homeService);

  Future<
    DataState<
      ({List<Team> teams, List<News> marqueeNews, List<News> newsWithImages})
    >
  >
  getHomeData() async {
    try {
      final response = await _homeService.getHomeData();
      final List<Team> teams = (response.data['data']['top_teams'] as List)
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList();
      final List<News> marqueeNews =
          (response.data['data']['news_text_only'] as List)
              .map((e) => News.fromJson(e as Map<String, dynamic>))
              .toList();
      final List<News> newsWithImages =
          (response.data['data']['news_with_image'] as List)
              .map((e) => News.fromJson(e as Map<String, dynamic>))
              .toList();

      return DataSuccess((
        teams: teams,
        marqueeNews: marqueeNews,
        newsWithImages: newsWithImages,
      ));
    } catch (e) {
      return DataFailed(
        message: e.toString(),
        error: e is DioException ? e : null,
      );
    }
  }
}
