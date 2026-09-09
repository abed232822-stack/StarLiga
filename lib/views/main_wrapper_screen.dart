import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starliga/features/assign_team/presentation/bloc/assign_team_bloc.dart';
import 'package:starliga/features/assign_team/presentation/pages/assign_team_page.dart';
import 'package:starliga/features/home/presentation/bloc/home_bloc.dart';
import 'package:starliga/features/home/presentation/pages/home_page.dart';
import 'package:starliga/features/matches/presentation/bloc/MatchBloc/matches_bloc_bloc.dart';
import 'package:starliga/features/matches/presentation/pages/matches.dart';
import 'package:starliga/features/stats/presentation/pages/main_stats_view.dart';
import 'package:starliga/features/teams/presentation/bloc/TeamBloc/teams_bloc.dart';
import 'package:starliga/features/teams/presentation/pages/teams_page.dart';
import 'package:starliga/utils/colors.dart';

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    const TeamsPage(),
    const AssignTeamPage(),
    const HomePage(),
    const MainStatsView(),
    const MatchesPage(),
  ];

  final List<Map<String, dynamic>> _navItems = const [
    {'icon': Icons.sports_soccer, 'title': 'الفرق'},
    {'icon': Icons.person_add_alt_outlined, 'title': 'تعيين'},
    {'icon': Icons.home_rounded, 'title': 'الرئيسية'},
    {'icon': Icons.stacked_bar_chart_sharp, 'title': 'إحصائيات'},
    {'icon': Icons.sports_sharp, 'title': 'المباريات'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Row(
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
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.navBarBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                color: Colors.black.withValues(alpha: 0.2),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final isSelected = _selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_selectedIndex != index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    }

                    if (index == 0) {
                      final teamsBloc = context.read<TeamsBloc>();
                      teamsBloc.add(FetchCitiesAndTeamsEvent());
                    }
                    if (index == 1) {
                      final assignTeamBloc = context.read<AssignTeamBloc>();
                      assignTeamBloc.add(FetchCitiesEvent());
                    }
                    if (index == 2) {
                      final homeBloc = context.read<HomeBloc>();
                      homeBloc.add(FetchHomeDataEvent());
                    }
                    if (index == 4) {
                      final matchesBloc = context.read<MatchesBloc>();
                      matchesBloc.add(FetchMatchesEvent());
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentYellow
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _navItems[index]['icon'] as IconData,
                          size: 22,
                          color: isSelected
                              ? AppColors.textDark
                              : AppColors.iconInactive,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _navItems[index]['title'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.textDark
                                : AppColors.iconInactive,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
