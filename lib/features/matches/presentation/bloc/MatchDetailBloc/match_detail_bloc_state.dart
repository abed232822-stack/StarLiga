part of 'match_detail_bloc_bloc.dart';

sealed class MatchDetailBlocState extends Equatable {
  const MatchDetailBlocState();

  @override
  List<Object?> get props => [];
}

final class MatchDetailBlocInitial extends MatchDetailBlocState {}

final class MatchDetailBlocLoading extends MatchDetailBlocState {}

final class MatchDetailBlocSuccess extends MatchDetailBlocState {
  final MatchModel matchModel;
  const MatchDetailBlocSuccess({
    required this.matchModel
  });

  @override
  List<Object?> get props => [
        matchModel
      ];
}

final class MatchDetailBlocFailure extends MatchDetailBlocState {
  final DioException? error;
  final String? message;
  final int matchId;
  const MatchDetailBlocFailure({this.error,this.message, required this.matchId});


  @override
  List<Object?> get props => [error];
}