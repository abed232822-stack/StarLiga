import 'package:flutter/material.dart';
import 'package:starliga/core/constants/constatnts.dart';
import 'package:starliga/utils/colors.dart';

class MatchCard extends StatelessWidget {
  final String date;
  final String round;
  final String team1Name;
  final String? team1Logo;
  final int? team1Score;
  final String team2Name;
  final String? team2Logo;
  final int? team2Score;
  final String? time;
  final String? stadium;
  final bool isFinished;

  const MatchCard({
    super.key,
    required this.date,
    required this.round,
    required this.team1Name,
    this.team1Logo,
    this.team1Score,
    required this.team2Name,
    this.team2Logo,
    this.team2Score,
    this.time,
    required this.stadium,
    this.isFinished = false,
  });

  String getStage(String stage) {
    switch (stage) {
      case 'province_qualifiers':
        return 'الدوري';
      case 'grand_final':
        return 'النهائي';
      case 'inter_province_tournament':
        return 'نصف النهائي';
      case 'province_league':
        return 'ربع النهائي';
      default:
        return stage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool matchEnded =
        isFinished || (team1Score != null && team2Score != null);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // 1. Header (Date & Round Badge)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  getStage(round),
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2. Teams and Center Info (Time or Result)
          SizedBox(
            height: 110,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _teamColumn(team1Name, team1Logo),
                    _teamColumn(team2Name, team2Logo),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      matchEnded
                          ? '${team1Score ?? 0}  -  ${team2Score ?? 0}'
                          : (time ?? '--:--'),
                      style: const TextStyle(
                        color: AppColors.accentYellow,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      matchEnded ? 'انتهت' : '',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 3. Stadium Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                stadium ?? '',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _teamColumn(String name, String? logo) {
    return SizedBox(
      width: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: logo != null && logo.isNotEmpty
                  ? Image.network(
                      ImagesBaseUrl + logo,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.shield,
                        size: 36,
                        color: AppColors.iconInactive,
                      ),
                    )
                  : const Icon(
                      Icons.shield,
                      size: 36,
                      color: AppColors.iconInactive,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
