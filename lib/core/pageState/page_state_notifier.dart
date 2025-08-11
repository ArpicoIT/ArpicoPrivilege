import 'package:flutter/material.dart';

enum PageStatus {loading, success, error }

class PageStateNotifier extends ChangeNotifier {
  PageStatus _status = PageStatus.loading;
  String? _errorKey;
  dynamic _error;

  PageStatus get status => _status;
  dynamic get error => _error;
  String? get errorKey => _errorKey;

  void setLoading() {
    _status = PageStatus.loading;
    _error = null;
    notifyListeners();
  }

  void setSuccess() {
    _status = PageStatus.success;
    _error = null;
    notifyListeners();
  }

  void setError(dynamic error, {String? key}) {
    _status = PageStatus.error;
    _error = error;
    _errorKey = key;
    notifyListeners();
  }
}

