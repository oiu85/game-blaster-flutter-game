import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/game_tile.dart';
import '../../../../constants/game_colors.dart';

class GameTileWidget extends StatelessWidget {
  final GameTile tile;
  final VoidCallback onTap;

  const GameTileWidget({
    super.key,
    required this.tile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: GameColors.getColor(tile.colorIndex),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: tile.isSelected
                ? Colors.white
                : Colors.black.withOpacity(0.2),
            width: tile.isSelected ? 4.w : 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: GameColors.getColor(tile.colorIndex).withOpacity(0.5),
              blurRadius: tile.isSelected ? 15.r : 8.r,
              spreadRadius: tile.isSelected ? 2.r : 0,
            ),
          ],
        ),
        child: Center(
          child: tile.isSelected
              ? Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 24.sp,
                )
              : null,
        ),
      ),
    );
  }
}

