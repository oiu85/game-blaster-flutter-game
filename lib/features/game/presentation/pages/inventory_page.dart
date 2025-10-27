import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/weapon.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  int _coins = 0;
  WeaponType? _selectedWeapon;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coins = prefs.getInt('player_coins') ?? 0;
      final weaponIndex = prefs.getInt('selected_weapon') ?? 0;
      _selectedWeapon = WeaponType.values[weaponIndex.clamp(0, WeaponType.values.length - 1)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
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
        child: Column(
          children: [
            // Coins display
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.amber, width: 2.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.amber, size: 32.sp),
                  SizedBox(width: 12.w),
                  Text(
                    '$_coins',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Coins',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Owned weapons
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  Text(
                    'Your Weapons',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...WeaponType.values.map((weaponType) {
                    final weapon = Weapon.weapons[weaponType]!;
                    final isSelected = _selectedWeapon == weaponType;
                    return _WeaponInventoryCard(
                      weapon: weapon,
                      weaponType: weaponType,
                      isSelected: isSelected,
                      onSelect: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('selected_weapon', weaponType.index);
                        setState(() {
                          _selectedWeapon = weaponType;
                        });
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${weapon.name} equipped!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeaponInventoryCard extends StatelessWidget {
  final Weapon weapon;
  final WeaponType weaponType;
  final bool isSelected;
  final VoidCallback onSelect;

  const _WeaponInventoryCard({
    required this.weapon,
    required this.weaponType,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isSelected 
            ? Color(weapon.bulletColorValue).withOpacity(0.3)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected 
              ? Color(weapon.bulletColorValue)
              : Colors.white.withOpacity(0.3),
          width: isSelected ? 3.w : 1.w,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Color(weapon.bulletColorValue).withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(weapon.bulletColorValue),
              width: 2.w,
            ),
          ),
          child: Icon(
            _getWeaponIcon(weaponType),
            color: Color(weapon.bulletColorValue),
            size: 28.sp,
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
            Text(
              'Damage: ${weapon.damage} | Speed: ${weapon.bulletSpeed.toStringAsFixed(1)}',
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'EQUIPPED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Colors.green, size: 28.sp)
            : ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(weapon.bulletColorValue),
                  foregroundColor: Colors.white,
                ),
                child: const Text('EQUIP'),
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

