import 'package:flutter/material.dart';
import 'package:starliga/features/stats/presentation/pages/standings/standings_main.dart';
import 'package:starliga/features/stats/presentation/pages/statistics/stats_main.dart';
import 'package:starliga/utils/colors.dart';

class MainStatsView extends StatefulWidget {
  const MainStatsView({super.key});

  @override
  State<MainStatsView> createState() => _MainStatsViewState();
}

class _MainStatsViewState extends State<MainStatsView> {
  int _currentParentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                right: 16.0,
                left: 16.0,
              ),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        title: 'ترتيب',
                        isSelected: _currentParentTab == 1,
                        onTap: () => setState(() => _currentParentTab = 1),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildTabButton(
                        title: 'إحصائيات',
                        isSelected: _currentParentTab == 0,
                        onTap: () => setState(() => _currentParentTab = 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentParentTab,
                children: [StatsMain(), StandingsMain()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
