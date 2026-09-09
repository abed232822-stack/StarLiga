import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starliga/components/app_refresh_indicator.dart';
import 'package:starliga/components/ball_loading_indicator.dart';
import 'package:starliga/components/connection_error.dart';
import 'package:starliga/components/header_text.dart';
import 'package:starliga/core/constants/constatnts.dart';
import 'package:starliga/features/stats/data/models/team_stats.dart';
import 'package:starliga/features/stats/presentation/bloc/TeamStats/team_stats_bloc.dart';
import 'package:starliga/utils/colors.dart';

class TeamStatsView extends StatelessWidget {
  const TeamStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamStatsBloc, TeamStatsState>(
      builder: (context, state) {
        if (state is TeamStatsLoading) {
          return const Center(child: BallLoadingIndicator());
        } else if (state is TeamStatsSuccess) {
          return AppRefreshIndicator(
            onRefresh: () async {
              context.read<TeamStatsBloc>().add(LoadTeamsStatsEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeaderText(text: 'افضل الفرق تهديفيا'),
                  _TeamStatsTable(
                    statColumnTitle: 'أهداف',
                    teams: state.teamsGoalRanking,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: HeaderText(text: 'اكثر الفرق بطاقات صفراء'),
                  ),
                  _TeamStatsTable(
                    statColumnTitle: 'بطاقة صفراء',
                    teams: state.teamsYellowCardsRanking,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: HeaderText(text: 'اكثر الفرق بطاقات حمراء'),
                  ),
                  _TeamStatsTable(
                    statColumnTitle: 'بطاقة حمراء',
                    teams: state.teamsRedCardRanking,
                  ),
                ],
              ),
            ),
          );
        } else if (state is TeamStatsError) {
          return ConnectionErrorWidget(
            onRetry: () {
              context.read<TeamStatsBloc>().add(LoadTeamsStatsEvent());
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _TeamStatsTable extends StatelessWidget {
  final String statColumnTitle;
  final List<TeamStats> teams;

  const _TeamStatsTable({
    required this.statColumnTitle,
    required this.teams,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surface,
              child: Row(
                children: [
                  const SizedBox(
                    width: 32,
                    child: Text(
                      '#',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                  const Expanded(
                    child: Text(
                      'الفريق',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    statColumnTitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teams.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (context, index) {
                final team = teams[index];
                int stat;
                if (statColumnTitle == 'بطاقة صفراء') {
                  stat = team.totalYellowCards ?? 0;
                } else if (statColumnTitle == 'بطاقة حمراء') {
                  stat = team.totalRedCards ?? 0;
                } else {
                  stat = team.totalGoals ?? 0;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  color: index % 2 == 0
                      ? Colors.transparent
                      : AppColors.surface.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceVariant,
                          border: Border.all(color: AppColors.border, width: 1),
                          image: team.imageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    ImagesBaseUrl + team.imageUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: team.imageUrl == null
                            ? const Icon(
                                Icons.shield,
                                color: AppColors.iconInactive,
                                size: 22,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              team.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Text(
                          stat.toString(),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
