import 'dart:convert';
import 'package:flutter/services.dart';

import '../../data/models/eBill.dart';
import '../../shared/widgets/app_alert.dart';

class LocalJsonService {
  static Future<List<EBill>> getEBills() async {
    try {
      final response = await rootBundle.loadString("assets/json/eBills.json");
      final data = jsonDecode(response)["data"] as List;

      return data.map((e) => EBill.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

}