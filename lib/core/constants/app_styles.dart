import 'package:flutter/material.dart';

class AppRadius {
  final double value;

  // Private constructor to initialize the radius value
  const AppRadius._(this.value);

  // Static instances for small, medium, and large radius
  static const AppRadius s = AppRadius._(6.0);
  static const AppRadius m = AppRadius._(12.0);
  static const AppRadius l = AppRadius._(24.0);

  // Methods to get different BorderRadius values
  BorderRadius get top => BorderRadius.vertical(
    top: Radius.circular(value),
    bottom: Radius.zero,
  );

  BorderRadius get bottom => BorderRadius.vertical(
    top: Radius.zero,
    bottom: Radius.circular(value),
  );

  BorderRadius get left => BorderRadius.horizontal(
    left: Radius.circular(value),
    right: Radius.zero,
  );

  BorderRadius get right => BorderRadius.horizontal(
    left: Radius.zero,
    right: Radius.circular(value),
  );

  BorderRadius get all => BorderRadius.all(Radius.circular(value));

  BorderRadius get topLeft => BorderRadius.only(topLeft: Radius.circular(value));

  BorderRadius get topRight => BorderRadius.only(topRight: Radius.circular(value));

  BorderRadius get bottomLeft => BorderRadius.only(bottomLeft: Radius.circular(value));

  BorderRadius get bottomRight => BorderRadius.only(bottomRight: Radius.circular(value));
}
