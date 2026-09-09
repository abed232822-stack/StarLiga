import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/home/data/models/news.dart';
import 'package:starliga/features/home/data/repository/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo _homeRepo;

  HomeBloc(this._homeRepo) : super(HomeInitial()) {
    on<FetchHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      final result = await _homeRepo.getHomeData();
      if (result is DataSuccess) {
        emit(
          HomeSuccess(
            teams: result.data!.teams,
            marqueeNews: result.data!.marqueeNews,
            newsWithImages: result.data!.newsWithImages,
          ),
        );
      } else if (result is DataFailed) {
        emit(
          HomeError(
            errorMessage: result.message ?? 'حدث خطأ أثناء جلب البيانات',
            error: result.error,
          ),
        );
      }
    });
  }
}
