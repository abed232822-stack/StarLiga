import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:starliga/components/app_refresh_indicator.dart';
import 'package:starliga/components/ball_loading_indicator.dart';
import 'package:starliga/components/connection_error.dart';
import 'package:starliga/components/custom_carousel.dart';
import 'package:starliga/components/header_text.dart';
import 'package:starliga/components/stats_card.dart';
import 'package:starliga/core/constants/constatnts.dart';
import 'package:starliga/features/home/presentation/bloc/home_bloc.dart';
import 'package:starliga/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const BallLoadingIndicator();
          }

          if (state is HomeError) {
            return ConnectionErrorWidget(
              onRetry: () {
                context.read<HomeBloc>().add(FetchHomeDataEvent());
              },
            );
          }

          if (state is HomeSuccess) {
            final marqueeText = state.marqueeNews.isNotEmpty
                ? state.marqueeNews.map((item) => '${item.body}     |     ').join()
                : '';

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppRefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(FetchHomeDataEvent());
                    },
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomCarousel(news: state.newsWithImages),
                            HeaderText(text: 'الإحصائيات'),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final team = state.teams[index];
                              final imageUrl = team.imageUrl != null &&
                                      team.imageUrl!.isNotEmpty
                                  ? (team.imageUrl!.startsWith('http')
                                      ? team.imageUrl!
                                      : '$ImagesBaseUrl${team.imageUrl}')
                                  : '';
                              return StatsCard(
                                title: team.name,
                                value: '${team.wins ?? 0} فوز',
                                imageUrl: imageUrl,
                              );
                            },
                            childCount: state.teams.length,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                    ],
                  ),
                ),
              ),
                if (marqueeText.isNotEmpty)
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Marquee(
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.accentYellow,
                      ),
                      text: marqueeText,
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
