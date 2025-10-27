import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/page_state.dart';

/// Widget for displaying Lottie animations based on page state
class SimpleLottieAnimation extends StatelessWidget {
  final PageState state;
  final String? loadingAnimationPath;
  final String? successAnimationPath;
  final String? errorAnimationPath;
  final String? emptyAnimationPath;
  final double? width;
  final double? height;

  const SimpleLottieAnimation({
    super.key,
    required this.state,
    this.loadingAnimationPath,
    this.successAnimationPath,
    this.errorAnimationPath,
    this.emptyAnimationPath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    String? animationPath;
    
    switch (state) {
      case PageState.loading:
        animationPath = loadingAnimationPath ?? 'assets/lottie/Loading.json';
        break;
      case PageState.success:
        animationPath = successAnimationPath ?? 'assets/lottie/Loading.json';
        break;
      case PageState.error:
        animationPath = errorAnimationPath ?? 'assets/lottie/NoInternet.json';
        break;
      case PageState.empty:
        animationPath = emptyAnimationPath ?? 'assets/lottie/NoData.json';
        break;
      case PageState.initial:
        return const SizedBox.shrink();
    }

    final path = animationPath!;
    if (path.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: width ?? 200,
      height: height ?? 200,
      child: _buildAnimation(path, state == PageState.loading),
    );
  }

  Widget _buildAnimation(String path, bool repeat) {
    try {
      return Lottie.asset(
        path,
        fit: BoxFit.contain,
        repeat: repeat,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackWidget();
        },
      );
    } catch (e) {
      return _buildFallbackWidget();
    }
  }

  Widget _buildFallbackWidget() {
    switch (state) {
      case PageState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case PageState.error:
        return const Icon(Icons.error, size: 64, color: Colors.red);
      case PageState.empty:
        return const Icon(Icons.inbox, size: 64, color: Colors.grey);
      case PageState.success:
        return const Icon(Icons.check_circle, size: 64, color: Colors.green);
      case PageState.initial:
        return const SizedBox.shrink();
    }
  }
}

