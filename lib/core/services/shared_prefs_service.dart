import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// // Singleton Instance
// static final SharedPrefsService instance = SharedPrefsService._internal();
//
// // Private Constructor
// SharedPrefsService._internal();

class SharedPrefsService {

  // static final SharedPrefsService _instance = SharedPrefsService._internal();
  // static SharedPrefsService get instance => _instance;

  static SharedPreferences? _prefs;

  // SharedPrefsService._internal();

  /// Initialize once (usually in main)
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ─────────────────────────────────────────────
  // ✅ PRIMITIVE TYPES
  // ─────────────────────────────────────────────

  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<void> saveDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  // ─────────────────────────────────────────────
  // ✅ JSON OBJECT & LIST
  // ─────────────────────────────────────────────

  /// Save a single JSON object (Map)
  static Future<void> saveJsonObject(String key, Map<String, dynamic> data) async {
    final jsonString = jsonEncode(data);
    await _prefs?.setString(key, jsonString);
  }

  /// Get a single JSON object (Map)
  static Map<String, dynamic> getJsonObject(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return {};
  }

  /// Save a list of JSON objects
  static Future<void> saveJsonList(String key, List<dynamic> data) async {
    final jsonString = jsonEncode(data);
    await _prefs?.setString(key, jsonString);
  }

  /// Get a list of JSON objects
  static List<dynamic> getJsonList(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as List<dynamic>;
    }
    return [];
  }

  // ─────────────────────────────────────────────
  // ✅ MODEl & LIST
  // ─────────────────────────────────────────────

  /// Save a single model object (e.g. Product, User)
  static Future<void> saveModel<T>(
      String key,
      T item,
      Map<String, dynamic> Function(T item) toJson,
      ) async {
    final jsonString = jsonEncode(toJson(item));
    await _prefs?.setString(key, jsonString);
  }

  /// Get a single model object (or return null if not found)
  static T? getModel<T>(
      String key,
      T Function(Map<String, dynamic> json) fromJson,
      ) {
    final jsonString = _prefs?.getString(key);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return fromJson(jsonMap);
    }
    return null;
  }

  /// Save a list of models
  static Future<void> saveModelList<T>(
      String key,
      List<T> items,
      Map<String, dynamic> Function(T item) toJson,
      ) async {
    final jsonList = items.map((item) => toJson(item)).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs?.setString(key, jsonString);
  }

  /// Get a list of models from cache
  static List<T> getModelList<T>(
      String key,
      T Function(Map<String, dynamic> json) fromJson,
      ) {
    final jsonString = _prefs?.getString(key);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  // ─────────────────────────────────────────────
  // ✅ STRING LIST
  // ─────────────────────────────────────────────

  /// Save a string list
  static Future<void> saveStringList(String key, List<String> value) async {
    await _prefs?.setStringList(key, value);
  }

  /// Get a string list
  static List<String> getStringList(String key) {
    return _prefs?.getStringList(key) ?? [];
  }

  // ─────────────────────────────────────────────
  // ❌ REMOVE / CLEAR
  // ─────────────────────────────────────────────

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
