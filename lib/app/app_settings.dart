import 'package:flutter/material.dart';

class AppPreferences {
  String? country;
  String? countryCode;
  String? language;
  String? currency;
  String? currencyShort;
  ThemeMode themeMode;

  AppPreferences({
    this.country,
    this.countryCode,
    this.language,
    this.currency,
    this.currencyShort,
    this.themeMode = ThemeMode.system,
  });

  /// Convert JSON to `AccountSettingsData`
  factory AppPreferences.fromJson(Map<String, dynamic> json) {
    return AppPreferences(
      country: json['country'] as String?,
      countryCode: json['countryCode'] as String?,
      language: json['language'] as String?,
      currency: json['currency'] as String?,
      currencyShort: json['currencyShort'] as String?,
      themeMode: ThemeMode.values.firstWhere(
            (e) => e.toString() == 'ThemeMode.${json['themeMode']}',
        orElse: () => ThemeMode.system,
      ),
    );
  }

  /// Convert `AccountSettingsData` to JSON
  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'countryCode': countryCode,
      'language': language,
      'currency': currency,
      'currencyShort': currencyShort,
      'themeMode': themeMode.toString().split('.').last, // Convert enum to string
    };
  }

  static AppPreferences defaultSettings = AppPreferences(
    country: "Srilanka",
    countryCode: "LK",
    language: "English",
    currency: "LKR",
    currencyShort: "Rs",
    themeMode: ThemeMode.system,
  );


}

class UserAppPreferences {
  String? country;
  String? countryCode;
  String? language;
  String? currency;
  String? currencyShort;
  ThemeMode themeMode;
  bool? notificationsEnabled;
  bool? analyticsConsent;
  String? timeZone;
  double? fontSize;
  bool? isFirstLaunch;
  bool? hasCompletedOnboarding;
  String? appVersion;
  int? buildNumber;

  UserAppPreferences({
    this.country,
    this.countryCode,
    this.language,
    this.currency,
    this.currencyShort,
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled,
    this.analyticsConsent,
    this.timeZone,
    this.fontSize,
    this.isFirstLaunch,
    this.hasCompletedOnboarding,
    this.appVersion,
    this.buildNumber,
  });

  factory UserAppPreferences.fromJson(Map<String, dynamic> json) {
    return UserAppPreferences(
      country: json['country'] as String?,
      countryCode: json['countryCode'] as String?,
      language: json['language'] as String?,
      currency: json['currency'] as String?,
      currencyShort: json['currencyShort'] as String?,
      themeMode: ThemeMode.values.firstWhere(
            (e) => e.toString() == 'ThemeMode.${json['themeMode']}',
        orElse: () => ThemeMode.system,
      ),
      notificationsEnabled: json['notificationsEnabled'] as bool?,
      analyticsConsent: json['analyticsConsent'] as bool?,
      timeZone: json['timeZone'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      isFirstLaunch: json['isFirstLaunch'] as bool?,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool?,
      appVersion: json['appVersion'] as String?,
      buildNumber: json['buildNumber'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'countryCode': countryCode,
      'language': language,
      'currency': currency,
      'currencyShort': currencyShort,
      'themeMode': themeMode.toString().split('.').last,
      'notificationsEnabled': notificationsEnabled,
      'analyticsConsent': analyticsConsent,
      'timeZone': timeZone,
      'fontSize': fontSize,
      'isFirstLaunch': isFirstLaunch,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
    };
  }

  static UserAppPreferences defaultSettings = UserAppPreferences(
    country: "Srilanka",
    countryCode: "LK",
    language: "English",
    currency: "LKR",
    currencyShort: "Rs",
    themeMode: ThemeMode.system,
    notificationsEnabled: true,
    analyticsConsent: false,
    timeZone: 'Asia/Colombo',
    fontSize: 14.0,
    isFirstLaunch: true,
    hasCompletedOnboarding: false,
    appVersion: '2.3.0',
    buildNumber: 145,
  );
}
