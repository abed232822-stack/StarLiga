import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/core/resources/data_state.dart';
import 'package:starliga/features/teams/data/repository/teams_repo.dart';

part 'team_detail_event.dart';
part 'team_detail_state.dart';

class TeamDetailsBloc extends Bloc<TeamDetailEvent, TeamDetailsState> {
  final TeamsRepo _teamsRepo;

  TeamDetailsBloc(this._teamsRepo) : super(TeamDetailsInitial()) {
    on<FetchTeamDetailsEvent>((event, emit) async {
      emit(TeamDetailsLoading());
      final result = await _teamsRepo.getTeamDetails(event.teamId);
      if (result is DataSuccess) {
        emit(
          TeamDetailsSuccess(
            team: result.data!.team,
            players: result.data!.players,
            city: result.data!.city,
          ),
        );
      } else if (result is DataFailed) {
        emit(
          TeamDetailsError(
            teamId: event.teamId,
            errorMessage: result.message ?? 'حدث خطأ أثناء جلب تفاصيل الفريق',
            error: result.error,
          ),
        );
      }
    });
  }
}
