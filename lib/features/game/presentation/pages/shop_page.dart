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

class _ShopContent extends StatefulWidget {
  @override
  State<_ShopContent> createState() => _ShopContentState();
}

class _ShopContentState extends State<_ShopContent> {
  int _coins = 0;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coins = prefs.getInt('player_coins') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Coins Header
        Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade700, Colors.orange.shade700],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.5),
                blurRadius: 15.r,
                spreadRadius: 3.r,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white, size: 32.sp),
              SizedBox(width: 12.w),
              Text(
                '$_coins',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Coins',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              Text(
                'Weapon Shop',
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
                return _WeaponCard(
                  weapon: weapon,
                  weaponType: weaponType,
                  coins: _coins,
                  onPurchase: (newCoins) {
                    setState(() {
                      _coins = newCoins;
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeaponCard extends StatelessWidget {
  final Weapon weapon;
  final WeaponType weaponType;
  final int coins;
  final Function(int) onPurchase;

  const _WeaponCard({
    required this.weapon,
    required this.weaponType,
    required this.coins,
    required this.onPurchase,
  });

  Future<void> _selectWeapon(WeaponType type, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_weapon', type.index);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${weapon.name} equipped!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = _getWeaponPrice(weaponType);
    final canAfford = coins >= price;
    
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
            _getWeaponIcon(weapon.type),
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
            SizedBox(height: 4.h),
            _StatRow(label: 'Damage', value: '${weapon.damage}'),
            _StatRow(label: 'Fire Rate', value: '${(60 / weapon.fireRate).toStringAsFixed(1)}/s'),
            _StatRow(label: 'Speed', value: '${weapon.bulletSpeed.toStringAsFixed(1)}'),
            if (weapon.spreadCount > 1)
              _StatRow(label: 'Spread', value: '${weapon.spreadCount} bullets'),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.amber, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  '$price coins',
                  style: TextStyle(
                    color: canAfford ? Colors.amber : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: canAfford
            ? ElevatedButton(
                onPressed: () async {
                  // Deduct coins
                  final prefs = await SharedPreferences.getInstance();
                  final currentCoins = prefs.getInt('player_coins') ?? 0;
                  await prefs.setInt('player_coins', currentCoins - price);
                  onPurchase(currentCoins - price);
                  // Equip weapon
                  await _selectWeapon(weaponType, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(weapon.bulletColorValue),
                  foregroundColor: Colors.white,
                ),
                child: const Text('BUY & EQUIP'),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Need ${price - coins} more',
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              ),
      ),
    );
  }

  int _getWeaponPrice(WeaponType type) {
    switch (type) {
      case WeaponType.basic:
        return 0; // Free starter weapon
      case WeaponType.rapid:
        return 100;
      case WeaponType.spread:
        return 200;
      case WeaponType.laser:
        return 300;
      case WeaponType.rocket:
        return 500;
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

