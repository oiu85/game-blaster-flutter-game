import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../bloc/shooter_bloc.dart';
import '../bloc/shooter_event.dart';
import '../bloc/shooter_state.dart';
import '../../domain/entities/weapon.dart';

class ShooterHudWidget extends StatelessWidget {
  const ShooterHudWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShooterBloc, ShooterState>(
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              // Top HUD
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Score & Wave
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow, size: 18.sp),
                                    SizedBox(width: 6.w),
                                    Text(
                                      '${state.score}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.withOpacity(0.8),
                                      Colors.purple.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 1.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.5),
                                      blurRadius: 8.r,
                                      spreadRadius: 2.r,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.waves,
                                      color: Colors.white,
                                      size: 12.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Wave ${state.wave}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Health & Lives
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.favorite, color: Colors.red, size: 18.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  '${state.player.health}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(Icons.favorite_border, color: Colors.pink, size: 18.sp),
                                SizedBox(width: 2.w),
                                Text(
                                  'x${state.player.lives}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                if (state.player.hasBoost) ...[
                                  SizedBox(width: 6.w),
                                  Icon(Icons.bolt, color: Colors.yellow, size: 18.sp),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Controls row
                      Flexible(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Settings button
                              IconButton(
                                onPressed: () {
                                  context.push('/settings');
                                },
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                  padding: EdgeInsets.all(6.w),
                                  minimumSize: Size(36.w, 36.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              // Pause button
                              IconButton(
                                onPressed: () {
                                  if (state.isPaused) {
                                    context.read<ShooterBloc>().add(const GameResumed());
                                  } else {
                                    context.read<ShooterBloc>().add(const GamePaused());
                                  }
                                },
                                icon: Icon(
                                  state.isPaused ? Icons.play_arrow : Icons.pause,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                  padding: EdgeInsets.all(6.w),
                                  minimumSize: Size(36.w, 36.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom HUD - Weapon indicator
              Positioned(
                bottom: 16.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: _getWeaponColor(state.player.currentWeapon),
                        width: 2.w,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getWeaponIcon(state.player.currentWeapon),
                            color: _getWeaponColor(state.player.currentWeapon),
                            size: 18.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            Weapon.weapons[state.player.currentWeapon]!.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getWeaponColor(WeaponType type) {
    switch (type) {
      case WeaponType.basic:
        return Colors.yellow;
      case WeaponType.rapid:
        return Colors.cyan;
      case WeaponType.spread:
        return Colors.green;
      case WeaponType.laser:
        return Colors.red;
      case WeaponType.rocket:
        return Colors.orange;
    }
  }

  IconData _getWeaponIcon(WeaponType type) {
    switch (type) {
      case WeaponType.basic:
        return Icons.adjust;
      case WeaponType.rapid:
        return Icons.burst_mode;
      case WeaponType.spread:
        return Icons.grain;
      case WeaponType.laser:
        return Icons.bolt;
      case WeaponType.rocket:
        return Icons.rocket_launch;
    }
  }
}

