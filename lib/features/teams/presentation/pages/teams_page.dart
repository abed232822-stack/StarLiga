import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starliga/components/app_refresh_indicator.dart';
import 'package:starliga/components/ball_loading_indicator.dart';
import 'package:starliga/components/connection_error.dart';
import 'package:starliga/components/custom_button.dart';
import 'package:starliga/components/team_card.dart';
import 'package:starliga/features/teams/presentation/bloc/TeamBloc/teams_bloc.dart';
import 'package:starliga/utils/colors.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<TeamsBloc, TeamsState>(
        builder: (context, state) {
          if (state is TeamsLoading) {
            return const Center(child: BallLoadingIndicator());
          }

          if (state is TeamsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  ConnectionErrorWidget(
                    onRetry: () {
                      context.read<TeamsBloc>().add(FetchCitiesAndTeamsEvent());
                    },
                    message: "إعادة المحاولة",
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            );
          }

          if (state is TeamsSuccess) {
            return Column(
              children: [
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.cities.length,
                    itemBuilder: (context, index) {
                      final city = state.cities[index];
                      final isSelected = state.selectedCity.id == city.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomButton(
                          onTap: () {
                            if (!isSelected) {
                              context.read<TeamsBloc>().add(
                                SelectCityEvent(city),
                              );
                            }
                          },
                          isSelected: isSelected,
                          label: city.name,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: AppRefreshIndicator(
                    onRefresh: () async {
                      context.read<TeamsBloc>().add(FetchCitiesAndTeamsEvent());
                    },
                    child: state.teams.isEmpty
                        ? LayoutBuilder(
                            builder: (context, constraints) =>
                                SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Center(
                                  child: Text(
                                    'لا توجد فرق متاحة لـ ${state.selectedCity.name}',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 21,
                            ),
                            padding: const EdgeInsets.all(10),
                            itemCount: state.teams.length,
                            itemBuilder: (context, index) {
                              return TeamCardComponent(
                                team: state.teams[index],
                              );
                            },
                          ),
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
