import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:starliga/components/back_button.dart';
import 'package:starliga/components/ball_loading_indicator.dart';
import 'package:starliga/components/connection_error.dart';
import 'package:starliga/components/header_text.dart';
import 'package:starliga/components/match_card.dart';
import 'package:starliga/components/match_time_line.dart';
import 'package:starliga/components/player_wide_card.dart';
import 'package:starliga/features/matches/data/models/match_model.dart';
import 'package:starliga/features/matches/presentation/bloc/MatchDetailBloc/match_detail_bloc_bloc.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/utils/colors.dart';

class MatchesDetails extends StatelessWidget {
  const MatchesDetails({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildAppBar(context),
      body: BlocBuilder<MatchDetailBloc, MatchDetailBlocState>(
        builder: (context, state) {
          if (state is MatchDetailBlocLoading) {
            return const BallLoadingIndicator();
          }

          if (state is MatchDetailBlocSuccess) {
            final match = state.matchModel;
            final isFinished = match.state == 'tobe' ? false : true;
            final localDateTime = match.timeDate.toLocal();
            final String matchDate = DateFormat(
              'yyyy-MM-dd',
            ).format(localDateTime);
            final String matchTime = DateFormat(
              'hh:mm a',
            ).format(localDateTime);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MatchCard(
                    isFinished: isFinished,
                    date: matchDate,
                    time: matchTime,
                    team1Score: isFinished ? match.team1Goals : null,
                    team2Score: isFinished ? match.team2Goals : null,
                    round: match.stage,
                    team1Name: match.team1.name,
                    team2Name: match.team2.name,
                    stadium: match.place,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ExpandablePlayersTile(
                      teamName: match.team1.name,
                      players: match.team1Players,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: ExpandablePlayersTile(
                      players: match.team2Players,
                      teamName: match.team2.name,
                    ),
                  ),

                  HeaderText(text: 'أحداث المباراة'),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: MatchEventsList(match: match),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          }

          if (state is MatchDetailBlocFailure) {
            return ConnectionErrorWidget(
              onRetry: () {
                context.read<MatchDetailBloc>().add(
                  FetchMatchDetailsEvent(matchId: state.matchId),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: const CustomBackButton(),
      toolbarHeight: 80,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(bottom: 10, right: 10),
              child: Icon(
                Icons.sports_soccer,
                color: AppColors.secondary,
                size: 36,
              ),
            ),
            Text(
              'StarLiga',
              style: TextStyle(
                color: AppColors.accentYellow,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Icon(
                Icons.sports_soccer,
                color: AppColors.secondary,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandablePlayersTile extends StatelessWidget {
  const ExpandablePlayersTile({
    super.key,
    required this.players,
    required this.teamName,
  });
  final List<Player> players;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpandableNotifier(
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            iconColor: AppColors.secondary,
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToCollapse: true,
          ),
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'لاعبي $teamName',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          collapsed: const SizedBox.shrink(),
          expanded: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return PlayerWideCard(player: player);
            },
          ),
        ),
      ),
    );
  }
}

class MatchEventsList extends StatelessWidget {
  final MatchModel match;

  const MatchEventsList({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final events = match.events;

    if (events.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'لا توجد أحداث مسجلة لهذه المباراة',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final teamName = event.teamId == match.team1Id
            ? match.team1.name
            : match.team2.name;

        return MatchTimelineItem(
          isFirst: index == 0,
          isLast: index == events.length - 1,

          minute: '',
          title: _getEventTitle(event.type),
          subtitle: "${event.playerName ?? 'لاعب'} ($teamName)",
          symbol: _getEventSymbol(event.type),
        );
      },
    );
  }

  static String _getEventTitle(String type) {
    switch (type.toLowerCase()) {
      case 'goal':
        return 'هدف';
      case 'yellow':
        return 'بطاقة صفراء';
      case 'red':
        return 'بطاقة حمراء';
      default:
        return 'حدث';
    }
  }

  static String _getEventSymbol(String type) {
    switch (type.toLowerCase()) {
      case 'goal':
        return '⚽';
      case 'yellow':
        return '🟨';
      case 'red':
        return '🟥';
      default:
        return '⏱️';
    }
  }
}
