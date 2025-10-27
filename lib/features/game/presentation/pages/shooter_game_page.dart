import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../bloc/shooter_bloc.dart';
import '../bloc/shooter_event.dart';
import '../bloc/shooter_state.dart';
import '../widgets/shooter_game_widget.dart';
import '../widgets/shooter_hud_widget.dart';
import '../../../../core/utils/page_state.dart';
import '../../../../core/widgets/simple_lottie_animation.dart';

class ShooterGamePage extends StatefulWidget {
  const ShooterGamePage({super.key});

  @override
  State<ShooterGamePage> createState() => _ShooterGamePageState();
}

class _ShooterGamePageState extends State<ShooterGamePage> {
  late final ShooterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ShooterBloc(GetIt.instance.get());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc.state.pageState == PageState.initial) {
      final size = MediaQuery.of(context).size;
      _bloc.add(
        GameInitialized(
          screenWidth: size.width,
          screenHeight: size.height,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: const _ShooterGamePageView(),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}

class _ShooterGamePageView extends StatelessWidget {
  const _ShooterGamePageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShooterBloc, ShooterState>(
        builder: (context, state) {
          if (state.pageState == PageState.loading) {
            return Center(
              child: SimpleLottieAnimation(
                state: PageState.loading,
                width: 200.w,
                height: 200.h,
              ),
            );
          }

          if (state.pageState == PageState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleLottieAnimation(
                    state: PageState.error,
                    width: 200.w,
                    height: 200.h,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    state.errorMessage ?? 'An error occurred',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      final size = MediaQuery.of(context).size;
                      context.read<ShooterBloc>().add(
                            GameInitialized(
                              screenWidth: size.width,
                              screenHeight: size.height,
                            ),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return AnimatedBuilder(
            animation: AlwaysStoppedAnimation(state.screenShake),
            builder: (context, child) {
              final shake = state.screenShake;
              return Transform.translate(
                offset: Offset(
                  (math.Random().nextDouble() - 0.5) * shake,
                  (math.Random().nextDouble() - 0.5) * shake,
                ),
                child: Stack(
                  children: [
                    // Animated background with stars
                    _AnimatedBackground(),

                    // Game widgets
                    ShooterGameWidget(),

              // HUD overlay
              ShooterHudWidget(),

              // Pause overlay
              if (state.isPaused)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'PAUSED',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ShooterBloc>().add(const GameResumed());
                          },
                          child: const Text('Resume'),
                        ),
                      ],
                    ),
                  ),
                ),

              // Game Over overlay
              if (state.isGameOver)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red.withOpacity(0.3),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: 80.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'GAME OVER',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.red.withOpacity(0.8),
                                    blurRadius: 20.r,
                                  ),
                                ],
                              ),
                        ),
                        SizedBox(height: 30.h),
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2.w,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, color: Colors.yellow, size: 24.sp),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Score: ${state.score}',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.waves, color: Colors.blue, size: 24.sp),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Wave ${state.wave}',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<ShooterBloc>().add(const GameReset());
                              },
                              icon: Icon(Icons.refresh, size: 24.sp),
                              label: const Text('Play Again'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                  vertical: 16.h,
                                ),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.go('/menu');
                              },
                              icon: Icon(Icons.home, size: 24.sp),
                              label: const Text('Main Menu'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                  vertical: 16.h,
                                ),
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AnimatedBackground extends StatefulWidget {
  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    // Generate random stars
    for (int i = 0; i < 50; i++) {
      _stars.add(_Star());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.indigo.shade900,
                Colors.purple.shade900,
                Colors.black,
              ],
            ),
          ),
          child: CustomPaint(
            painter: _StarFieldPainter(_stars, _controller.value),
          ),
        );
      },
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double speed;
  final double size;

  _Star()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble(),
        speed = 0.3 + math.Random().nextDouble() * 0.7,
        size = 1 + math.Random().nextDouble() * 2;
}

class _StarFieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double time;

  _StarFieldPainter(this.stars, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (final star in stars) {
      final y = (star.y + time * star.speed) % 1.0;
      paint.color = Colors.white.withOpacity(0.5 + star.speed * 0.5);
      canvas.drawCircle(
        Offset(star.x * size.width, y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

