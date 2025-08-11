import 'package:flutter/material.dart';

class TileData {
  final bool enabled;
  final IconData? iconData;
  final IconData? leadingIcon;
  final String? title;
  final Widget? titleLabel;
  final String? subtitle;
  final VoidCallback? onTap;
  final Icon? trailingIcon;
  final String? trailingText;

  TileData({
    this.enabled = true,
    this.iconData,
    this.leadingIcon,
    this.title,
    this.titleLabel,
    this.subtitle,
    this.onTap,
    this.trailingIcon,
    this.trailingText,
  });
}