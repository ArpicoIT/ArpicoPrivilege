import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader {
  final BuildContext context;

  // Private constructor with context
  CustomLoader._(this.context);

  // Factory constructor to create instance with context
  static CustomLoader of(BuildContext context) {
    return CustomLoader._(context);
  }

  static BuildContext? _loaderContext;
  Completer<bool>? _loaderCompleter;

  Timer? _timer;

  /// Show the loading dialog
  Future<bool> show([String? message]) async {
    _loaderCompleter = Completer<bool>(); // Initialize Completer

    // Show the dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext dialogContext) {
        _loaderContext = dialogContext;

        // Complete the future when the dialog actually appears
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_loaderCompleter!.isCompleted) {
            _loaderCompleter!.complete(true);
          }
        });

        return PopScope(
          canPop: true,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Align(
              alignment: Alignment.center,
              child: SizedBox.square(
                dimension: 72,
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: SpinKitWave(
                      size: 24,
                      itemBuilder: (BuildContext context, int index) {
                        final colorScheme = Theme.of(context).colorScheme;
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? colorScheme.primary : colorScheme.primary.withAlpha(200),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete((){
      _loaderContext = null;
    });

    return await _loaderCompleter!
        .future; // Return true only after dialog is open
  }

  /// Close the loading dialog
  Future<void> close([int? millis]) async {
    if (_loaderContext != null) {
      await Future.delayed(Duration(milliseconds: millis ?? 600));

      if (_loaderContext != null) {
        Navigator.of(_loaderContext!).pop(); // Close the dialog
        _loaderContext = null;
      }
    }

    return await Future.delayed(Duration(milliseconds: millis ?? 400)); // Ensure return after 1 second
  }

  void dispose() {
    _timer?.cancel();
    _loaderContext = null;
  }
}