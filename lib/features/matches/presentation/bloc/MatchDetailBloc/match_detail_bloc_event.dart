part of 'match_detail_bloc_bloc.dart';

sealed class MatchDetailBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMatchDetailsEvent extends MatchDetailBlocEvent {
  final int matchId;
  FetchMatchDetailsEvent({required this.matchId});
  @override
  List<Object> get props => [matchId];
}
