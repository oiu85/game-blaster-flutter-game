import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game Title
                Text(
                  'SPACE SHOOTER',
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4.w,
                    shadows: [
                      Shadow(
                        color: Colors.blue.withOpacity(0.8),
                        blurRadius: 20.r,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60.h),

                // Play Button
                _MenuButton(
                  text: 'PLAY',
                  icon: Icons.play_arrow,
                  color: Colors.green,
                  onPressed: () => context.go('/'),
                ),
                SizedBox(height: 20.h),

                // Levels Button
                _MenuButton(
                  text: 'LEVELS',
                  icon: Icons.stairs,
                  color: Colors.purple,
                  onPressed: () => context.push('/levels'),
                ),
                SizedBox(height: 20.h),

                // Shop Button
                _MenuButton(
                  text: 'SHOP',
                  icon: Icons.shopping_cart,
                  color: Colors.orange,
                  onPressed: () => context.push('/shop'),
                ),
                SizedBox(height: 20.h),

                // Inventory Button
                _MenuButton(
                  text: 'INVENTORY',
                  icon: Icons.inventory_2,
                  color: Colors.teal,
                  onPressed: () => context.push('/inventory'),
                ),
                SizedBox(height: 20.h),

                // Leaderboard Button
                _MenuButton(
                  text: 'LEADERBOARD',
                  icon: Icons.leaderboard,
                  color: Colors.yellow,
                  onPressed: () => context.push('/leaderboard'),
                ),
                SizedBox(height: 20.h),

                // Settings Button
                _MenuButton(
                  text: 'SETTINGS',
                  icon: Icons.settings,
                  color: Colors.blue,
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.w,
      height: 60.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28.sp),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.w,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          elevation: 8,
          shadowColor: color.withOpacity(0.5),
        ),
      ),
    );
  }
}

