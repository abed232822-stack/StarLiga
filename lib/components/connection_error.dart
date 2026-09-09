import 'package:flutter/material.dart';
import 'package:starliga/utils/colors.dart';

class ConnectionErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const ConnectionErrorWidget({super.key, required this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple Clean Icon
            const Icon(
              Icons.wifi_off_rounded,
              color: AppColors.accentYellow,
              size: 56,
            ),
            const SizedBox(height: 16),

            // Main Message
            Text(
              message ?? 'فشل الاتصال بالإنترنت',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Simple Outlined Retry Button
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1.2),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: AppColors.accentYellow,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'إعادة المحاولة',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
