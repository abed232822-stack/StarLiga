import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starliga/components/app_refresh_indicator.dart';
import 'package:starliga/components/ball_loading_indicator.dart';
import 'package:starliga/components/connection_error.dart';
import 'package:starliga/components/header_text.dart';
import 'package:starliga/core/constants/constatnts.dart';
import 'package:starliga/features/stats/data/models/player_stats.dart';
import 'package:starliga/features/stats/presentation/bloc/PlayerStats/player_stats_bloc.dart';
import 'package:starliga/utils/colors.dart';

class PlayersStatsView extends StatelessWidget {
  const PlayersStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerStatsBloc, PlayerStatsState>(
      builder: (context, state) {
        if (state is PlayerStatsLoading) {
          return const Center(child: BallLoadingIndicator());
        } else if (state is PlayerStatsSuccess) {
          return AppRefreshIndicator(
            onRefresh: () async {
              context.read<PlayerStatsBloc>().add(LoadPlayerStatsEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeaderText(text: 'افضل اللاعبين تهديفيا'),
                  PlayerStatsTable(
                    statColumnTitle: 'أهداف',
                    players: state.playersGoalRanking,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: HeaderText(text: 'اكثر اللاعبين بطاقات صفراء'),
                  ),
                  PlayerStatsTable(
                    statColumnTitle: 'بطاقة صفراء',
                    players: state.playersYellowCardsRanking,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: HeaderText(text: 'اكثر اللاعبين بطاقات حمراء'),
                  ),
                  PlayerStatsTable(
                    statColumnTitle: 'بطاقة حمراء',
                    players: state.playersRedCardRanking,
                  ),
                ],
              ),
            ),
          );
        } else if (state is PlayerStatsError) {
          return ConnectionErrorWidget(
            onRetry: () {
              context.read<PlayerStatsBloc>().add(LoadPlayerStatsEvent());
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class PlayerStatsTable extends StatelessWidget {
  final String statColumnTitle;
  final List<PlayerStats> players;

  const PlayerStatsTable({
    super.key,
    required this.statColumnTitle,
    required this.players,
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
                      'اللاعب / الفريق',
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
              itemCount: players.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (context, index) {
                final player = players[index];
                int stat;
                if (statColumnTitle == 'بطاقة صفراء') {
                  stat = player.totalYellowCards ?? 0;
                } else if (statColumnTitle == 'بطاقة حمراء') {
                  stat = player.totalRedCards ?? 0;
                } else {
                  stat = player.totalGoals ?? 0;
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
                          image: player.image != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    ImagesBaseUrl + player.image!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: player.image == null
                            ? const Icon(
                                Icons.person,
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
                              player.fullName,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              player.team?.name ?? '',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
