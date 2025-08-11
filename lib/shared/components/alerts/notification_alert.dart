import 'package:flutter/material.dart';

enum NotificationType { success, error, info, warning, question }

class NotificationAlert extends StatelessWidget {
  final NotificationType type;
  final String message;
  final Function()? onCancel;
  const NotificationAlert({super.key,
    required this.type,
    required this.message,
    this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border(
            left: BorderSide(color: _getColor, width: 4),
          ),
          color: _getColor.withAlpha(10)
      ),
      constraints: BoxConstraints(minWidth: double.infinity),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_getIconData, color: _getColor, size: 18),
                  const SizedBox(width: 12),
                  Flexible(child: Text(message, style: TextStyle(color: _getColor))),
                ],
              ),
            ),
          ),
          (onCancel != null) ?
          GestureDetector(
              onTap: onCancel,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.close, color: Colors.grey, size: 18),
              )
          ) : const SizedBox()
        ],
      ),
    );
  }

  Color get _getColor {
    // return Colors.black87;

    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.warning:
        return Colors.yellow;
      case NotificationType.question:
        return Colors.cyan;
    }
  }

  IconData get _getIconData {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.question:
        return Icons.help_outline;
    }
  }
}
