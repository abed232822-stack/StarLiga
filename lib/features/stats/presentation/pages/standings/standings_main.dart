import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starliga/components/app_refresh_indicator.dart';
import 'package:starliga/components/ball_loading_indicator.dart';
import 'package:starliga/components/connection_error.dart';
import 'package:starliga/components/custom_select_menu.dart';
import 'package:starliga/components/match_card.dart';
import 'package:starliga/core/constants/constatnts.dart';
import 'package:starliga/core/enums/tournament_stages.dart';
import 'package:starliga/features/matches/data/models/match_model.dart';
import 'package:starliga/features/matches/presentation/bloc/MatchDetailBloc/match_detail_bloc_bloc.dart';
import 'package:starliga/features/matches/presentation/pages/matches_details.dart';
import 'package:starliga/features/stats/data/models/team_stats.dart';
import 'package:starliga/features/stats/presentation/bloc/StandingsBloc/standings_bloc.dart';
import 'package:starliga/injection_container.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/utils/colors.dart';

class StandingsMain extends StatefulWidget {
  const StandingsMain({super.key});

  @override
  State<StandingsMain> createState() => _StandingsMainState();
}

class _StandingsMainState extends State<StandingsMain> {
  @override
  void initState() {
    super.initState();
    final standingsBloc = context.read<StandingsBloc>();
    if (standingsBloc.state is StandingsInitial) {
      standingsBloc.add(InitStandingsEvent());
    }
  }

  Widget _buildStageMatches(List<MatchModel> matches) {
    if (matches.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: const Center(
              child: Text(
                'لا توجد مباريات لهذه المرحلة',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        final isFinished = match.state != 'tobe';
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => sl<MatchDetailBloc>()
                    ..add(
                      FetchMatchDetailsEvent(
                        matchId: match.id,
                      ),
                    ),
                  child: const MatchesDetails(),
                ),
              ),
            );
          },
          child: MatchCard(
            date: '',
            round: match.stage,
            team1Name: match.team1.name,
            team2Name: match.team2.name,
            stadium: match.place,
            isFinished: isFinished,
            team1Score: isFinished ? match.team1Goals : null,
            team2Score: isFinished ? match.team2Goals : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final standingsBloc = context.watch<StandingsBloc>();
    final isGroupStage =
        standingsBloc.selectedStage == TournamentStage.groupStage;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          child: Column(
            children: [
              CustomAppDropdownField<TournamentStage>(
                itemLabel: (value) => value.label,
                label: 'المرحلة',
                hint: '',
                value: standingsBloc.selectedStage,
                items: TournamentStage.values,
                onChanged: (value) {
                  if (value == null) return;
                  context
                      .read<StandingsBloc>()
                      .add(ChangeStageEvent(value));
                },
              ),
              if (isGroupStage && standingsBloc.cities.isNotEmpty) ...[
                const SizedBox(height: 12),
                CustomAppDropdownField<City>(
                  itemLabel: (city) => city.name,
                  label: 'المدينة',
                  hint: 'اختر المدينة',
                  value: standingsBloc.selectedCity,
                  items: standingsBloc.cities,
                  onChanged: (city) {
                    if (city == null) return;
                    context
                        .read<StandingsBloc>()
                        .add(ChangeCityEvent(city));
                  },
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<StandingsBloc, StandingsState>(
            builder: (context, state) {
              if (state is StandingsLoading) {
                return const Center(
                  child: BallLoadingIndicator(size: 60),
                );
              }

              if (state is StandingsError) {
                return ConnectionErrorWidget(
                  message: state.message,
                  onRetry: () => context
                      .read<StandingsBloc>()
                      .add(RetryStandingsEvent()),
                );
              }

              if (state is StandingsSuccess) {
                return AppRefreshIndicator(
                  onRefresh: () async {
                    context.read<StandingsBloc>().add(RetryStandingsEvent());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _TeamStandingsTable(teams: state.standings),
                  ),
                );
              }

              if (state is StandingsByStageSuccess) {
                return AppRefreshIndicator(
                  onRefresh: () async {
                    context.read<StandingsBloc>().add(RetryStandingsEvent());
                  },
                  child: _buildStageMatches(state.standings),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class _TeamStandingsTable extends StatelessWidget {
  final List<TeamStats> teams;

  const _TeamStandingsTable({required this.teams});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: AppColors.surface,
              child: const Row(
                children: [
                  SizedBox(
                    width: 26,
                    child: Text(
                      '#',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 38),
                  Expanded(
                    child: Text(
                      'الفريق',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                    child: Text(
                      'لعب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  SizedBox(
                    width: 24,
                    child: Text(
                      'فاز',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  SizedBox(
                    width: 30,
                    child: Text(
                      'تعادل',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  SizedBox(
                    width: 24,
                    child: Text(
                      'خسر',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  SizedBox(
                    width: 26,
                    child: Text(
                      'فارق',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 32,
                    child: Text(
                      'نقاط',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            if (teams.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'لا توجد فرق متاحة',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: teams.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, index) {
                  final team = teams[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    color: index % 2 == 0
                        ? Colors.transparent
                        : AppColors.surface.withValues(alpha: 0.3),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 26,
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
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceVariant,
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
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
                                  size: 18,
                                )
                              : null,
                        ),
                        Expanded(
                          child: Text(
                            team.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${team.playedMatchCount ?? 0}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${team.wins ?? 0}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 30,
                          child: Text(
                            '${team.draws ?? 0}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${team.losses ?? 0}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 26,
                          child: Text(
                            '${team.goalDifference}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 32,
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${team.points}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
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
