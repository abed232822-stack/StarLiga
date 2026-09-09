import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starliga/components/app_refresh_indicator.dart';
import 'package:starliga/components/back_button.dart';
import 'package:starliga/components/ball_loading_indicator.dart';
import 'package:starliga/components/connection_error.dart';
import 'package:starliga/components/player_wide_card.dart';
import 'package:starliga/components/simple_info_card.dart';
import 'package:starliga/core/constants/constatnts.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/features/teams/presentation/bloc/TeamDetailsBloc/team_detail_bloc.dart';
import 'package:starliga/utils/colors.dart';

class TeamDetailsPage extends StatelessWidget {
  const TeamDetailsPage({super.key, required this.team});
  final Team team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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
      ),
      body: BlocBuilder<TeamDetailsBloc, TeamDetailsState>(
        builder: (context, state) {
          if (state is TeamDetailsLoading) {
            return const Center(child: BallLoadingIndicator());
          }

          if (state is TeamDetailsError) {
            return ConnectionErrorWidget(
              onRetry: () {
                context.read<TeamDetailsBloc>().add(
                  FetchTeamDetailsEvent(team.id.toString()),
                );
              },
              message: 'إعادة المحاولة',
            );
          }

          if (state is TeamDetailsSuccess) {
            final imageUrl = state.team.imageUrl != null && state.team.imageUrl!.isNotEmpty
                ? (state.team.imageUrl!.startsWith('http')
                    ? state.team.imageUrl!
                    : '$ImagesBaseUrl${state.team.imageUrl}')
                : '';

            return AppRefreshIndicator(
              onRefresh: () async {
                context.read<TeamDetailsBloc>().add(
                      FetchTeamDetailsEvent(team.id.toString()),
                    );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.shield,
                                        color: AppColors.divider,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.team.name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SimpleInfoCard(
                                      label: 'عدد اللاعبين',
                                      value: state.players.length.toString(),
                                    ),
                                    const SizedBox(width: 10),
                                    SimpleInfoCard(
                                      label: 'الاهداف',
                                      value:
                                          (state.team.goalCount ?? 0).toString(),
                                    ),
                                    const SizedBox(width: 10),
                                    SimpleInfoCard(
                                      label: 'المباريات',
                                      value: (state.team.playedMatchCount ?? 0)
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            ': قائمة اللاعبين',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return PlayerWideCard(player: state.players[index]);
                        },
                        childCount: state.players.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
