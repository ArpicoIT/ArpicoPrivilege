import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// package intl: ^0.19.0
class Formatter {
  static String date (String? dateTime){
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateTime!));
    } catch (e){
      return "";
    }
  }

  static String dateTime (String? dateTime){
    try {
      return DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.parse(dateTime!));
    } catch (e){
      return "";
    }
  }

  static String currency ({
    String? currency,
    double? value = 0.00
  }){

    currency = (currency != null) ? "$currency " : null;

    final currencyFormatter = NumberFormat.currency(
        symbol: currency,
        decimalDigits: 2,
    );

    return currencyFormatter.format(value);
  }

  static String price (double? price){
    final oCcy = NumberFormat("#,##0.00");
    return oCcy.format(price??0);
  }

  // static final digitsOnly = [
  //   FilteringTextInputFormatter.digitsOnly,
  // ];
}

class EmojiFilteringTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final filteredText = newValue.text.replaceAll(RegExp(r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]', unicode: true), '');
    return newValue.copyWith(text: filteredText);
  }
}