import 'package:flutter/material.dart';
import 'package:starliga/utils/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.label,
  });

  final VoidCallback onTap;
  final bool isSelected;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.success : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
