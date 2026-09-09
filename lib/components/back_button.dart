import 'package:flutter/material.dart';
import 'package:starliga/utils/colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.accentYellow,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

