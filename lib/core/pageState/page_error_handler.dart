import 'dart:async';
import 'dart:io';

class NotFoundException implements Exception {}

class ErrorException implements Exception {
  final String key;
  ErrorException(this.key);
}

class PageErrorHandler {
  static String handle(dynamic error) {
    if (error is SocketException) {
      return "No internet connection.";
    } else if (error is TimeoutException) {
      return "Request timed out.";
    } else if (error is NotFoundException) {
      return "Content not found.";
    } else {
      return "Something went wrong.";
    }
  }
}
