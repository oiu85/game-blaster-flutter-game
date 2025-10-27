import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/boss.dart';

class CoinWidget extends StatelessWidget {
  final Coin coin;

  const CoinWidget({required this.coin, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: coin.x,
      top: coin.y,
      child: Container(
        width: coin.width.w,
        height: coin.height.h,
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange, width: 2.w),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.5),
              blurRadius: 8.r,
              spreadRadius: 2.r,
            ),
          ],
        ),
        child: Icon(
          Icons.monetization_on,
          color: Colors.orange.shade900,
          size: 16.sp,
        ),
      ),
    );
  }
}

class BossWidget extends StatelessWidget {
  final Boss boss;

  const BossWidget({required this.boss, super.key});

  @override
  Widget build(BuildContext context) {
    Color bossColor;
    IconData bossIcon;
    
    switch (boss.type) {
      case BossType.basic:
        bossColor = Colors.red;
        bossIcon = Icons.dangerous;
        break;
      case BossType.advanced:
        bossColor = Colors.purple;
        bossIcon = Icons.security;
        break;
      case BossType.elite:
        bossColor = Colors.orange;
        bossIcon = Icons.king_bed;
        break;
      case BossType.ultimate:
        bossColor = Colors.black;
        bossIcon = Icons.diamond;
        break;
    }

    return Positioned(
      left: boss.x,
      top: boss.y,
      child: Stack(
        children: [
          Container(
            width: boss.width.w,
            height: boss.height.h,
            decoration: BoxDecoration(
              color: bossColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3.w),
              boxShadow: [
                BoxShadow(
                  color: bossColor.withOpacity(0.6),
                  blurRadius: 20.r,
                  spreadRadius: 5.r,
                ),
              ],
            ),
            child: Icon(bossIcon, color: Colors.white, size: 40.sp),
          ),
          // Health bar
          Positioned(
            bottom: -10.h,
            left: 0,
            right: 0,
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: FractionallySizedBox(
                widthFactor: boss.health / boss.maxHealth,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

