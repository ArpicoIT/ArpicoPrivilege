import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppAlertType {
  loading,
  success,
  error,
  timeout,
  notFound,
  noData,
  noNotifications
}

class AlertContent {
  final String key;
  final String? image;
  final String? title;
  final String? message;
  final String? confirmText;
  final IconData? confirmIcon;

  AlertContent({
    required this.key,
    this.image,
    this.title,
    this.message,
    this.confirmText,
    this.confirmIcon,
  });

  factory AlertContent.fromJson(Map<String, dynamic> json) {
    return AlertContent(
      key: json['key'],
      image: json['image'],
      title: json['title'],
      message: json['message'],
      confirmText: json['confirmText'],
      confirmIcon: null, // You can map string to IconData if needed
    );
  }
}

class AppAlertView extends StatelessWidget {
  final AppAlertType status;
  final VoidCallback? onRefresh;
  final VoidCallback? onGoBack;
  final String? title;
  final String? message;
  final IconData? icon;
  final double? aspectRatio;

  const AppAlertView({
    super.key,
    required this.status,
    this.onRefresh,
    this.onGoBack,
    this.title,
    this.message,
    this.icon,
    this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final (defaultTitle, defaultMessage, defaultIcon) = _getDefaults();

    if (status == AppAlertType.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final colorScheme = Theme.of(context).colorScheme;

    Widget child = Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? defaultIcon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(title ?? defaultTitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message ?? defaultMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              children: [
                if (onRefresh != null)
                  FilledButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    label: Text("Refresh"),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainer,
                      foregroundColor: colorScheme.onSurface,
                    ),
                  ),
                if (onGoBack != null)
                  FilledButton.icon(
                    onPressed: onGoBack,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Go Back"),
                    style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary),
                  ),
              ],
            )
          ],
        ),
      ),
    );

    if (aspectRatio != null && aspectRatio != 0) {
      return AspectRatio(
        aspectRatio: aspectRatio!,
        child: child,
      );
    }

    return child;

    // return FutureBuilder(
    //     future: future,
    //     builder: (context, snap){
    //       return Center(
    //         child: Padding(
    //           padding: const EdgeInsets.all(24),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Icon(icon ?? defaultIcon, size: 64, color: Colors.grey),
    //               const SizedBox(height: 16),
    //               Text(title ?? defaultTitle,
    //                   style: Theme.of(context).textTheme.titleMedium,
    //                   textAlign: TextAlign.center),
    //               const SizedBox(height: 8),
    //               Text(message ?? defaultMessage,
    //                   textAlign: TextAlign.center,
    //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
    //               const SizedBox(height: 24),
    //               Wrap(
    //                 spacing: 16,
    //                 children: [
    //                   if (onRetry != null)
    //                     TextButton.icon(
    //                       onPressed: onRetry,
    //                       icon: const Icon(Icons.refresh),
    //                       label: const Text("Retry"),
    //                       style: TextButton.styleFrom(
    //                         backgroundColor: colorScheme.surfaceContainer,
    //                         foregroundColor: colorScheme.onSurface,
    //                       ),
    //                     ),
    //                   if (onGoBack != null)
    //                     TextButton.icon(
    //                       onPressed: onGoBack,
    //                       icon: const Icon(Icons.arrow_back),
    //                       label: const Text("Go Back"),
    //                       style: TextButton.styleFrom(
    //                           backgroundColor: colorScheme.primary,
    //                           foregroundColor: colorScheme.onPrimary
    //                       ),
    //                     ),
    //                 ],
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     }
    // );
  }

  Widget buildContent(BuildContext context, AlertContent content) {
    final (defaultTitle, defaultMessage, defaultIcon) = _getDefaults();
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
                aspectRatio: 3,
                child: Image.asset(content.image!,
                    errorBuilder: (context, err, st) =>
                        const SizedBox.shrink())),
            Icon(icon ?? defaultIcon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(title ?? content.title ?? defaultTitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message ?? content.message ?? defaultMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              children: [
                if (onRefresh != null)
                  FilledButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    label: Text(content.confirmText ?? "Retry"),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainer,
                      foregroundColor: colorScheme.onSurface,
                    ),
                  ),
                if (onGoBack != null)
                  FilledButton.icon(
                    onPressed: onGoBack,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Go Back"),
                    style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  (String, String, IconData) _getDefaults() {
    switch (status) {
      case AppAlertType.error:
        return (
          "Something went wrong",
          "Please try again later.",
          Icons.error_outline
        );
      case AppAlertType.timeout:
        return (
          "Request Timed Out",
          "Server is not responding.",
          Icons.schedule_outlined
        );
      case AppAlertType.notFound:
        return (
          "Page Not Found",
          "We couldn't find what you're looking for.",
          Icons.search_off
        );
      case AppAlertType.noData:
        return ("No Content", "There's no data to show.", Icons.description);
      case AppAlertType.success:
        return (
          "Success",
          "Operation completed successfully.",
          Icons.check_circle_outline
        );
      case AppAlertType.noNotifications:
        return (
          "No Notifications Yet",
          "You're all caught up! We'll notify you when there's something new.",
          Icons.notifications_off
        );
      default:
        return ("", "", Icons.info_outline);
    }
  }

  Future<AlertContent> loadFromJsonAsset(String key) async {
    final jsonStr = await rootBundle.loadString('assets/errors/errors.json');
    final List<dynamic> data = jsonDecode(jsonStr);

    late AlertContent result;

    final match = data.cast<Map<String, dynamic>>().firstWhere(
          (e) => e['key'] == key,
          orElse: () => {
            "key": "failed",
            "image": "assets/errors/failed.png",
            "title": "Operation Failed",
            "message":
                "Something went wrong while processing your request. Please try again.",
            "confirmText": "Retry",
            "confirmIcon": null
          },
        );

    if (match.isNotEmpty) {
      result = AlertContent.fromJson(match);
    }

    return result;
  }
}
