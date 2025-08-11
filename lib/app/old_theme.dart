// /// Lighten and darken helper functions
// static Color lighten(Color color, [double amount = 0.1]) {
// final hsl = HSLColor.fromColor(color);
// final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
// return hslLight.toColor();
// }
//
// static Color darken(Color color, [double amount = 0.1]) {
// final hsl = HSLColor.fromColor(color);
// final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
// return hslDark.toColor();
// }
//
// // Light Color Scheme
// static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
// seedColor: primaryColor,
// brightness: Brightness.light,
//
// primary: primaryColor,
// onPrimary: Colors.white,
// primaryContainer: lighten(primaryColor, 0.2),
// onPrimaryContainer: darken(primaryColor, 0.4),
// primaryFixed: lighten(primaryColor, 0.15),
// primaryFixedDim: lighten(primaryColor, 0.3),
// onPrimaryFixed: Colors.white,
// onPrimaryFixedVariant: darken(primaryColor, 0.3),
//
// secondary: secondaryColor,
// onSecondary: Colors.white,
// secondaryContainer: lighten(secondaryColor, 0.2),
// onSecondaryContainer: darken(secondaryColor, 0.4),
// secondaryFixed: lighten(secondaryColor, 0.15),
// secondaryFixedDim: lighten(secondaryColor, 0.3),
// onSecondaryFixed: Colors.white,
// onSecondaryFixedVariant: darken(secondaryColor, 0.3),
//
// tertiary: tertiaryColor,
// onTertiary: Colors.white,
// tertiaryContainer: lighten(tertiaryColor, 0.2),
// onTertiaryContainer: darken(tertiaryColor, 0.4),
// tertiaryFixed: lighten(tertiaryColor, 0.15),
// tertiaryFixedDim: lighten(tertiaryColor, 0.3),
// onTertiaryFixed: Colors.white,
// onTertiaryFixedVariant: darken(tertiaryColor, 0.3),
//
// surface: Colors.white,
// onSurface: Colors.black87,
// surfaceDim: Colors.grey[200],
// surfaceBright: Colors.white,
// surfaceContainerLowest: Colors.grey[50],
// surfaceContainerLow: Colors.grey[100],
// surfaceContainer: Colors.grey[200],
// surfaceContainerHigh: Colors.grey[300],
// surfaceContainerHighest: Colors.grey[400],
// onSurfaceVariant: Colors.black54,
//
// // surface: Colors.white,
// // onSurface: Colors.black87,
// // surfaceDim: darken(Colors.white, 0.05),
// // surfaceBright: lighten(Colors.white, 0.05),
// // surfaceContainerLowest: lighten(Colors.white, 0.15),
// // surfaceContainerLow: lighten(Colors.grey, 0.1),
// // surfaceContainer: Colors.white,
// // surfaceContainerHigh: darken(Colors.white, 0.1),
// // surfaceContainerHighest: darken(Colors.white, 0.15),
// // onSurfaceVariant: darken(Colors.white, 0.4),
//
// // error: Colors.red,
// // onError: Colors.white,
// );
//
// // Dark Color Scheme
// static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
// seedColor: primaryColor,
// brightness: Brightness.dark,
//
// primary: darken(primaryColor, 0.2),
// onPrimary: Colors.white,
// primaryContainer: darken(primaryColor, 0.4),
// onPrimaryContainer: lighten(primaryColor, 0.3),
// primaryFixed: darken(primaryColor, 0.25),
// primaryFixedDim: darken(primaryColor, 0.15),
// onPrimaryFixed: Colors.white,
// onPrimaryFixedVariant: lighten(primaryColor, 0.4),
//
// secondary: darken(secondaryColor, 0.2),
// onSecondary: Colors.white,
// secondaryContainer: darken(secondaryColor, 0.4),
// onSecondaryContainer: lighten(secondaryColor, 0.3),
// secondaryFixed: darken(secondaryColor, 0.25),
// secondaryFixedDim: darken(secondaryColor, 0.15),
// onSecondaryFixed: Colors.white,
// onSecondaryFixedVariant: lighten(secondaryColor, 0.4),
//
// tertiary: darken(tertiaryColor, 0.2),
// onTertiary: Colors.white,
// tertiaryContainer: darken(tertiaryColor, 0.4),
// onTertiaryContainer: lighten(tertiaryColor, 0.3),
// tertiaryFixed: darken(tertiaryColor, 0.25),
// tertiaryFixedDim: darken(tertiaryColor, 0.15),
// onTertiaryFixed: Colors.white,
// onTertiaryFixedVariant: lighten(tertiaryColor, 0.4),
//
// surface: Colors.grey[900],
// onSurface: Colors.white,
// surfaceDim: Colors.grey[800],
// surfaceBright: Colors.grey[700],
// surfaceContainerLowest: Colors.grey[850],
// surfaceContainerLow: Colors.grey[800],
// surfaceContainer: Colors.grey[700],
// surfaceContainerHigh: Colors.grey[600],
// surfaceContainerHighest: Colors.grey[500],
// onSurfaceVariant: Colors.white70,
//
// // surface: Colors.grey.shade900,
// // onSurface: Colors.white,
// // surfaceDim: lighten(Colors.grey.shade900, 0.05),
// // surfaceBright: darken(Colors.grey.shade900, 0.05),
// // surfaceContainerLowest: Colors.grey.shade100,
// // surfaceContainerLow: Colors.grey.shade300,
// // surfaceContainer: Colors.grey.shade500,
// // surfaceContainerHigh: darken(Colors.grey.shade800, 0.1),
// // surfaceContainerHighest: darken(Colors.grey.shade900, 0.15),
// // onSurfaceVariant: darken(Colors.white, 0.4),
//
// // error: Colors.red.shade300,
// // onError: Colors.black,
// );
//
// // static ColorScheme tempLightColorScheme = ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.light);
// // static ColorScheme tempDarkColorScheme = ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.dark);

/*class AppTheme2 {
  static final defFont = GoogleFonts.poppins();
  // static const double defRadius = 12.0;
  static const double defContentPadding = 12.0;
  static const double defScreenPadding = 24.0;

  static const Color primaryColor = Color(0XFF1D2474);

  static const Color primary = Colors.blue;
  static const Color secondary = Colors.orange;
  static const Color tertiary = Colors.green;

  Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static ThemeData light(Color seedColor) {
    // final colorScheme2 = ColorScheme.fromSeed(
    //     seedColor: seedColor,
    //     brightness: Brightness.light,
    // );


    final colorScheme = ColorScheme(
      brightness: Brightness.light,

      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primary.withAlpha(100),
      onPrimaryContainer: primary,
      primaryFixed: primary.withAlpha(100),
      primaryFixedDim: primary.withAlpha(300),
      onPrimaryFixed: primary,
      onPrimaryFixedVariant: primary.withAlpha(500),

      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondary.withAlpha(100),
      onSecondaryContainer: secondary,
      secondaryFixed: secondary.withAlpha(100),
      secondaryFixedDim: secondary.withAlpha(300),
      onSecondaryFixed: secondary,
      onSecondaryFixedVariant: secondary.withAlpha(500),

      tertiary: tertiary,
      onTertiary: Colors.white,
      tertiaryContainer: tertiary.withAlpha(100),
      onTertiaryContainer: tertiary,
      tertiaryFixed: tertiary.withAlpha(100),
      tertiaryFixedDim: tertiary.withAlpha(300),
      onTertiaryFixed: tertiary,
      onTertiaryFixedVariant: tertiary.withAlpha(500),


      error: Colors.red,
      onError: Colors.white,
      // errorContainer: ,
      // onErrorContainer: ,

      surface: Colors.white,
      onSurface: Colors.black87,
      // surfaceDim: ,
      // surfaceBright: ,
      // surfaceContainerLowest: ,
      // surfaceContainerLow: ,
      // surfaceContainer: ,
      // surfaceContainerHigh: ,
      // surfaceContainerHighest: ,
      // onSurfaceVariant: ,

      // outline: ,
      // outlineVariant: ,
      // shadow: ,
      // scrim: ,
      // inverseSurface: ,
      // onInverseSurface: ,
      // inversePrimary: ,
      // surfaceTint: ,
    );

    return defTheme(colorScheme);
  }

  static ThemeData dark(Color seedColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      // surface: Colors.black45,
    );

    return defTheme(colorScheme);
  }

  static ThemeData defTheme(ColorScheme colorScheme) {
    return ThemeData(
        fontFamily: defFont.fontFamily,
        colorScheme: colorScheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          // shadowColor: Colors.transparent,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: colorScheme.primary,
          textTheme: ButtonTextTheme.primary,
        ),

        scaffoldBackgroundColor: colorScheme.surface,

        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          // fillColor: colorScheme.primaryContainer.withOpacity(0.1),
          contentPadding: const EdgeInsets.all(defContentPadding),
          hintStyle: TextStyle(color: Colors.grey.withAlpha(500), fontWeight: FontWeight.w400),
          border: OutlineInputBorder(
              borderRadius: AppStyles.radiusAllS,
              borderSide: BorderSide(color: colorScheme.primary)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: AppStyles.radiusAllS,
              borderSide: BorderSide(color: colorScheme.outline.withAlpha(50))
          ),
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontSize: 14.0),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusAllS)
        ),
        snackBarTheme: SnackBarThemeData(
            shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusAllS),
          // backgroundColor: colorScheme.onSurface
        ),

        dividerTheme: DividerThemeData(
          color: Colors.grey.withAlpha(100)
        ),

        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusAllS)
        )

      // iconButtonTheme: IconButtonThemeData(
      //   style: ButtonStyle(
      //     // backgroundColor: WidgetStateProperty.all(Colors.red),
      //     // foregroundColor: WidgetStateProperty.all(Colors.red),
      //   )
      // )
    );
  }
}*/