part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<Team> teams;
  final List<News> marqueeNews;
  final List<News> newsWithImages;

  const HomeSuccess({
    required this.teams,
    required this.marqueeNews,
    required this.newsWithImages,
  });

  @override
  List<Object?> get props => [teams, marqueeNews, newsWithImages];
}

final class HomeError extends HomeState {
  final String errorMessage;
  final DioException? error;

  const HomeError({required this.errorMessage, this.error});

  @override
  List<Object?> get props => [errorMessage, error];
}
