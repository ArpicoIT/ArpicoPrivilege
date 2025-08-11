import 'package:flutter/material.dart';

enum PageState { idle, loading, success, error }

class BaseViewModel extends ChangeNotifier {
  late BuildContext context;
  bool _isLoading = false;
  PageState _pageState = PageState.idle;
  String? _error;

  bool get isLoading => _isLoading;
  PageState get pageState => _pageState;
  String? get error => _error;

  void setContext(BuildContext ctx) {
    context = ctx;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPageState(PageState state) {
    _pageState = state;
    notifyListeners();
  }

  void setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
}
