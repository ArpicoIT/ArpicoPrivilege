import 'dart:convert';

import 'package:flutter/services.dart';

import '../../shared/widgets/app_alert.dart';

class StatusRepository {
  static final StatusRepository _instance = StatusRepository._internal();

  factory StatusRepository() {
    return _instance;
  }

  StatusRepository._internal();

  final Map<String, AlertContent> _map = {};

  Future<void> loadFromJsonAsset(String assetPath) async {
    final jsonStr = await rootBundle.loadString(assetPath);
    final List data = jsonDecode(jsonStr);
    for (var item in data) {
      final content = AlertContent.fromJson(item);
      _map[content.key] = content;
    }
  }

  AlertContent? getByKey(String key) => _map[key];
}
