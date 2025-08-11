import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00658c),
      surfaceTint: Color(0xff00658c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1aa2db),
      onPrimaryContainer: Color(0xff00344a),
      secondary: Color(0xff3e6379),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffbfe5ff),
      onSecondaryContainer: Color(0xff42677d),
      tertiary: Color(0xff7e469c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbc80da),
      onTertiaryContainer: Color(0xff4b1269),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff6faff),
      onSurface: Color(0xff171c20),
      onSurfaceVariant: Color(0xff3e484f),
      outline: Color(0xff6e7880),
      outlineVariant: Color(0xffbec8d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3135),
      inversePrimary: Color(0xff7fd0ff),
      primaryFixed: Color(0xffc5e7ff),
      onPrimaryFixed: Color(0xff001e2d),
      primaryFixedDim: Color(0xff7fd0ff),
      onPrimaryFixedVariant: Color(0xff004c6a),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff001e2d),
      secondaryFixedDim: Color(0xffa6cbe5),
      onSecondaryFixedVariant: Color(0xff254b60),
      tertiaryFixed: Color(0xfff6d9ff),
      onTertiaryFixed: Color(0xff310049),
      tertiaryFixedDim: Color(0xffe7b3ff),
      onTertiaryFixedVariant: Color(0xff642d82),
      surfaceDim: Color(0xffd6dadf),
      surfaceBright: Color(0xfff6faff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f9),
      surfaceContainer: Color(0xffeaeef3),
      surfaceContainerHigh: Color(0xffe4e9ed),
      surfaceContainerHighest: Color(0xffdfe3e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003a53),
      surfaceTint: Color(0xff00658c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff0075a1),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff113a4f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4d7188),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff521a70),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8e55ac),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6faff),
      onSurface: Color(0xff0d1215),
      onSurfaceVariant: Color(0xff2e373e),
      outline: Color(0xff4a545b),
      outlineVariant: Color(0xff646e76),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3135),
      inversePrimary: Color(0xff7fd0ff),
      primaryFixed: Color(0xff0075a1),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005b7e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4d7188),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff34596f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8e55ac),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff743c91),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc2c7cc),
      surfaceBright: Color(0xfff6faff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f9),
      surfaceContainer: Color(0xffe4e9ed),
      surfaceContainerHigh: Color(0xffd9dde2),
      surfaceContainerHighest: Color(0xffced2d7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003044),
      surfaceTint: Color(0xff00658c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004f6e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff013044),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff274d63),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff470c65),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff673084),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6faff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff242d34),
      outlineVariant: Color(0xff404a52),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3135),
      inversePrimary: Color(0xff7fd0ff),
      primaryFixed: Color(0xff004f6e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00374e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff274d63),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff0b364b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff673084),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4e156c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb5b9be),
      surfaceBright: Color(0xfff6faff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf1f6),
      surfaceContainer: Color(0xffdfe3e8),
      surfaceContainerHigh: Color(0xffd0d5da),
      surfaceContainerHighest: Color(0xffc2c7cc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff7fd0ff),
      surfaceTint: Color(0xff7fd0ff),
      onPrimary: Color(0xff00344a),
      primaryContainer: Color(0xff1aa2db),
      onPrimaryContainer: Color(0xff00344a),
      secondary: Color(0xffa6cbe5),
      onSecondary: Color(0xff083448),
      secondaryContainer: Color(0xff274d62),
      onSecondaryContainer: Color(0xff98bdd6),
      tertiary: Color(0xffe7b3ff),
      onTertiary: Color(0xff4c1269),
      tertiaryContainer: Color(0xffbc80da),
      onTertiaryContainer: Color(0xff4b1269),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffdfe3e8),
      onSurfaceVariant: Color(0xffbec8d0),
      outline: Color(0xff88929a),
      outlineVariant: Color(0xff3e484f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e8),
      inversePrimary: Color(0xff00658c),
      primaryFixed: Color(0xffc5e7ff),
      onPrimaryFixed: Color(0xff001e2d),
      primaryFixedDim: Color(0xff7fd0ff),
      onPrimaryFixedVariant: Color(0xff004c6a),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff001e2d),
      secondaryFixedDim: Color(0xffa6cbe5),
      onSecondaryFixedVariant: Color(0xff254b60),
      tertiaryFixed: Color(0xfff6d9ff),
      onTertiaryFixed: Color(0xff310049),
      tertiaryFixedDim: Color(0xffe7b3ff),
      onTertiaryFixedVariant: Color(0xff642d82),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff353a3e),
      surfaceContainerLowest: Color(0xff0a0f12),
      surfaceContainerLow: Color(0xff171c20),
      surfaceContainer: Color(0xff1b2024),
      surfaceContainerHigh: Color(0xff262b2e),
      surfaceContainerHighest: Color(0xff303539),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb7e2ff),
      surfaceTint: Color(0xff7fd0ff),
      onPrimary: Color(0xff00293b),
      primaryContainer: Color(0xff1aa2db),
      onPrimaryContainer: Color(0xff000509),
      secondary: Color(0xffbce1fc),
      onSecondary: Color(0xff00293b),
      secondaryContainer: Color(0xff7195ad),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff3d1ff),
      onTertiary: Color(0xff40015e),
      tertiaryContainer: Color(0xffbc80da),
      onTertiaryContainer: Color(0xff0b0015),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd3dee7),
      outline: Color(0xffa9b3bc),
      outlineVariant: Color(0xff87929a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e8),
      inversePrimary: Color(0xff004d6c),
      primaryFixed: Color(0xffc5e7ff),
      onPrimaryFixed: Color(0xff00131e),
      primaryFixedDim: Color(0xff7fd0ff),
      onPrimaryFixedVariant: Color(0xff003a53),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff00131e),
      secondaryFixedDim: Color(0xffa6cbe5),
      onSecondaryFixedVariant: Color(0xff113a4f),
      tertiaryFixed: Color(0xfff6d9ff),
      onTertiaryFixed: Color(0xff210033),
      tertiaryFixedDim: Color(0xffe7b3ff),
      onTertiaryFixedVariant: Color(0xff521a70),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff404549),
      surfaceContainerLowest: Color(0xff04080b),
      surfaceContainerLow: Color(0xff191e22),
      surfaceContainer: Color(0xff24282c),
      surfaceContainerHigh: Color(0xff2e3337),
      surfaceContainerHighest: Color(0xff393e42),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe2f2ff),
      surfaceTint: Color(0xff7fd0ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff74ccff),
      onPrimaryContainer: Color(0xff000d16),
      secondary: Color(0xffe2f2ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffa2c8e1),
      onSecondaryContainer: Color(0xff000d16),
      tertiary: Color(0xfffceaff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe5aeff),
      onTertiaryContainer: Color(0xff180027),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe7f1fa),
      outlineVariant: Color(0xffbac4cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e8),
      inversePrimary: Color(0xff004d6c),
      primaryFixed: Color(0xffc5e7ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff7fd0ff),
      onPrimaryFixedVariant: Color(0xff00131e),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffa6cbe5),
      onSecondaryFixedVariant: Color(0xff00131e),
      tertiaryFixed: Color(0xfff6d9ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffe7b3ff),
      onTertiaryFixedVariant: Color(0xff210033),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff4c5155),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b2024),
      surfaceContainer: Color(0xff2c3135),
      surfaceContainerHigh: Color(0xff373c40),
      surfaceContainerHighest: Color(0xff42474b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
