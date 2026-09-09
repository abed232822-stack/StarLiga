import 'package:flutter/material.dart';
import 'package:starliga/utils/colors.dart';

class CustomAppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomAppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            label,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            onChanged: onChanged,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            cursorColor: AppColors.accentYellow,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.surface,
              prefixIcon: prefixIcon != null
                  ? IconTheme(
                      data: const IconThemeData(color: AppColors.iconInactive),
                      child: prefixIcon!,
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconTheme(
                      data: const IconThemeData(color: AppColors.iconInactive),
                      child: suffixIcon!,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
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
              errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
