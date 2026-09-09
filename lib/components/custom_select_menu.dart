import 'package:flutter/material.dart';
import 'package:starliga/utils/colors.dart';

class CustomAppDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomAppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: DropdownButtonFormField<T>(
            initialValue: value,
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.iconInactive,
              size: 22,
            ),
            dropdownColor: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontFamily: 'Cairo',
            ),
            hint: Text(
              hint,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
            validator: validator,
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.surface,
              errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.border,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.tertiary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  itemLabel(item),
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}