import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BallLoadingIndicator extends StatelessWidget {
  final double size;

  const BallLoadingIndicator({
    super.key,
    this.size = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/animations/soccer-loading.json',
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
}