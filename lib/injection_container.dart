import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:starliga/features/assign_team/data/data_sources/assign_team_service.dart';
import 'package:starliga/features/assign_team/data/repository/assign_team_repo.dart';
import 'package:starliga/features/assign_team/presentation/bloc/assign_team_bloc.dart';
import 'package:starliga/features/home/data/data_sources/home_service.dart';
import 'package:starliga/features/home/data/repository/home_repo.dart';
import 'package:starliga/features/home/presentation/bloc/home_bloc.dart';
import 'package:starliga/features/matches/data/data_sources/matches_service.dart';
import 'package:starliga/features/matches/data/repository/match_repo.dart';
import 'package:starliga/features/matches/presentation/bloc/MatchBloc/matches_bloc_bloc.dart';
import 'package:starliga/features/matches/presentation/bloc/MatchDetailBloc/match_detail_bloc_bloc.dart';
import 'package:starliga/features/stats/data/data_sources/players_stats_service.dart';
import 'package:starliga/features/stats/data/data_sources/standings_service.dart';
import 'package:starliga/features/stats/data/data_sources/teams_stats_service.dart';
import 'package:starliga/features/stats/data/repository/playres_stats_repo.dart';
import 'package:starliga/features/stats/data/repository/standing_repo.dart';
import 'package:starliga/features/stats/data/repository/teams_stats_repo.dart';
import 'package:starliga/features/stats/presentation/bloc/PlayerStats/player_stats_bloc.dart';
import 'package:starliga/features/stats/presentation/bloc/StandingsBloc/standings_bloc.dart';
import 'package:starliga/features/stats/presentation/bloc/TeamStats/team_stats_bloc.dart';
import 'package:starliga/features/teams/data/data_sources/teams_service.dart';
import 'package:starliga/features/teams/data/repository/teams_repo.dart';
import 'package:starliga/features/teams/presentation/bloc/TeamBloc/teams_bloc.dart';
import 'package:starliga/features/teams/presentation/bloc/TeamDetailsBloc/team_detail_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Data Sources & Services
  sl.registerSingleton<MatchesService>(MatchesService());
  sl.registerSingleton<PlayersStatsService>(PlayersStatsService());
  sl.registerSingleton<TeamsStatsService>(TeamsStatsService());
  sl.registerSingleton<StandingsService>(StandingsService());
  sl.registerSingleton<HomeService>(HomeService());
  sl.registerSingleton<TeamsService>(TeamsService());
  sl.registerSingleton<AssignTeamService>(AssignTeamService());

  // Repositories
  final matchesRepo = MatchesRepo(sl());
  sl.registerSingleton<MatchesRepo>(matchesRepo);
  sl.registerSingleton<PlayerStatsRepo>(PlayerStatsRepo(sl()));
  sl.registerSingleton<TeamsStatsRepo>(TeamsStatsRepo(sl()));
  sl.registerSingleton<StandingsRepo>(StandingsRepo(sl()));
  sl.registerSingleton<HomeRepo>(HomeRepo(sl()));
  sl.registerSingleton<TeamsRepo>(TeamsRepo(sl()));
  sl.registerSingleton<AssignTeamRepo>(AssignTeamRepo(sl()));

  // Blocs
  sl.registerFactory<MatchesBloc>(() => MatchesBloc(sl()));
  sl.registerFactory<MatchDetailBloc>(() => MatchDetailBloc(sl()));
  sl.registerFactory<PlayerStatsBloc>(() => PlayerStatsBloc(sl()));
  sl.registerFactory<TeamStatsBloc>(() => TeamStatsBloc(sl()));
  sl.registerFactory<StandingsBloc>(() => StandingsBloc(sl()));
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl()));
  sl.registerFactory<TeamsBloc>(() => TeamsBloc(sl()));
  sl.registerFactory<TeamDetailsBloc>(() => TeamDetailsBloc(sl()));
  sl.registerFactory<AssignTeamBloc>(() => AssignTeamBloc(sl()));
}
