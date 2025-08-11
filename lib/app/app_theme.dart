import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_styles.dart';
import 'app_routes.dart';

/// v 1.1
class AppTheme {
  static final defFont = GoogleFonts.poppins();
  static const double defContentPadding = 14;

  /// Define colors
  static const Color primaryColor = Color(0XFF1D2474);
  static const Color secondaryColor = Color(0XFFFB8821);
  static const Color tertiaryColor = Color(0XFF178a33);

  /// ColorSchemes according with colors
  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,

    secondary: secondaryColor,
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFFFFD8B0),
    onSecondaryContainer: Color(0xFF3A2000),

    surface: Colors.white, // Deepest light surface
    onSurface: Colors.black87, // Text/icons on light surface
    surfaceDim: Colors.grey[200], // Slightly brighter than white
    surfaceBright: Colors.white, // Used for subtle elevation
    surfaceContainerLowest: Colors.grey[50], // Very light container
    surfaceContainerLow: Colors.grey[100], // light container
    surfaceContainer: Colors.grey[200], // Mid-light
    surfaceContainerHigh: Colors.grey[300], // Higher elevated container
    surfaceContainerHighest: Colors.grey[400], // Most elevated container background
    onSurfaceVariant: Colors.black54, // Secondary text/icons
  );

  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: Colors.white,

    secondary: secondaryColor,
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFFBF6700),
    onSecondaryContainer: Colors.white,
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1D2474),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFCED1EB), // lightened version
    onPrimaryContainer: Color(0xFF00003C),

    secondary: Color(0xFFFB8821),
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFFFFD8B0),
    onSecondaryContainer: Color(0xFF3A2000),

    tertiary: Color(0xFF4A5AC5), // a lighter blue shade
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFD9E0FF),
    onTertiaryContainer: Color(0xFF00174C),

    error: Color(0xFFB3261E),
    onError: Colors.white,
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),

    surface: Colors.white,
    onSurface: Colors.black,
    surfaceContainerHighest: Color(0xFFE1E3EC),
    onSurfaceVariant: Color(0xFF43474E),

    outline: Color(0xFF74777F),
    shadow: Colors.black12,
    inverseSurface: Color(0xFF2F3033),
    onInverseSurface: Color(0xFFF1F1F1),
    inversePrimary: Color(0xFFAEB8FF),

    surfaceTint: Color(0xFF1D2474),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF1D2474),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF30387D),
    onPrimaryContainer: Colors.white,

    secondary: Color(0xFFFB8821),
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFFBF6700),
    onSecondaryContainer: Colors.white,

    tertiary: Color(0xFF9AAEFF),
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFF2B3A6E),
    onTertiaryContainer: Color(0xFFD9E0FF),

    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFFFDAD6),

    surface: Color(0xFF121212),
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF44464F),
    onSurfaceVariant: Color(0xFFC4C6D0),

    outline: Color(0xFF8E9199),
    shadow: Colors.black,
    inverseSurface: Color(0xFFECECEC),
    onInverseSurface: Color(0xFF1C1C1E),
    inversePrimary: Color(0xFFAEB8FF),

    surfaceTint: Color(0xFF1D2474),
  );

  /// Default ThemeData
  static ThemeData _defThemeData(ColorScheme colorScheme, Brightness brightness) => ThemeData(
    colorScheme: colorScheme,
    brightness: brightness,
    fontFamily: defFont.fontFamily,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      // titleTextStyle: TextStyle(color: colorScheme.onSurface),
      scrolledUnderElevation: 0,
      elevation: 0,
      actionsPadding: const EdgeInsets.only(right: 12),
    ),

    actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context){
          final wrapAppBarIcons = RouteUtils.queryParamBool(context, 'wrapAppBarIcons');
          final icon = const Icon(Icons.arrow_back_ios_new);

          return wrapAppBarIcons
              ? Padding(
            padding: EdgeInsets.zero,
            child: CircleAvatar(
              backgroundColor: colorScheme.surfaceDim.withAlpha(200),
              child: icon,
            ),
          )
              : icon;
        }
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: colorScheme.primary,
      textTheme: ButtonTextTheme.primary,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 1,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    ),

    // scaffoldBackgroundColor: colorScheme.surface,

    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      contentPadding: const EdgeInsets.all(defContentPadding),
      hintStyle: TextStyle(fontSize: 14),
      // hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withAlpha(100)),
      border: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: BorderSide.none
        // borderSide: BorderSide(width: 0.6, color: colorScheme.primary)
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: BorderSide.none
        // borderSide: BorderSide(width: 0.6, color: Colors.grey[300]!)
      ),
      disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          // borderSide: BorderSide(width: 0.5, color: Colors.grey[200]!)
          borderSide: BorderSide.none
        // borderSide: const BorderSide(width: 0.6)
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: const BorderSide(width: 0.8, color: Colors.red)
      ),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: const BorderSide(color: Colors.redAccent)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: BorderSide(color: colorScheme.primaryContainer, width: 1.2)
      ),
      // outlineBorder: const BorderSide(width: 0.6),
    ),


    textTheme: const TextTheme(
      // titleMedium: TextStyle(fontSize: 14.0),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all),
      backgroundColor: colorScheme.surface,
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all),
    ),

    snackBarTheme: SnackBarThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all),
      // backgroundColor: colorScheme.onSurface
    ),

    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius:AppRadius.m.all)),
            textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16))
        )
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius:AppRadius.m.all)),
            textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16))
        )
    ),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius:AppRadius.m.all)),
        )
    ),

    dividerTheme: DividerThemeData(
        color: colorScheme.outline.withAlpha(50)
    ),

    listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all)
    ),


    // iconButtonTheme: IconButtonThemeData(
    //   style: ButtonStyle(
    //     // backgroundColor: WidgetStateProperty.all(Colors.red),
    //     // foregroundColor: WidgetStateProperty.all(Colors.red),
    //   )
    // )
  );

  /// Light ThemeData
  static ThemeData light = _defThemeData(_lightColorScheme, Brightness.light);

  /// Dark ThemeData
  static ThemeData dark = _defThemeData(_darkColorScheme, Brightness.dark);
}
/// v 1.0
/*class AppTheme {
  static final defFont = GoogleFonts.poppins();
  static const double defContentPadding = 14;

  /// Define colors
  static const Color primaryColor = Color(0XFF1D2474);
  static const Color secondaryColor = Color(0XFFFB8821);
  static const Color tertiaryColor = Color(0XFF178a33);

  /// ColorSchemes according with colors
  static final ColorScheme _primaryLightColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light
  );
  static final ColorScheme _primaryDarkColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark
  );

  static final ColorScheme _secondaryLightColorScheme = ColorScheme.fromSeed(
      seedColor: secondaryColor,
      brightness: Brightness.light
  );
  static final ColorScheme _secondaryDarkColorScheme = ColorScheme.fromSeed(
      seedColor: secondaryColor,
      brightness: Brightness.dark
  );

  static final ColorScheme _tertiaryLightColorScheme = ColorScheme.fromSeed(
      seedColor: tertiaryColor,
      brightness: Brightness.light
  );
  static final ColorScheme _tertiaryDarkColorScheme = ColorScheme.fromSeed(
      seedColor: tertiaryColor,
      brightness: Brightness.dark
  );

  static final ColorScheme _getLightColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,

    // primary: primaryColor,
    // onPrimary: Colors.white, // _primaryLightColorScheme.onPrimary,
    // primaryContainer: _primaryLightColorScheme.primaryContainer,
    // onPrimaryContainer: _primaryLightColorScheme.onPrimaryContainer,
    // primaryFixed: _primaryLightColorScheme.primaryFixed,
    // primaryFixedDim: _primaryLightColorScheme.primaryFixedDim,
    // onPrimaryFixed: _primaryLightColorScheme.onPrimaryFixed,
    // onPrimaryFixedVariant: _primaryLightColorScheme.onPrimaryFixedVariant,

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

  );

  static final ColorScheme _getDarkColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,

    // primary: Color(0XFF151A5A), //_primaryDarkColorScheme.primary,
    // onPrimary: Colors.white, //_primaryDarkColorScheme.onPrimary,
    // primaryContainer: _primaryDarkColorScheme.primaryContainer,
    // onPrimaryContainer: _primaryDarkColorScheme.onPrimaryContainer,
    // primaryFixed: _primaryDarkColorScheme.primaryFixed,
    // primaryFixedDim: _primaryDarkColorScheme.primaryFixedDim,
    // onPrimaryFixed: _primaryDarkColorScheme.onPrimaryFixed,
    // onPrimaryFixedVariant: _primaryDarkColorScheme.onPrimaryFixedVariant,

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

    // surface: Colors.black, // 900
    // onSurface: Colors.white,
    // surfaceDim: Colors.grey[800],
    // surfaceBright: Colors.grey[700],
    // surfaceContainerLowest: Colors.grey[850], // 850
    // surfaceContainerLow: Colors.grey[800], // 850
    // surfaceContainer: Colors.grey[700], // 700
    // surfaceContainerHigh: Colors.grey[600], // 600
    // surfaceContainerHighest: Colors.grey[400], // 400
    // onSurfaceVariant: Colors.white70,

    surface: Colors.black, // Deepest dark surface
    onSurface: Colors.white, // Text/icons on dark surface
    surfaceDim: Colors.grey[900], // Slightly brighter than black
    surfaceBright: Colors.grey[850], // Used for subtle elevation
    surfaceContainerLowest: Colors.grey[850], // Very dark container
    surfaceContainerLow: Colors.grey[800], // Dark container
    surfaceContainer: Colors.grey[750] ?? Color(0xFF4B4B4B), // Mid-dark (custom if 750 is not defined)
    surfaceContainerHigh: Colors.grey[700], // Higher elevated container
    surfaceContainerHighest: Colors.grey[600], // Most elevated container background
    onSurfaceVariant: Colors.white70, // Secondary text/icons

    // error: Colors.red.shade300,
    // onError: Colors.black,
  );

  /// Default ThemeData
  static ThemeData _defThemeData(ColorScheme colorScheme, Brightness brightness) => ThemeData(
    colorScheme: colorScheme,
    brightness: brightness,
    fontFamily: defFont.fontFamily,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      // titleTextStyle: TextStyle(color: colorScheme.onSurface),
      scrolledUnderElevation: 0,
      elevation: 0,

    ),

    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context){
        return Icon(Icons.arrow_back_ios_new);
      }
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: colorScheme.primary,
      textTheme: ButtonTextTheme.primary,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 1,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    ),

    // scaffoldBackgroundColor: colorScheme.surface,

    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      contentPadding: const EdgeInsets.all(defContentPadding),
      hintStyle: TextStyle(fontSize: 14),
      // hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withAlpha(100)),
      border: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: BorderSide.none
        // borderSide: BorderSide(width: 0.6, color: colorScheme.primary)
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: BorderSide.none
        // borderSide: BorderSide(width: 0.6, color: Colors.grey[300]!)
      ),
      disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          // borderSide: BorderSide(width: 0.5, color: Colors.grey[200]!)
          borderSide: BorderSide.none
        // borderSide: const BorderSide(width: 0.6)
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: const BorderSide(width: 0.8, color: Colors.red)
      ),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: const BorderSide(color: Colors.redAccent)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.m.all,
          borderSide: BorderSide(color: colorScheme.primaryContainer, width: 1.2)
      ),
      // outlineBorder: const BorderSide(width: 0.6),
    ),


    textTheme: const TextTheme(
      // titleMedium: TextStyle(fontSize: 14.0),
    ),
    dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all),
      backgroundColor: colorScheme.surface,
    ),
    snackBarTheme: SnackBarThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all),
      // backgroundColor: colorScheme.onSurface
    ),

    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius:AppRadius.m.all)),
            textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16))
        )
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius:AppRadius.m.all)),
            textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16))
        )
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius:AppRadius.m.all)),
      )
    ),

    dividerTheme: DividerThemeData(
        color: colorScheme.outline.withAlpha(50)
    ),

    listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all)
    ),


    // iconButtonTheme: IconButtonThemeData(
    //   style: ButtonStyle(
    //     // backgroundColor: WidgetStateProperty.all(Colors.red),
    //     // foregroundColor: WidgetStateProperty.all(Colors.red),
    //   )
    // )
  );

  /// Light ThemeData
  static ThemeData light = _defThemeData(_getLightColorScheme, Brightness.light);

  /// Dark ThemeData
  static ThemeData dark = _defThemeData(_getDarkColorScheme, Brightness.dark);
}*/

// class AppThemeOLD {
//   static final defFont = GoogleFonts.poppins();
//   static const double defContentPadding = 14;
//   static const double defScreenPadding = 24;
//
//   /// Define colors
//   static const Color primaryColor = Color(0XFF1D2474);
//   static const Color secondaryColor = Color(0XFFFB8821);
//   static const Color tertiaryColor = Color(0XFF178a33);
//
//   /// ColorSchemes according with colors
//   static final ColorScheme _primaryLightColorScheme = ColorScheme.fromSeed(
//       seedColor: primaryColor,
//       brightness: Brightness.light
//   );
//   static final ColorScheme _primaryDarkColorScheme = ColorScheme.fromSeed(
//       seedColor: primaryColor,
//       brightness: Brightness.dark
//   );
//
//   static final ColorScheme _secondaryLightColorScheme = ColorScheme.fromSeed(
//       seedColor: secondaryColor,
//       brightness: Brightness.light
//   );
//   static final ColorScheme _secondaryDarkColorScheme = ColorScheme.fromSeed(
//       seedColor: secondaryColor,
//       brightness: Brightness.dark
//   );
//
//   static final ColorScheme _tertiaryLightColorScheme = ColorScheme.fromSeed(
//       seedColor: tertiaryColor,
//       brightness: Brightness.light
//   );
//   static final ColorScheme _tertiaryDarkColorScheme = ColorScheme.fromSeed(
//       seedColor: tertiaryColor,
//       brightness: Brightness.dark
//   );
//
//   static final ColorScheme _getLightColorScheme = ColorScheme.fromSeed(
//     seedColor: primaryColor,
//     brightness: Brightness.light,
//
//     // primary: primaryColor,
//     // onPrimary: Colors.white, // _primaryLightColorScheme.onPrimary,
//     // primaryContainer: _primaryLightColorScheme.primaryContainer,
//     // onPrimaryContainer: _primaryLightColorScheme.onPrimaryContainer,
//     // primaryFixed: _primaryLightColorScheme.primaryFixed,
//     // primaryFixedDim: _primaryLightColorScheme.primaryFixedDim,
//     // onPrimaryFixed: _primaryLightColorScheme.onPrimaryFixed,
//     // onPrimaryFixedVariant: _primaryLightColorScheme.onPrimaryFixedVariant,
//
//     secondary: secondaryColor,
//     onSecondary: _secondaryLightColorScheme.onPrimary,
//     secondaryContainer: _secondaryLightColorScheme.primaryContainer,
//     onSecondaryContainer: _secondaryLightColorScheme.onPrimaryContainer,
//     secondaryFixed: _secondaryLightColorScheme.primaryFixed,
//     secondaryFixedDim: _secondaryLightColorScheme.primaryFixedDim,
//     onSecondaryFixed: _secondaryLightColorScheme.onPrimaryFixed,
//     onSecondaryFixedVariant: _secondaryLightColorScheme.onPrimaryFixedVariant,
//
//     tertiary: tertiaryColor,
//     onTertiary: _tertiaryLightColorScheme.onPrimary,
//     tertiaryContainer: _tertiaryLightColorScheme.primaryContainer,
//     onTertiaryContainer: _tertiaryLightColorScheme.onPrimaryContainer,
//     tertiaryFixed: _tertiaryLightColorScheme.primaryFixed,
//     tertiaryFixedDim: _tertiaryLightColorScheme.primaryFixedDim,
//     onTertiaryFixed: _tertiaryLightColorScheme.onPrimaryFixed,
//     onTertiaryFixedVariant: _tertiaryLightColorScheme.onPrimaryFixedVariant,
//
//     surface: Colors.white,
//     onSurface: Colors.black87,
//     surfaceDim: Colors.grey[200],
//     surfaceBright: Colors.white,
//     surfaceContainerLowest: Colors.grey[50],
//     surfaceContainerLow: Colors.grey[100],
//     surfaceContainer: Colors.grey[200],
//     surfaceContainerHigh: Colors.grey[300],
//     surfaceContainerHighest: Colors.grey[400],
//     onSurfaceVariant: Colors.black54,
//
//     // error: Colors.red,
//     // onError: Colors.white,
//   );
//
//
//   static final ColorScheme _getDarkColorScheme = ColorScheme.fromSeed(
//     seedColor: primaryColor,
//     brightness: Brightness.dark,
//
//     // primary: Color(0XFF151A5A), //_primaryDarkColorScheme.primary,
//     // onPrimary: Colors.white, //_primaryDarkColorScheme.onPrimary,
//     // primaryContainer: _primaryDarkColorScheme.primaryContainer,
//     // onPrimaryContainer: _primaryDarkColorScheme.onPrimaryContainer,
//     // primaryFixed: _primaryDarkColorScheme.primaryFixed,
//     // primaryFixedDim: _primaryDarkColorScheme.primaryFixedDim,
//     // onPrimaryFixed: _primaryDarkColorScheme.onPrimaryFixed,
//     // onPrimaryFixedVariant: _primaryDarkColorScheme.onPrimaryFixedVariant,
//
//     secondary: secondaryColor,
//     onSecondary: _secondaryDarkColorScheme.onPrimary,
//     secondaryContainer: _secondaryDarkColorScheme.primaryContainer,
//     onSecondaryContainer: _secondaryDarkColorScheme.onPrimaryContainer,
//     secondaryFixed: _secondaryDarkColorScheme.primaryFixed,
//     secondaryFixedDim: _secondaryDarkColorScheme.primaryFixedDim,
//     onSecondaryFixed: _secondaryDarkColorScheme.onPrimaryFixed,
//     onSecondaryFixedVariant: _secondaryDarkColorScheme.onPrimaryFixedVariant,
//
//     tertiary: tertiaryColor,
//     onTertiary: _tertiaryDarkColorScheme.onPrimary,
//     tertiaryContainer: _tertiaryDarkColorScheme.primaryContainer,
//     onTertiaryContainer: _tertiaryDarkColorScheme.onPrimaryContainer,
//     tertiaryFixed: _tertiaryDarkColorScheme.primaryFixed,
//     tertiaryFixedDim: _tertiaryDarkColorScheme.primaryFixedDim,
//     onTertiaryFixed: _tertiaryDarkColorScheme.onPrimaryFixed,
//     onTertiaryFixedVariant: _tertiaryDarkColorScheme.onPrimaryFixedVariant,
//
//     surface: Colors.grey[900], // 900
//     onSurface: Colors.white,
//     surfaceDim: Colors.grey[800],
//     surfaceBright: Colors.grey[700],
//     surfaceContainerLowest: Colors.grey[850], // 850
//     surfaceContainerLow: Colors.grey[800], // 850
//     surfaceContainer: Colors.grey[700], // 700
//     surfaceContainerHigh: Colors.grey[600], // 600
//     surfaceContainerHighest: Colors.grey[400], // 400
//     onSurfaceVariant: Colors.white70,
//
//     // error: Colors.red.shade300,
//     // onError: Colors.black,
//   );
//
//   /// Default ThemeData
//   static ThemeData _defThemeData(ColorScheme colorScheme, Brightness brightness) => ThemeData(
//     colorScheme: colorScheme,
//     brightness: brightness,
//     fontFamily: defFont.fontFamily,
//     useMaterial3: true,
//     appBarTheme: AppBarTheme(
//       backgroundColor: colorScheme.surface,
//       foregroundColor: colorScheme.onSurface,
//       // titleTextStyle: TextStyle(color: colorScheme.onSurface),
//       scrolledUnderElevation: 0,
//       elevation: 0,
//
//     ),
//
//     actionIconTheme: ActionIconThemeData(
//         backButtonIconBuilder: (context){
//           return Icon(Icons.arrow_back_ios_new);
//         }
//     ),
//     buttonTheme: ButtonThemeData(
//       buttonColor: colorScheme.primary,
//       textTheme: ButtonTextTheme.primary,
//     ),
//
//     floatingActionButtonTheme: FloatingActionButtonThemeData(
//       elevation: 1,
//       backgroundColor: colorScheme.surface,
//       foregroundColor: colorScheme.onSurface,
//     ),
//
//     // scaffoldBackgroundColor: colorScheme.surface,
//
//     inputDecorationTheme: InputDecorationTheme(
//       isDense: true,
//       filled: false,
//       fillColor: colorScheme.surfaceContainerLow,
//       contentPadding: const EdgeInsets.all(defContentPadding),
//       // hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withAlpha(100)),
//       border: OutlineInputBorder(
//           borderRadius: AppRadius.m.all,
//           borderSide: BorderSide.none
//         // borderSide: BorderSide(width: 0.6, color: colorScheme.primary)
//       ),
//       enabledBorder: OutlineInputBorder(
//           borderRadius: AppRadius.m.all,
//           // borderSide: BorderSide.none
//           borderSide: BorderSide(width: 0.6, color: Colors.grey[300]!)
//       ),
//       disabledBorder: OutlineInputBorder(
//           borderRadius: AppRadius.m.all,
//           borderSide: BorderSide(width: 0.5, color: Colors.grey[200]!)
//         // borderSide: BorderSide.none
//         // borderSide: const BorderSide(width: 0.6)
//       ),
//       errorBorder: OutlineInputBorder(
//           borderRadius: AppRadius.m.all,
//           borderSide: const BorderSide(width: 0.8, color: Colors.red)
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//           borderRadius: AppRadius.m.all,
//           borderSide: const BorderSide(color: Colors.redAccent)
//       ),
//       focusedBorder: OutlineInputBorder(
//           borderRadius: AppRadius.m.all,
//           borderSide: BorderSide(color: colorScheme.primary)
//       ),
//       // outlineBorder: const BorderSide(width: 0.6),
//     ),
//     textTheme: const TextTheme(
//       // titleMedium: TextStyle(fontSize: 14.0),
//     ),
//     dialogTheme: DialogTheme(
//       shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all),
//       backgroundColor: colorScheme.surface,
//     ),
//     snackBarTheme: SnackBarThemeData(
//       shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all),
//       // backgroundColor: colorScheme.onSurface
//     ),
//
//     textButtonTheme: TextButtonThemeData(
//         style: ButtonStyle(
//             shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius:AppRadius.m.all)),
//             textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16))
//         )
//     ),
//     outlinedButtonTheme: OutlinedButtonThemeData(
//         style: ButtonStyle(
//             shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius:AppRadius.m.all)),
//             textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16))
//         )
//     ),
//     iconButtonTheme: IconButtonThemeData(
//         style: ButtonStyle(
//           shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius:AppRadius.m.all)),
//         )
//     ),
//
//     dividerTheme: DividerThemeData(
//         color: colorScheme.outline.withAlpha(50)
//     ),
//
//     listTileTheme: ListTileThemeData(
//         shape: RoundedRectangleBorder(borderRadius: AppRadius.m.all)
//     ),
//
//
//     // iconButtonTheme: IconButtonThemeData(
//     //   style: ButtonStyle(
//     //     // backgroundColor: WidgetStateProperty.all(Colors.red),
//     //     // foregroundColor: WidgetStateProperty.all(Colors.red),
//     //   )
//     // )
//   );
//
//   /// Light ThemeData
//   static ThemeData light = _defThemeData(_getLightColorScheme, Brightness.light);
//
//   /// Dark ThemeData
//   static ThemeData dark = _defThemeData(_getDarkColorScheme, Brightness.dark);
// }
