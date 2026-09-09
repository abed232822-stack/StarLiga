import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/matches/data/models/match_model.dart';
import 'package:starliga/features/matches/data/repository/match_repo.dart';

part 'match_detail_bloc_event.dart';
part 'match_detail_bloc_state.dart';

class MatchDetailBloc extends Bloc<MatchDetailBlocEvent, MatchDetailBlocState> {
  final MatchesRepo _matchesRepo;

  MatchDetailBloc(this._matchesRepo) : super(MatchDetailBlocInitial()) {
    on<FetchMatchDetailsEvent>((event, emit) async {
      emit(MatchDetailBlocLoading());
      final response = await _matchesRepo.getMatchDetails(event.matchId);
      if (response is DataSuccess) {
        emit(MatchDetailBlocSuccess(matchModel: response.data!));
      } else if (response is DataFailed) {
        emit(
          MatchDetailBlocFailure(
            error: response.error,
            message: response.message,
            matchId: event.matchId,
          ),
        );
      }
    });
  }
}
