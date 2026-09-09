import 'package:flutter/material.dart';
import 'package:starliga/utils/colors.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.accentYellow,
      backgroundColor: AppColors.surface,
      strokeWidth: 2.5,
      displacement: 32,
      edgeOffset: 8,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
