import 'package:flutter/material.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/utils/colors.dart';

class PlayerWideCard extends StatelessWidget {
  final Player player;
  final VoidCallback? onDelete; // كولباك اختياري للحذف

  const PlayerWideCard({super.key, required this.player, this.onDelete});

  String _getRoleName(String role) {
    switch (role) {
      case 'C':
        return 'كابتن';
      case 'GK':
        return 'حارس';
      default:
        return 'لاعب';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // زر الحذف (يظهر فقط إذا تم تمرير onDelete)
          if (onDelete != null)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 22,
              ),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (onDelete != null) const SizedBox(width: 8),

          Text(
            '\u200F${player.age} سنة',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColors.accentYellow,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                player.fullName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Text(
                  _getRoleName(player.role),
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 50,
              height: 50,
              child: player.image != null && player.image!.isNotEmpty
                  ? Image.network(
                      player.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(Icons.person, color: AppColors.iconInactive, size: 28),
    );
  }
}
