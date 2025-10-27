import 'package:equatable/equatable.dart';
import 'weapon.dart';

enum ShopItemType {
  weapon,
  upgrade,
  powerUp,
}

class ShopItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final int price;
  final ShopItemType type;
  final dynamic itemData; // WeaponType for weapons, or other data for upgrades
  final String iconName;
  final bool isPurchased;
  final bool isEquipped;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.itemData,
    required this.iconName,
    this.isPurchased = false,
    this.isEquipped = false,
  });

  ShopItem copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    ShopItemType? type,
    dynamic itemData,
    String? iconName,
    bool? isPurchased,
    bool? isEquipped,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      type: type ?? this.type,
      itemData: itemData ?? this.itemData,
      iconName: iconName ?? this.iconName,
      isPurchased: isPurchased ?? this.isPurchased,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        type,
        itemData,
        iconName,
        isPurchased,
        isEquipped,
      ];
}

