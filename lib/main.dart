import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_preview/device_preview.dart';

import 'package:starliga/features/assign_team/presentation/bloc/assign_team_bloc.dart';
import 'package:starliga/features/home/presentation/bloc/home_bloc.dart';
import 'package:starliga/features/matches/presentation/bloc/MatchBloc/matches_bloc_bloc.dart';
import 'package:starliga/features/stats/presentation/bloc/PlayerStats/player_stats_bloc.dart';
import 'package:starliga/features/stats/presentation/bloc/StandingsBloc/standings_bloc.dart';
import 'package:starliga/features/stats/presentation/bloc/TeamStats/team_stats_bloc.dart';
import 'package:starliga/features/teams/presentation/bloc/TeamBloc/teams_bloc.dart';
import 'package:starliga/injection_container.dart';
import 'package:starliga/views/main_wrapper_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const StarLiga(),
    ),
  );
}

class StarLiga extends StatelessWidget {
  const StarLiga({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        fontFamily: 'Tajawal',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(surface: Colors.transparent),
      ),
      debugShowCheckedModeBanner: false,
      title: 'StarLiga',
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                sl<TeamsBloc>()..add(FetchCitiesAndTeamsEvent()),
          ),
          BlocProvider(
            create: (context) =>
                sl<HomeBloc>()..add(FetchHomeDataEvent()),
          ),
          BlocProvider(
            create: (context) =>
                sl<AssignTeamBloc>()..add(FetchCitiesEvent()),
          ),
          BlocProvider(
            create: (context) =>
                sl<MatchesBloc>()..add(FetchMatchesEvent()),
          ),
          BlocProvider(
            create: (context) =>
                sl<PlayerStatsBloc>()..add(LoadPlayerStatsEvent()),
          ),
          BlocProvider(
            create: (context) =>
                sl<TeamStatsBloc>()..add(LoadTeamsStatsEvent()),
          ),
          BlocProvider(
            create: (context) =>
                sl<StandingsBloc>()..add(InitStandingsEvent()),
          ),
        ],
        child: const MainWrapperScreen(),
      ),
    );
  }
}