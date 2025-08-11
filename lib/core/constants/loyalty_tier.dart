import 'package:flutter/material.dart';

class LoyaltyTier {
  final String label;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final String iconAsset;
  final String backgroundAsset;

  const LoyaltyTier._({
    required this.label,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.iconAsset,
    required this.backgroundAsset,
  });

  // Static predefined tiers
  static const silver = LoyaltyTier._(
    label: "Silver Member",
    primaryColor: Color(0xFFD7E1EC),
    secondaryColor: Color(0xFF7F8C8D),
    tertiaryColor: Colors.blue,
    iconAsset: 'assets/loyalty/silver-membership.png',
    backgroundAsset: 'assets/loyalty/silver-background-light.png',
  );

  static const gold = LoyaltyTier._(
    label: "Gold Member",
    primaryColor: Color(0xFFFFD700),
    secondaryColor: Color(0xFFB8860B),
    tertiaryColor: Colors.red,
    iconAsset: 'assets/loyalty/gold-membership.png',
    backgroundAsset: 'assets/loyalty/gold-background-light.png',
  );

  static const unknown = LoyaltyTier._(
    label: "Member",
    primaryColor: Colors.grey,
    secondaryColor: Colors.black54,
    tertiaryColor: Colors.black,
    iconAsset: '',
    backgroundAsset: '',
  );

  static LoyaltyTier getTier(String? code) {
    switch (code?.toUpperCase()) {
      case 'SIL':
        return silver;
      case 'GOL' || 'GLD':
        return gold;
      default:
        return unknown;
    }
  }
}
