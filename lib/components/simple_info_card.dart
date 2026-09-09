import 'package:flutter/material.dart';
import 'package:starliga/utils/colors.dart';

class SimpleInfoCard extends StatelessWidget {
  const SimpleInfoCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
