import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:starliga/utils/colors.dart';

class MatchTimelineItem extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String minute;
  final String title;
  final String subtitle;
  final String symbol;

  const MatchTimelineItem({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.minute,
    required this.title,
    required this.subtitle,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.9,
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: const LineStyle(color: AppColors.border, thickness: 1.5),
      afterLineStyle: const LineStyle(color: AppColors.border, thickness: 1.5),
      indicatorStyle: IndicatorStyle(
        width: 32,
        height: 32,
        indicator: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(color: AppColors.accentYellow, width: 1.5),
          ),
          child: Text(symbol, style: const TextStyle(fontSize: 14)),
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          "'$minute",
          style: const TextStyle(
            color: AppColors.accentYellow,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      startChild: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
