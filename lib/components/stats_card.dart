import 'package:flutter/material.dart';
import 'package:starliga/utils/colors.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String imageUrl;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 140, // ارتفاع ثابت
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        children: [
          // 1. مكان ثابت للأيقونة في الزاوية العلوية اليسرى
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.broken_image,
                    color: AppColors.iconActive,
                    size: 22,
                  );
                },
              ),
            ),
          ),

          // 2. مكان ثابت للعنوان في الزاوية العلوية اليمنى
          Positioned(
            top: 30,
            right: 14,
            width: 82, // عرض مخصص لمنع تداخل النص مع الأيقونة
            child: Text(
              title,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),

          // 3. مكان ثابت للقيمة في الزاوية السفلية اليمنى
          Positioned(
            bottom: 12,
            right: 14,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
