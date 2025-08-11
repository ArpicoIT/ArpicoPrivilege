import 'package:flutter/material.dart';

enum AlertType {success, error, info, question}

class CustomAlert {
  final BuildContext context;

  CustomAlert._(this.context);

  static CustomAlert of(BuildContext context) {
    return CustomAlert._(context);
  }

  static final Map<BuildContext, bool> _dialogStatusMap = {};
  static final Map<BuildContext, bool> _bottomSheetStatusMap = {};


  Future<String?> openDialog({
    AlertType? type,
    String? title,
    required String message,
    bool isCanceled = false,
    bool isDismissible = false,
    String confirmText = "Ok",
    String cancelText = "Cancel",
    bool allowMultiple = true,
    Function(BuildContext context)? onConfirm,
    Function(BuildContext context)? onCancel,
  }) async {
    // Prevent multiple dialogs in the same context
    if (_dialogStatusMap[context] == true && !allowMultiple) {
      return null; // Or log it or return "already_open"
    }

    _dialogStatusMap[context] = true;

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {

        final colorScheme = Theme.of(context).colorScheme;
        final Color baseColor = colorScheme.secondary;

        if (isDismissible) {
          Future.delayed(const Duration(milliseconds: 1800), () {
            if (ctx.mounted && Navigator.canPop(ctx)) {
              Navigator.of(ctx).pop();
            }
          });
        }

        final textAlign = (type != null) ? TextAlign.center : TextAlign.start;
        final titleWidget = (title != null) ? Text(title, textAlign: textAlign) : null;
        final contentWidget = Text(message, textAlign: textAlign);

        final confirmButtonWidget = _button(
          ctx,
          onPressed: () => onConfirm?.call(ctx) ?? Navigator.of(ctx).pop("OK"),
          backgroundColor: baseColor,
          foregroundColor: colorScheme.surface,
          labelText: confirmText,
        );

        final cancelButtonWidget = _button(
          ctx,
          onPressed: () => onCancel?.call(ctx) ?? Navigator.of(ctx).pop("CANCEL"),
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
          labelText: cancelText,
        );

        if (type != null) {
          return AlertDialog(
            icon: _icon(context, type, baseColor),
            title: titleWidget,
            content: contentWidget,
            actions: [
              confirmButtonWidget,
              if (isCanceled)
                ...[
                  const SizedBox(height: 6),
                  cancelButtonWidget,
                ]
              else
                const SizedBox.shrink(),
            ],
          );
        } else {
          return AlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: [
              Row(
                children: [
                  if (isCanceled)
                    ...[
                      Expanded(flex: 1, child: cancelButtonWidget),
                      const SizedBox(width: 12),
                    ]
                  else
                    const SizedBox.shrink(),
                  Expanded(flex: 1, child: confirmButtonWidget),
                ],
              )
            ],
          );
        }
      },
    );

    // Reset flag after dialog is dismissed
    _dialogStatusMap[context] = false;

    return result;
  }

  Future<String?> openBottomSheet({
    AlertType? type,
    String? title,
    required String message,
    bool isCanceled = false,
    bool isDismissible = false,
    String confirmText = "Ok",
    String cancelText = "Cancel",
    bool allowMultiple = true,
    Function(BuildContext context)? onConfirm,
    Function(BuildContext context)? onCancel,
  }) async {
    // Prevent multiple sheets in same context
    if (_bottomSheetStatusMap[context] == true && !allowMultiple) {
      return null;
    }

    _bottomSheetStatusMap[context] = true;

    final result = await showModalBottomSheet<String>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext ctx) {
        final colorScheme = Theme.of(context).colorScheme;
        final Color baseColor = colorScheme.secondary;

        final textAlign = (type != null) ? TextAlign.center : TextAlign.start;
        final titleWidget = title != null
            ? Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(title, textAlign: textAlign, style: Theme.of(context).textTheme.titleMedium),
        )
            : const SizedBox.shrink();

        final contentWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(message, textAlign: textAlign),
        );

        final confirmButtonWidget = _button(
          ctx,
          onPressed: onConfirm?.call(ctx) ?? () => Navigator.of(ctx).pop("OK"),
          backgroundColor: baseColor,
          foregroundColor: colorScheme.surface,
          labelText: confirmText,
        );

        final cancelButtonWidget = _button(
          ctx,
          onPressed: onCancel?.call(ctx) ?? () => Navigator.of(ctx).pop("CANCEL"),
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
          labelText: cancelText,
        );

        return Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.5
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (type != null) _icon(context, type, baseColor),
                  titleWidget,
                  contentWidget,
                ],
              ),

              Container(
                margin: const EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isCanceled)
                      Row(
                        children: [
                          Expanded(child: cancelButtonWidget),
                          const SizedBox(width: 12),
                          Expanded(child: confirmButtonWidget),
                        ],
                      )
                    else
                      confirmButtonWidget,
                  ],
                ),
              )
            ],
          ),
        );
      },
    );

    // Reset flag after bottom sheet is dismissed
    _bottomSheetStatusMap[context] = false;

    return result;
  }





  static Widget _button(BuildContext context, {
    required Function() onPressed,
    required Color? backgroundColor,
    Color? foregroundColor,
    required String labelText
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: const Size(double.infinity, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(labelText, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  static Widget _icon(BuildContext context, AlertType state, Color color) {
    IconData iconData;
    Widget avatar;

    switch (state) {
      case AlertType.success:
        iconData = Icons.done;
        break;
      case AlertType.error:
        iconData = Icons.error;
        break;
      case AlertType.info:
        iconData = Icons.info;
        break;
      case AlertType.question:
        iconData = Icons.question_mark;
        break;
    }

    if (state != AlertType.error && state != AlertType.info) {
      avatar = CircleAvatar(
        radius: 22,
        backgroundColor: color,
        foregroundColor: Theme.of(context).colorScheme.surface,
        child: Icon(iconData, size: 34),
      );
    } else {
      avatar = Icon(iconData, size: 52, color: color);
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: color.withAlpha(100),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          avatar,
        ],
      ),
    );
  }
}

// class CustomAlert {
//   final BuildContext context;
//
//   // Private constructor with context
//   CustomAlert._(this.context);
//
//   // Factory constructor to create instance with context
//   static CustomAlert of(BuildContext context) {
//     return CustomAlert._(context);
//   }
//
//   static BuildContext? _alertContext;
//
//   Future<String?> show({
//     AlertType? type,
//     String? title,
//     required String message,
//     bool isCanceled = false,
//     bool isDismissible = false,
//     String confirmText = "Ok",
//     String cancelText = "Cancel"
//   }) async {
//     return await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         _alertContext = dialogContext;
//
//         final colorScheme = Theme.of(context).colorScheme;
//         final Color baseColor = colorScheme.secondary;
//
//         if(isDismissible) {
//           Future.delayed(const Duration(milliseconds: 1800), () {
//             if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
//               Navigator.of(dialogContext).pop();
//             }
//           });
//         }
//
//         final textAlign = (type != null) ? TextAlign.center : TextAlign.start;
//         final titleWidget = (title != null) ? Text(title, textAlign: textAlign) : null;
//         final contentWidget = Text(message, textAlign: textAlign);
//
//         final confirmButtonWidget = _button(
//             dialogContext,
//             onPressed: () => Navigator.of(dialogContext).pop("OK"),
//             backgroundColor: baseColor,
//             foregroundColor: colorScheme.surface,
//             labelText: confirmText
//         );
//
//         final cancelButtonWidget = _button(
//             dialogContext,
//             onPressed: () =>
//                 Navigator.of(dialogContext).pop("CANCEL"),
//             backgroundColor: colorScheme.surfaceContainerLow,
//             foregroundColor: colorScheme.onSurface,
//             labelText: cancelText
//         );
//
//         if(type != null) {
//           return AlertDialog(
//             icon: _icon(context, type, baseColor),
//             title: titleWidget,
//             content: contentWidget,
//             actions: [
//               confirmButtonWidget,
//               if(isCanceled)
//                 ...[
//                   const SizedBox(height: 6),
//                   cancelButtonWidget,
//                 ] else
//                 const SizedBox.shrink(),
//
//             ],
//           );
//         } else {
//           return AlertDialog(
//             title: titleWidget,
//             content: contentWidget,
//             actions: [
//               Row(
//                 children: [
//                   if(isCanceled)
//                     ...[
//                       Expanded(
//                         flex: 1,
//                         child: cancelButtonWidget,
//                       ),
//                       const SizedBox(width: 12),
//                     ] else
//                     const SizedBox.shrink(),
//                   Expanded(
//                     flex: 1,
//                     child: confirmButtonWidget,
//                   ),
//                 ],
//               )
//             ],
//           );
//         }
//       },
//     );
//   }
//
//   static Widget _button(BuildContext context, {
//     required Function() onPressed,
//     required Color? backgroundColor,
//     Color? foregroundColor,
//     required String labelText
//   }) {
//     return FilledButton(
//       onPressed: onPressed,
//       style: FilledButton.styleFrom(
//           backgroundColor: backgroundColor,
//           foregroundColor: foregroundColor,
//           minimumSize: Size(double.infinity, 44),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
//       ),
//       child: Text(labelText, style: TextStyle(fontWeight: FontWeight.bold)),
//     );
//   }
//
//   static Widget _icon(BuildContext context, AlertType state, Color color) {
//     IconData iconData;
//     Widget avatar;
//
//     switch(state){
//       case AlertType.success:
//         iconData = Icons.done;
//         break;
//       case AlertType.error:
//         iconData = Icons.error;
//         break;
//       case AlertType.info:
//         iconData = Icons.info;
//         break;
//       case AlertType.question:
//         iconData = Icons.question_mark;
//         break;
//     }
//
//     if(state != AlertType.error && state != AlertType.info){
//       avatar = CircleAvatar(
//         radius: 22,
//         backgroundColor: color,
//         foregroundColor: Theme.of(context).colorScheme.surface,
//         child: Icon(iconData, size: 34),
//       );
//     } else {
//       avatar = Icon(iconData, size: 52, color: color);
//     }
//
//     return CircleAvatar(
//       radius: 30,
//       backgroundColor: color.withAlpha(100),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: Theme.of(context).colorScheme.surface,
//           ),
//           avatar
//         ],
//       ),
//     );
//
//   }
// }