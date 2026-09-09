import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:starliga/components/app_refresh_indicator.dart';
import 'package:starliga/components/ball_loading_indicator.dart';
import 'package:starliga/components/connection_error.dart';
import 'package:starliga/components/header_text.dart';
import 'package:starliga/components/match_card.dart';
import 'package:starliga/features/matches/data/models/match_model.dart';
import 'package:starliga/features/matches/presentation/bloc/MatchBloc/matches_bloc_bloc.dart';
import 'package:starliga/features/matches/presentation/bloc/MatchDetailBloc/match_detail_bloc_bloc.dart';
import 'package:starliga/features/matches/presentation/pages/matches_details.dart';
import 'package:starliga/injection_container.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  Widget _buildMatchItem(BuildContext context, MatchModel match, {required bool isPast}) {
    final localDateTime = match.timeDate.toLocal();
    final String matchDate = DateFormat('yyyy-MM-dd').format(localDateTime);
    final String matchTime = DateFormat('hh:mm a').format(localDateTime);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => sl<MatchDetailBloc>()
                ..add(FetchMatchDetailsEvent(matchId: match.id)),
              child: const MatchesDetails(),
            ),
          ),
        );
      },
      child: MatchCard(
        date: matchDate,
        round: match.stage,
        team1Name: match.team1.name,
        team1Logo: match.team1.imageUrl,
        team2Name: match.team2.name,
        team2Logo: match.team2.imageUrl,
        time: isPast ? null : matchTime,
        team1Score: isPast ? match.team1Goals : null,
        team2Score: isPast ? match.team2Goals : null,
        stadium: match.place,
        isFinished: isPast,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchesBloc, MatchesBlocState>(
      builder: (context, state) {
        if (state is MatchesLoadingState) {
          return const BallLoadingIndicator();
        }

        if (state is MatchesSuccessState) {
          final upcoming = state.upcomingMatches ?? [];
          final past = state.pastMatches ?? [];

          return AppRefreshIndicator(
            onRefresh: () async {
              context.read<MatchesBloc>().add(FetchMatchesEvent());
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (upcoming.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: HeaderText(text: 'المباريات القادمة'),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildMatchItem(
                        context,
                        upcoming[index],
                        isPast: false,
                      ),
                      childCount: upcoming.length,
                    ),
                  ),
                ],
                if (past.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: HeaderText(text: 'المباريات السابقة'),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildMatchItem(
                        context,
                        past[index],
                        isPast: true,
                      ),
                      childCount: past.length,
                    ),
                  ),
                ],
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
          );
        }

        if (state is MatchesFailedState) {
          return ConnectionErrorWidget(
            onRetry: () {
              context.read<MatchesBloc>().add(FetchMatchesEvent());
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

