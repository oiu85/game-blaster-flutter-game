import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class LevelsPage extends StatefulWidget {
  const LevelsPage({super.key});

  @override
  State<LevelsPage> createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  int _highestLevelCompleted = 0;
  int _currentCoins = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highestLevelCompleted = prefs.getInt('highest_level_completed') ?? 0;
      _currentCoins = prefs.getInt('player_coins') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Levels'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.amber, width: 1.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.amber, size: 20.sp),
                SizedBox(width: 6.w),
                Text(
                  '$_currentCoins',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
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
        child: Column(
          children: [
            // Progress indicator
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2.w),
              ),
              child: Column(
                children: [
                  Text(
                    'Game Progress',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ProgressStat(
                        icon: Icons.check_circle,
                        label: 'Completed',
                        value: '$_highestLevelCompleted',
                        color: Colors.green,
                      ),
                      _ProgressStat(
                        icon: Icons.lock_open,
                        label: 'Unlocked',
                        value: '${_highestLevelCompleted + 1}',
                        color: Colors.blue,
                      ),
                      _ProgressStat(
                        icon: Icons.lock,
                        label: 'Total',
                        value: '50',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  LinearProgressIndicator(
                    value: _highestLevelCompleted / 50,
                    backgroundColor: Colors.grey.shade700,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    minHeight: 8.h,
                  ),
                ],
              ),
            ),
            // Levels grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.9,
                ),
                itemCount: 50,
                itemBuilder: (context, index) {
                  final levelNumber = index + 1;
                  final isCompleted = levelNumber <= _highestLevelCompleted;
                  final isUnlocked = levelNumber <= _highestLevelCompleted + 1;
                  final isBossLevel = levelNumber % 4 == 0;

                  return _LevelCard(
                    levelNumber: levelNumber,
                    isCompleted: isCompleted,
                    isUnlocked: isUnlocked,
                    isBossLevel: isBossLevel,
                    onTap: isUnlocked
                        ? () {
                            context.go('/');
                            // Start game with specific level
                            Future.delayed(const Duration(milliseconds: 100), () {
                              if (context.mounted) {
                                // Level will be set through SharedPreferences
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setInt('start_level', levelNumber);
                                });
                              }
                            });
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ProgressStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int levelNumber;
  final bool isCompleted;
  final bool isUnlocked;
  final bool isBossLevel;
  final VoidCallback? onTap;

  const _LevelCard({
    required this.levelNumber,
    required this.isCompleted,
    required this.isUnlocked,
    required this.isBossLevel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    IconData iconData;
    String? badge;

    if (!isUnlocked) {
      cardColor = Colors.grey.shade800;
      iconData = Icons.lock;
    } else if (isCompleted) {
      cardColor = Colors.green.shade700;
      iconData = Icons.check_circle;
    } else if (isBossLevel) {
      cardColor = Colors.red.shade800;
      iconData = Icons.local_fire_department;
      badge = 'BOSS';
    } else {
      cardColor = Colors.blue.shade700;
      iconData = Icons.play_circle_outline;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isUnlocked ? Colors.white.withOpacity(0.5) : Colors.grey.shade600,
            width: isBossLevel ? 3.w : 2.w,
          ),
          boxShadow: [
            if (isUnlocked)
              BoxShadow(
                color: cardColor.withOpacity(0.5),
                blurRadius: 8.r,
                spreadRadius: 2.r,
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: Colors.white,
                  size: 32.sp,
                ),
                SizedBox(height: 4.h),
                Text(
                  '$levelNumber',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: 4.h,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

