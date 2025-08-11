import 'package:flutter/material.dart';

/// Generates a set of color variants based on a primary color.
class ColorSchemeVariants {
  final Color container;
  final Color onContainer;
  final Color fixed;
  final Color fixedDim;
  final Color onFixed;
  final Color onFixedVariant;

  ColorSchemeVariants({
    required this.container,
    required this.onContainer,
    required this.fixed,
    required this.fixedDim,
    required this.onFixed,
    required this.onFixedVariant,
  });

  /// Factory method to generate variants from a base primary color.
  factory ColorSchemeVariants.fromPrimary(Color primary) {
    // Helper function to lighten or darken colors using HSL.
    Color adjustColor(Color color, {double lightnessChange = 0, double saturationChange = 0}) {
      final hsl = HSLColor.fromColor(color);
      final adjustedHSL = hsl.withLightness(
        (hsl.lightness + lightnessChange).clamp(0.0, 1.0),
      ).withSaturation(
        (hsl.saturation + saturationChange).clamp(0.0, 1.0),
      );
      return adjustedHSL.toColor();
    }

    return ColorSchemeVariants(
      container: adjustColor(primary, lightnessChange: 0.1),
      onContainer: Colors.white, // Typically high-contrast color
      fixed: adjustColor(primary, lightnessChange: -0.05),
      fixedDim: adjustColor(primary, lightnessChange: -0.15),
      onFixed: Colors.white, // Typically high-contrast color
      onFixedVariant: adjustColor(Colors.white, lightnessChange: -0.2), // Softer onPrimary color
    );
  }
}

// Usage example
void main() {
  const Color primary = Colors.blue; // Replace with your theme's primary color
  final variants = ColorSchemeVariants.fromPrimary(primary);

  print(variants.container); // Color variant outputs
  print(variants.fixed);
  // ... and so on
}
