import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/game_score.dart';

class ScoreBoardWidget extends StatelessWidget {
  final GameScore score;

  const ScoreBoardWidget({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ScoreItem(
              icon: Icons.star,
              label: 'Score',
              value: score.score.toString(),
            ),
            _ScoreItem(
              icon: Icons.flag,
              label: 'Level',
              value: score.level.toString(),
            ),
            _ScoreItem(
              icon: Icons.touch_app,
              label: 'Moves',
              value: score.moves.toString(),
            ),
            _ScoreItem(
              icon: Icons.auto_awesome,
              label: 'Matches',
              value: score.matches.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ScoreItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24.sp, color: Theme.of(context).colorScheme.primary),
        SizedBox(height: 8.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

