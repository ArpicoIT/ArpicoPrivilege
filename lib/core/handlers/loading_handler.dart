import 'package:flutter/material.dart';

class LoadingHandler {
  static LoadingHandler? _instance;
  static BuildContext? _dialogContext;
  static bool _isShowing = false;
  static String _currentMessage = "";

  LoadingHandler._privateConstructor();

  factory LoadingHandler() {
    _instance ??= LoadingHandler._privateConstructor();
    return _instance!;
  }

  /// Show the loading dialog
  void show(BuildContext context, {required String message}) {
    if (_isShowing) {
      // Update the message if the dialog is already showing
      _updateMessage(message);
    } else {
      _isShowing = true;
      _currentMessage = message;

      // Show the dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent closing by tapping outside
        builder: (BuildContext dialogContext) {
          _dialogContext = dialogContext;
          return WillPopScope(
            onWillPop: () async => false, // Disable back button
            child: AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      _currentMessage,
                      key: ValueKey("loadingMessage"), // Unique key for updating message
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  /// Close the loading dialog
  void close() {
    if (_isShowing && _dialogContext != null) {
      Navigator.of(_dialogContext!).pop(); // Close the dialog
      _dialogContext = null;
      _isShowing = false;
      _currentMessage = "";
    }
  }

  /// Update the message of the currently shown dialog
  void _updateMessage(String message) {
    if (_dialogContext != null) {
      _currentMessage = message;
      // Trigger rebuild by marking the dialog as needing update
      (_dialogContext as Element).markNeedsBuild();
    }
  }
}


