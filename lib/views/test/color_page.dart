import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';

class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    // final colorScheme = _AppTheme().getDarkColorScheme;

    List<List> colors = [
      ["primary", colorScheme.primary],
      ["onPrimary", colorScheme.onPrimary],
      ["primaryContainer", colorScheme.primaryContainer],
      ["onPrimaryContainer", colorScheme.onPrimaryContainer],
      ["primaryFixed", colorScheme.primaryFixed],
      ["primaryFixedDim", colorScheme.primaryFixedDim],
      ["onPrimaryFixed", colorScheme.onPrimaryFixed],
      ["onPrimaryFixedVariant", colorScheme.onPrimaryFixedVariant],
      ["secondary", colorScheme.secondary],
      ["onSecondary", colorScheme.onSecondary],
      ["secondaryContainer", colorScheme.secondaryContainer],
      ["onSecondaryContainer", colorScheme.onSecondaryContainer],
      ["secondaryFixed", colorScheme.secondaryFixed],
      ["secondaryFixedDim", colorScheme.secondaryFixedDim],
      ["onSecondaryFixed", colorScheme.onSecondaryFixed],
      ["onSecondaryFixedVariant", colorScheme.onSecondaryFixedVariant],
      ["tertiary", colorScheme.tertiary],
      ["onTertiary", colorScheme.onTertiary],
      ["tertiaryContainer", colorScheme.tertiaryContainer],
      ["onTertiaryContainer", colorScheme.onTertiaryContainer],
      ["tertiaryFixed", colorScheme.tertiaryFixed],
      ["tertiaryFixedDim", colorScheme.tertiaryFixedDim],
      ["onTertiaryFixed", colorScheme.onTertiaryFixed],
      ["onTertiaryFixedVariant", colorScheme.onTertiaryFixedVariant],
      ["error", colorScheme.error],
      ["onError", colorScheme.onError],
      ["errorContainer", colorScheme.errorContainer],
      ["onErrorContainer", colorScheme.onErrorContainer],
      ["surface", colorScheme.surface],
      ["onSurface", colorScheme.onSurface],
      ["surfaceDim", colorScheme.surfaceDim],
      ["surfaceBright", colorScheme.surfaceBright],
      ["surfaceContainerLowest", colorScheme.surfaceContainerLowest],
      ["surfaceContainerLow", colorScheme.surfaceContainerLow],
      ["surfaceContainer", colorScheme.surfaceContainer],
      ["surfaceContainerHigh", colorScheme.surfaceContainerHigh],
      ["surfaceContainerHighest", colorScheme.surfaceContainerHighest],
      ["onSurfaceVariant", colorScheme.onSurfaceVariant],
      ["outline", colorScheme.outline],
      ["outlineVariant", colorScheme.outlineVariant],
      ["shadow", colorScheme.shadow],
      ["scrim", colorScheme.scrim],
      ["inverseSurface", colorScheme.inverseSurface],
      ["onInverseSurface", colorScheme.onInverseSurface],
      ["inversePrimary", colorScheme.inversePrimary],
      ["surfaceTint", colorScheme.surfaceTint],
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Colors"),
        actions: [
          IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: const Icon(Icons.brightness_6_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  for(var color in colors)
                    Container(
                      height: 60,
                      width: (constraints.maxWidth - 12.0) * 0.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color[1]
                      ),
                      child: Text(color[0]),
                    )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

class _AppTheme {
  // Define colors
  // static const Color primaryColor = Color(0XFF1B3282); // logo1 color
  // static const Color primaryColor = Color(0XFF213E9B);
  Color primaryColor = const Color(0XFF1D2474);
  Color secondaryColor = const Color(0XFFFB8821);
  Color tertiaryColor = const Color(0XFF178a33);

  /// Lighten and darken helper functions
  Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 0.1));
    return hslDark.toColor();
  }
  /// //////////////////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////////////////
  /// //////////////////////////////////////////////////////////////////////////

  ColorScheme get _primaryLightColorScheme => ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light
  );
  ColorScheme get _primaryDarkColorScheme => ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark
  );

  ColorScheme get _secondaryLightColorScheme => ColorScheme.fromSeed(
      seedColor: secondaryColor,
      brightness: Brightness.light
  );
  ColorScheme get _secondaryDarkColorScheme => ColorScheme.fromSeed(
      seedColor: secondaryColor,
      brightness: Brightness.dark
  );

  ColorScheme get _tertiaryLightColorScheme => ColorScheme.fromSeed(
      seedColor: tertiaryColor,
      brightness: Brightness.light
  );
  ColorScheme get _tertiaryDarkColorScheme => ColorScheme.fromSeed(
      seedColor: tertiaryColor,
      brightness: Brightness.dark
  );

  ColorScheme get getLightColorScheme => ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,

    primary: primaryColor,
    onPrimary: _primaryLightColorScheme.onPrimary,
    primaryContainer: _primaryLightColorScheme.primaryContainer,
    onPrimaryContainer: _primaryLightColorScheme.onPrimaryContainer,
    primaryFixed: _primaryLightColorScheme.primaryFixed,
    primaryFixedDim: _primaryLightColorScheme.primaryFixedDim,
    onPrimaryFixed: _primaryLightColorScheme.onPrimaryFixed,
    onPrimaryFixedVariant: _primaryLightColorScheme.onPrimaryFixedVariant,

    secondary: secondaryColor,
    onSecondary: _secondaryLightColorScheme.onPrimary,
    secondaryContainer: _secondaryLightColorScheme.primaryContainer,
    onSecondaryContainer: _secondaryLightColorScheme.onPrimaryContainer,
    secondaryFixed: _secondaryLightColorScheme.primaryFixed,
    secondaryFixedDim: _secondaryLightColorScheme.primaryFixedDim,
    onSecondaryFixed: _secondaryLightColorScheme.onPrimaryFixed,
    onSecondaryFixedVariant: _secondaryLightColorScheme.onPrimaryFixedVariant,

    tertiary: tertiaryColor,
    onTertiary: _tertiaryLightColorScheme.onPrimary,
    tertiaryContainer: _tertiaryLightColorScheme.primaryContainer,
    onTertiaryContainer: _tertiaryLightColorScheme.onPrimaryContainer,
    tertiaryFixed: _tertiaryLightColorScheme.primaryFixed,
    tertiaryFixedDim: _tertiaryLightColorScheme.primaryFixedDim,
    onTertiaryFixed: _tertiaryLightColorScheme.onPrimaryFixed,
    onTertiaryFixedVariant: _tertiaryLightColorScheme.onPrimaryFixedVariant,

    surface: Colors.white,
    onSurface: Colors.black87,
    surfaceDim: Colors.grey[200],
    surfaceBright: Colors.white,
    surfaceContainerLowest: Colors.grey[50],
    surfaceContainerLow: Colors.grey[100],
    surfaceContainer: Colors.grey[200],
    surfaceContainerHigh: Colors.grey[300],
    surfaceContainerHighest: Colors.grey[400],
    onSurfaceVariant: Colors.black54,

    // error: Colors.red,
    // onError: Colors.white,
  );

  ColorScheme get getDarkColorScheme => ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,

    primary: primaryColor,
    onPrimary: _primaryDarkColorScheme.onPrimary,
    primaryContainer: _primaryDarkColorScheme.primaryContainer,
    onPrimaryContainer: _primaryDarkColorScheme.onPrimaryContainer,
    primaryFixed: _primaryDarkColorScheme.primaryFixed,
    primaryFixedDim: _primaryDarkColorScheme.primaryFixedDim,
    onPrimaryFixed: _primaryDarkColorScheme.onPrimaryFixed,
    onPrimaryFixedVariant: _primaryDarkColorScheme.onPrimaryFixedVariant,

    secondary: secondaryColor,
    onSecondary: _secondaryDarkColorScheme.onPrimary,
    secondaryContainer: _secondaryDarkColorScheme.primaryContainer,
    onSecondaryContainer: _secondaryDarkColorScheme.onPrimaryContainer,
    secondaryFixed: _secondaryDarkColorScheme.primaryFixed,
    secondaryFixedDim: _secondaryDarkColorScheme.primaryFixedDim,
    onSecondaryFixed: _secondaryDarkColorScheme.onPrimaryFixed,
    onSecondaryFixedVariant: _secondaryDarkColorScheme.onPrimaryFixedVariant,

    tertiary: tertiaryColor,
    onTertiary: _tertiaryDarkColorScheme.onPrimary,
    tertiaryContainer: _tertiaryDarkColorScheme.primaryContainer,
    onTertiaryContainer: _tertiaryDarkColorScheme.onPrimaryContainer,
    tertiaryFixed: _tertiaryDarkColorScheme.primaryFixed,
    tertiaryFixedDim: _tertiaryDarkColorScheme.primaryFixedDim,
    onTertiaryFixed: _tertiaryDarkColorScheme.onPrimaryFixed,
    onTertiaryFixedVariant: _tertiaryDarkColorScheme.onPrimaryFixedVariant,

    surface: Colors.grey[900],
    onSurface: Colors.white,
    surfaceDim: Colors.grey[800],
    surfaceBright: Colors.grey[700],
    surfaceContainerLowest: Colors.grey[850],
    surfaceContainerLow: Colors.grey[800],
    surfaceContainer: Colors.grey[700],
    surfaceContainerHigh: Colors.grey[600],
    surfaceContainerHighest: Colors.grey[500],
    onSurfaceVariant: Colors.white70,

    // error: Colors.red.shade300,
    // onError: Colors.black,
  );


  // Light Color Scheme
  ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,

    primary: primaryColor,
    onPrimary: Colors.white,
    primaryContainer: lighten(primaryColor, 0.2),
    onPrimaryContainer: lighten(primaryColor, 0.5),
    primaryFixed: lighten(primaryColor, 0.15),
    primaryFixedDim: lighten(primaryColor, 0.3),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: lighten(primaryColor, 0.3),

    secondary: secondaryColor,
    onSecondary: Colors.white,
    secondaryContainer: lighten(secondaryColor, 0.2),
    onSecondaryContainer: darken(secondaryColor, 0.4),
    secondaryFixed: lighten(secondaryColor, 0.15),
    secondaryFixedDim: lighten(secondaryColor, 0.3),
    onSecondaryFixed: Colors.white,
    onSecondaryFixedVariant: darken(secondaryColor, 0.3),

    tertiary: tertiaryColor,
    onTertiary: Colors.white,
    tertiaryContainer: lighten(tertiaryColor, 0.2),
    onTertiaryContainer: darken(tertiaryColor, 0.4),
    tertiaryFixed: lighten(tertiaryColor, 0.15),
    tertiaryFixedDim: lighten(tertiaryColor, 0.3),
    onTertiaryFixed: Colors.white,
    onTertiaryFixedVariant: darken(tertiaryColor, 0.3),

    surface: Colors.white,
    onSurface: Colors.black87,
    surfaceDim: Colors.grey[200],
    surfaceBright: Colors.white,
    surfaceContainerLowest: Colors.grey[50],
    surfaceContainerLow: Colors.grey[100],
    surfaceContainer: Colors.grey[200],
    surfaceContainerHigh: Colors.grey[300],
    surfaceContainerHighest: Colors.grey[400],
    onSurfaceVariant: Colors.black54,
    // error: Colors.red,
    // onError: Colors.white,
  );

  // Dark Color Scheme
  ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,

    primary: darken(primaryColor, 0.2),
    onPrimary: Colors.white,
    primaryContainer: darken(primaryColor, 0.4),
    onPrimaryContainer: lighten(primaryColor, 0.3),
    primaryFixed: darken(primaryColor, 0.25),
    primaryFixedDim: darken(primaryColor, 0.15),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: lighten(primaryColor, 0.4),

    secondary: darken(secondaryColor, 0.2),
    onSecondary: Colors.white,
    secondaryContainer: darken(secondaryColor, 0.4),
    onSecondaryContainer: lighten(secondaryColor, 0.3),
    secondaryFixed: darken(secondaryColor, 0.25),
    secondaryFixedDim: darken(secondaryColor, 0.15),
    onSecondaryFixed: Colors.white,
    onSecondaryFixedVariant: lighten(secondaryColor, 0.4),

    tertiary: darken(tertiaryColor, 0.2),
    onTertiary: Colors.white,
    tertiaryContainer: darken(tertiaryColor, 0.4),
    onTertiaryContainer: lighten(tertiaryColor, 0.3),
    tertiaryFixed: darken(tertiaryColor, 0.25),
    tertiaryFixedDim: darken(tertiaryColor, 0.15),
    onTertiaryFixed: Colors.white,
    onTertiaryFixedVariant: lighten(tertiaryColor, 0.4),

    surface: Colors.grey[900],
    onSurface: Colors.white,
    surfaceDim: Colors.grey[800],
    surfaceBright: Colors.grey[700],
    surfaceContainerLowest: Colors.grey[850],
    surfaceContainerLow: Colors.grey[800],
    surfaceContainer: Colors.grey[700],
    surfaceContainerHigh: Colors.grey[600],
    surfaceContainerHighest: Colors.grey[500],
    onSurfaceVariant: Colors.white70,

    //   error: Colors.red.shade300,
    //   onError: Colors.black,
  );

}
