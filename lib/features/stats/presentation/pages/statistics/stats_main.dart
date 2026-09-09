import 'package:flutter/material.dart';
import 'package:starliga/components/custom_button.dart';
import 'package:starliga/features/stats/presentation/pages/statistics/players_stats_view.dart';
import 'package:starliga/features/stats/presentation/pages/statistics/team_stats_view.dart';

class StatsMain extends StatefulWidget {
  const StatsMain({super.key});

  @override
  State<StatsMain> createState() => _StatsMainState();
}

class _StatsMainState extends State<StatsMain> {
  int _currentParentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(4),

            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'فرق',
                    isSelected: _currentParentTab == 1,
                    onTap: () {
                      if (_currentParentTab != 1) {
                        setState(() => _currentParentTab = 1);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    label: 'لاعبين',
                    isSelected: _currentParentTab == 0,
                    onTap: () {
                      if (_currentParentTab != 0) {
                        setState(() => _currentParentTab = 0);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _currentParentTab,
            children: const [PlayersStatsView(), TeamStatsView()],
          ),
        ),
      ],
    );
  }
}
