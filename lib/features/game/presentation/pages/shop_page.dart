import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/weapon.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weapon Shop'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
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
        child: _ShopContent(),
      ),
    );
  }
}

class _ShopContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        Text(
          'Choose Your Weapon',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        ...WeaponType.values.map((weaponType) {
          final weapon = Weapon.weapons[weaponType]!;
          return _WeaponCard(weapon: weapon);
        }),
      ],
    );
  }
}

class _WeaponCard extends StatelessWidget {
  final Weapon weapon;

  const _WeaponCard({required this.weapon});

  Future<void> _selectWeapon(WeaponType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_weapon', type.index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Color(weapon.bulletColorValue).withOpacity(0.5),
          width: 2.w,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: Color(weapon.bulletColorValue).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getWeaponIcon(weapon.type),
            color: Color(weapon.bulletColorValue),
            size: 24.sp,
          ),
        ),
        title: Text(
          weapon.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            _StatRow(label: 'Damage', value: '${weapon.damage}'),
            _StatRow(label: 'Fire Rate', value: '${(60 / weapon.fireRate).toStringAsFixed(1)}/s'),
            _StatRow(label: 'Speed', value: '${weapon.bulletSpeed.toStringAsFixed(1)}'),
            if (weapon.spreadCount > 1)
              _StatRow(label: 'Spread', value: '${weapon.spreadCount} bullets'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
                                // Save selected weapon
                                _selectWeapon(weapon.type);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${weapon.name} selected!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(weapon.bulletColorValue),
            foregroundColor: Colors.white,
          ),
          child: const Text('SELECT'),
        ),
      ),
    );
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

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

