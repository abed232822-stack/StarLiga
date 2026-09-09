part of 'matches_bloc_bloc.dart';

sealed class MatchesBlocEvent extends Equatable {
  const MatchesBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchMatchesEvent extends MatchesBlocEvent {
  const FetchMatchesEvent();
}
