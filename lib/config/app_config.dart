import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  late Map<String, dynamic> _settings;

  /// Loads configuration from `assets/config.json`
  Future<void> loadFromAsset({String path = 'assets/config/app_config.json'}) async {
    try {
      final jsonStr = await rootBundle.loadString(path);
      _settings = json.decode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Failed to load config: $e");
      _settings = {};
    }
  }

  /// Gets a config value by key, returns null if not found
  T? get<T>(String key) {
    try {
      final value = _settings[key];
      return value is T ? value : null;
    } catch (_) {
      return null;
    }
  }

  /// Get a value using dot notation, e.g. `endpoints.login`
  T? getNested<T>(String path) {
    try {
      final keys = path.split('.');
      dynamic value = _settings;
      for (final key in keys) {
        if (value is Map && value.containsKey(key)) {
          value = value[key];
        } else {
          return null;
        }
      }
      return value is T ? value : null;
    } catch (_) {
      return null;
    }
  }


  /// Sets or updates a config key-value pair
  void set(String key, dynamic value) {
    _settings[key] = value;
  }

  /// Checks if config has a certain key
  bool containsKey(String key) => _settings.containsKey(key);

  /// Returns the entire config map (read-only)
  Map<String, dynamic> get all => Map.unmodifiable(_settings);
}
