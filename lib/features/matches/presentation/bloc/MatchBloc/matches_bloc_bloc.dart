import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/matches/data/models/match_model.dart';
import 'package:starliga/features/matches/data/repository/match_repo.dart';

part 'matches_bloc_event.dart';
part 'matches_bloc_state.dart';

class MatchesBloc extends Bloc<MatchesBlocEvent, MatchesBlocState> {
  final MatchesRepo _matchesRepo;

  MatchesBloc(this._matchesRepo) : super(MatchesBlocInitial()) {
    on<FetchMatchesEvent>((event, emit) async {
      emit(const MatchesLoadingState());
      final response = await _matchesRepo.getMatches();
      if (response is DataSuccess) {
        emit(
          MatchesSuccessState(
            pastMatches: response.data!.past,
            upcomingMatches: response.data!.upcoming,
          ),
        );
      } else if (response is DataFailed) {
        emit(
          MatchesFailedState(
            error: response.error,
            errorMessage: response.message ?? response.error?.message,
          ),
        );
      }
    });
  }
}
