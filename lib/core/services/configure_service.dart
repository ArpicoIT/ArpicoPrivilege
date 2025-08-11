import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();

  factory ConfigService() {
    return _instance;
  }

  ConfigService._internal();

  // setup endpoints
  late Map<String, dynamic> _endpoints;

  Future<void> loadEndpoints() async {
    try {
      final response = await rootBundle.loadString('assets/endpoints.json');
      _endpoints = json.decode(response);
    } catch (e){
      debugPrint(e.toString());
    }
  }

  String getEndpoint(String key) {
    try {
      return _endpoints[key];
    } catch (e){
      return '/error_404';
    }
  }

  // setup config
  late Map<String, dynamic> _config;

  Future<void> loadConfig() async {
    try {
      final response = await rootBundle.loadString('assets/config.json');
      _config = json.decode(response);
    } catch (e){
      debugPrint(e.toString());
    }
  }

  dynamic getConfig(String key) {
    try {
      return _config[key];
    } catch (e){
      return null;
    }
  }

  void setConfig(String key, dynamic value){
    _config[key] = value;
  }


// setup app data
// final Map<String, dynamic> _globalData = {};
//
// T? getFromGlobal<T>(String key) {
//   try {
//     return _globalData[key];
//   } catch (e){
//     return null;
//   }
// }
//
// void setToGlobal<T>(String key, T value) {
//   _globalData[key] = value;
// }

}
