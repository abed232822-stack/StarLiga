import 'package:flutter/material.dart';
import 'package:starliga/utils/colors.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}