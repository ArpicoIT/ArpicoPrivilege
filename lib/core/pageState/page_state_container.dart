import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'page_error_handler.dart';
import 'page_state_notifier.dart';

class PageStateContainer extends StatelessWidget {
  final PageStateNotifier notifier;
  final Widget Function(BuildContext context) builder;
  final VoidCallback onRetry;
  final VoidCallback? onBackToLogin;

  const PageStateContainer({
    super.key,
    required this.notifier,
    required this.builder,
    required this.onRetry,
    this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PageStateNotifier>(builder: (context, state, child) {
      return AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          switch (state.status) {
            case PageStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case PageStatus.error:
              return _buildError(context, state);
            case PageStatus.success:
              return builder(context);
          }
        },
      );
    });
  }

  Widget _buildError(BuildContext context, PageStateNotifier state) {
    final error = state.error;
    final key = state.errorKey;
    if (error is TimeoutException) {
      return _ErrorDisplay(
        errorKey: "timeout",
        onConfirm: onRetry,
        extraButton: OutlinedButton(
            onPressed: () {
              // open device settings or show settings page
            },
            child: const Text("Settings")),
      );
    } else if (error is SocketException) {
      return _ErrorDisplay(
        errorKey: "connection_error",
        onConfirm: onRetry,
        extraButton: OutlinedButton(
            onPressed: () {
              // open device settings or show settings page
            },
            child: const Text("Settings")),
      );
    } else if (error is NotFoundException) {
      return _ErrorDisplay(
        errorKey: "not_found",
        onConfirm: onRetry,
        extraButton: OutlinedButton(
            onPressed: () {
              // open device settings or show settings page
            },
            child: const Text("Back to Login")),
      );
    } else if (error is ErrorException) {
      return _ErrorDisplay(
        errorKey: error.key,
        onConfirm: onRetry,
      );
    } else {
      return _ErrorDisplay(
        errorKey: "failed",
        onConfirm: onRetry,
      );
    }
  }
}

class ErrorContent {
  final String key;
  final String image;
  final String title;
  final String message;
  final String confirmText;
  final String? confirmIcon;

  ErrorContent({
    required this.key,
    required this.image,
    required this.title,
    required this.message,
    required this.confirmText,
    this.confirmIcon,
  });

  factory ErrorContent.fromJson(Map<String, dynamic> json) {
    return ErrorContent(
      key: json['key'],
      image: json['image'],
      title: json['title'],
      message: json['message'],
      confirmText: json['confirmText'],
      confirmIcon: json['confirmIcon'],
    );
  }
}

class ErrorLoader {
  static Future<List<ErrorContent>> loadErrors() async {
    final String jsonString =
        await rootBundle.loadString('assets/errors/error.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => ErrorContent.fromJson(e)).toList();
  }

  static Future<ErrorContent?> getByKey(String key) async {
    final list = await loadErrors();
    return list.firstWhere((e) => e.key == key,
        orElse: () => ErrorContent(
              key: 'unknown',
              image: 'assets/errors/failed.png',
              title: 'Something went wrong',
              message: 'An unexpected error occurred.',
              confirmText: 'Retry',
            ));
  }
}

class _ErrorDisplay extends StatelessWidget {
  final String errorKey;
  final VoidCallback? onConfirm;
  final Widget? extraButton;

  const _ErrorDisplay({
    super.key,
    required this.errorKey,
    this.onConfirm,
    this.extraButton,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ErrorContent?>(
      future: ErrorLoader.getByKey(errorKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final content = snapshot.data;
        if (content == null) {
          return const Center(child: Text('Unknown error'));
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(content.image, height: 180),
                const SizedBox(height: 24),
                Text(content.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(content.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center),
                if (onConfirm != null) ...[
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: onConfirm,
                    child: Text(content.confirmText),
                  ),
                ],
                if (extraButton != null) ...[
                  const SizedBox(height: 12),
                  extraButton!,
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

// class _ErrorDisplay extends StatelessWidget {
//   final String image;
//   final String title;
//   final String message;
//   final List<Widget> buttons;
//
//   const _ErrorDisplay({
//     required this.image,
//     required this.title,
//     required this.message,
//     required this.buttons,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(image, height: 160),
//             const SizedBox(height: 16),
//             Text(title, style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 8),
//             Text(message,
//                 style: Theme.of(context).textTheme.bodyMedium,
//                 textAlign: TextAlign.center),
//             const SizedBox(height: 16),
//             ...buttons,
//           ],
//         ),
//       ),
//     );
//   }
// }
