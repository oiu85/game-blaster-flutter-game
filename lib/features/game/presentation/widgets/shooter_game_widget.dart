import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/shooter_bloc.dart';
import '../bloc/shooter_event.dart';
import '../bloc/shooter_state.dart';
import '../../domain/entities/bullet.dart';
import '../../domain/entities/enemy.dart';
import '../../domain/entities/powerup.dart';

class ShooterGameWidget extends StatelessWidget {
  const ShooterGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShooterBloc, ShooterState>(
      builder: (context, state) {
        return GestureDetector(
          onPanStart: (_) {
            if (!state.isPaused && !state.isGameOver) {
              context.read<ShooterBloc>().add(const PlayerShootStart());
            }
          },
          onPanUpdate: (details) {
            if (!state.isPaused && !state.isGameOver) {
              context.read<ShooterBloc>().add(
                    PlayerMoved(details.delta.dx),
                  );
            }
          },
          onPanEnd: (_) {
            if (!state.isPaused && !state.isGameOver) {
              context.read<ShooterBloc>().add(const PlayerShootStop());
            }
          },
          child: Stack(
            children: [
              // Player
              Positioned(
                left: state.player.x,
                top: state.player.y,
                child: _PlayerWidget(),
              ),

              // Bullets
              ...state.bullets.map((bullet) => _BulletWidget(bullet: bullet)),

              // Enemies
              ...state.enemies.map((enemy) => _EnemyWidget(enemy: enemy)),

              // Power-ups
              ...state.powerUps.map((powerUp) => _PowerUpWidget(powerUp: powerUp)),

              // Explosions
              ...state.explosions.values.map(
                (explosion) => _ExplosionWidget(
                  x: explosion.x,
                  y: explosion.y,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShooterBloc, ShooterState>(
      builder: (context, state) {
        return Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: state.player.hasBoost ? Colors.cyan : Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: state.player.hasBoost ? 3.w : 2.w,
            ),
            boxShadow: [
              BoxShadow(
                color: (state.player.hasBoost ? Colors.cyan : Colors.blue)
                    .withOpacity(0.4),
                blurRadius: state.player.hasBoost ? 12.r : 8.r,
                spreadRadius: 2.r,
              ),
            ],
          ),
          child: Icon(
            Icons.rocket_launch,
            color: Colors.white,
            size: 30.sp,
          ),
        );
      },
    );
  }
}

class _BulletWidget extends StatelessWidget {
  final Bullet bullet;

  const _BulletWidget({required this.bullet});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: bullet.x,
      top: bullet.y,
      child: Stack(
        children: [
          // Bullet trail effect
          if (bullet.isPlayerBullet)
            Container(
              width: bullet.width.w,
              height: bullet.height.h + 20.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.yellow.withOpacity(0.0),
                    Colors.yellow.withOpacity(0.6),
                    Colors.orange.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          // Main bullet
          Container(
            width: bullet.width.w,
            height: bullet.height.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _getBulletColors(bullet.colorValue),
              ),
              borderRadius: BorderRadius.circular(4.r),
              boxShadow: [
                BoxShadow(
                  color: Color(bullet.colorValue).withOpacity(0.4),
                  blurRadius: 4.r,
                  spreadRadius: 1.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getBulletColors(int colorValue) {
    if (colorValue == 0xFFFFFF00) {
      return [Colors.yellow, Colors.orange]; // Basic
    } else if (colorValue == 0xFF00FFFF) {
      return [Colors.cyan, Colors.blue]; // Rapid
    } else if (colorValue == 0xFF00FF00) {
      return [Colors.green, Colors.lightGreen]; // Spread
    } else if (colorValue == 0xFFFF0000) {
      return [Colors.red, Colors.deepOrange]; // Laser
    } else if (colorValue == 0xFFFFA500) {
      return [Colors.orange, Colors.deepOrange]; // Rocket
    }
    return [Colors.yellow, Colors.orange];
  }
}

class _EnemyWidget extends StatelessWidget {
  final Enemy enemy;

  const _EnemyWidget({required this.enemy});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: enemy.x,
      top: enemy.y,
      child: _getEnemyWidget(),
    );
  }

  Widget _getEnemyWidget() {
    switch (enemy.type % 6) {
      case 0: // Basic - Red Circle
        return _CircleEnemy(color: Colors.red, icon: Icons.close);
      case 1: // Fast - Orange Diamond
        return _DiamondEnemy(color: Colors.orange, icon: Icons.star);
      case 2: // Tank - Purple Square
        return _SquareEnemy(color: Colors.purple, icon: Icons.shield);
      case 3: // Ultra Fast - Pink Triangle
        return _TriangleEnemy(color: Colors.pink, icon: Icons.flash_on);
      case 4: // Heavy - Deep Purple Hexagon
        return _HexagonEnemy(color: Colors.deepPurple, icon: Icons.assured_workload);
      case 5: // Super Tank - Brown Octagon
        return _OctagonEnemy(color: Colors.brown, icon: Icons.fort);
      default:
        return _CircleEnemy(color: Colors.red, icon: Icons.close);
    }
  }

  Widget _CircleEnemy({required Color color, required IconData icon}) {
    return Stack(
      children: [
        Container(
          width: enemy.width.w,
          height: enemy.height.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.w),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6.r,
                spreadRadius: 1.r,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24.sp),
        ),
        if (enemy.health > 1) _buildHealthBar(),
      ],
    );
  }

  Widget _DiamondEnemy({required Color color, required IconData icon}) {
    return Stack(
      children: [
        Transform.rotate(
          angle: 0.785, // 45 degrees
          child: Container(
            width: enemy.width.w,
            height: enemy.height.h,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.white, width: 2.w),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.8),
                  blurRadius: 15.r,
                  spreadRadius: 3.r,
                ),
              ],
            ),
            child: Center(
              child: Transform.rotate(
                angle: -0.785,
                child: Icon(icon, color: Colors.white, size: 24.sp),
              ),
            ),
          ),
        ),
        if (enemy.health > 1) _buildHealthBar(),
      ],
    );
  }

  Widget _SquareEnemy({required Color color, required IconData icon}) {
    return Stack(
      children: [
        Container(
          width: enemy.width.w,
          height: enemy.height.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.white, width: 2.w),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6.r,
                spreadRadius: 1.r,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24.sp),
        ),
        if (enemy.health > 1) _buildHealthBar(),
      ],
    );
  }

  Widget _TriangleEnemy({required Color color, required IconData icon}) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(enemy.width.w, enemy.height.h),
          painter: _TrianglePainter(color: color),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
        ),
        if (enemy.health > 1) _buildHealthBar(),
      ],
    );
  }

  Widget _HexagonEnemy({required Color color, required IconData icon}) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(enemy.width.w, enemy.height.h),
          painter: _HexagonPainter(color: color),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
        ),
        if (enemy.health > 1) _buildHealthBar(),
      ],
    );
  }

  Widget _OctagonEnemy({required Color color, required IconData icon}) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(enemy.width.w, enemy.height.h),
          painter: _OctagonPainter(color: color),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
        ),
        if (enemy.health > 1) _buildHealthBar(),
      ],
    );
  }

  Widget _buildHealthBar() {
    return Positioned(
      bottom: -8.h,
      left: 0,
      right: 0,
      child: Container(
        height: 4.h,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(2.r),
        ),
        child: FractionallySizedBox(
          widthFactor: enemy.health / 6.0,
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HexagonPainter extends CustomPainter {
  final Color color;

  _HexagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 2 * math.pi) / 6 - math.pi / 2;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OctagonPainter extends CustomPainter {
  final Color color;

  _OctagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi) / 8 - math.pi / 2;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class _PowerUpWidget extends StatelessWidget {
  final PowerUp powerUp;

  const _PowerUpWidget({required this.powerUp});

  @override
  Widget build(BuildContext context) {
    final color = powerUp.type == PowerUpType.health 
        ? Colors.red 
        : Colors.blue;
    final icon = powerUp.type == PowerUpType.health 
        ? Icons.favorite 
        : Icons.bolt;

    return Positioned(
      left: powerUp.x,
      top: powerUp.y,
      child: Container(
        width: powerUp.width.w,
        height: powerUp.height.h,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.w),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.8),
              blurRadius: 15.r,
              spreadRadius: 3.r,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }
}

class _ExplosionWidget extends StatelessWidget {
  final double x;
  final double y;

  const _ExplosionWidget({required this.x, required this.y});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x - 40,
      top: y - 40,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Particle effects
              ...List.generate(8, (index) {
                final angle = (index * 2 * math.pi) / 8;
                final distance = value * 60;
                return Transform.translate(
                  offset: Offset(
                    math.cos(angle) * distance,
                    math.sin(angle) * distance,
                  ),
                  child: Opacity(
                    opacity: 1 - value,
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.8),
                            blurRadius: 5.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              // Outer explosion ring
              Transform.scale(
                scale: value * 3.0,
                child: Opacity(
                  opacity: 1 - value,
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.8),
                          Colors.orange.withOpacity(0.6),
                          Colors.red.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Middle explosion ring
              Transform.scale(
                scale: value * 2.0,
                child: Opacity(
                  opacity: 1 - value * 0.8,
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.9),
                          Colors.orange.withOpacity(0.7),
                          Colors.red.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Inner explosion core
              Transform.scale(
                scale: value * 1.5,
                child: Opacity(
                  opacity: 1 - value * 0.5,
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.yellow,
                          Colors.orange,
                          Colors.red,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.6),
                          blurRadius: 15.r * value,
                          spreadRadius: 8.r * value,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

