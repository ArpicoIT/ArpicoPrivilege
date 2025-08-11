import 'package:flutter/material.dart';

class DraggableBottomSheet<T> extends StatelessWidget {
  final String title;
  final ScrollableWidgetBuilder builder;
  final TextStyle? titleStyle;
  final Function()? onReset;
  const DraggableBottomSheet({
    super.key,
    required this.builder,
    required this.title,
    this.titleStyle,
    this.onReset,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required ScrollableWidgetBuilder builder,
    TextStyle? titleStyle,
    Function()? onReset,
  }) async =>
      await showModalBottomSheet<T>(
        context: context,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        showDragHandle: false,
        isScrollControlled: true,
        backgroundColor: WidgetStateColor.transparent,
        useSafeArea: true,
        builder: (context) => DraggableBottomSheet<T>(
          title: title,
          builder: builder,
          titleStyle: titleStyle,
          onReset: onReset,
        ),
      );

  static void close<T>(BuildContext context, [T? result]) =>
      Navigator.of(context).maybePop(result);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Dismiss keyboard when tapping outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        initialChildSize: 1.0, // Opens at half the screen height
        minChildSize: 0.9, // Cannot shrink below half
        maxChildSize: 1.0, // Can be dragged up to full screen
        expand: true,
        builder: (context, scrollController) {
          final colorScheme = Theme
              .of(context)
              .colorScheme;

          // Center(
          //   child: Container(
          //     width: 40,
          //     height: 5,
          //     // margin: EdgeInsets.only(bottom: 4),
          //     decoration: BoxDecoration(
          //       color: Colors.grey[400],
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //   ),
          // ),

          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              titleTextStyle: titleStyle ??
                  TextStyle(
                    color: colorScheme.onSurface,
                      fontSize: 18),
              centerTitle: true,
              actions: [
                (onReset != null) ?
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: onReset,
                      child: Text("Reset")
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
            backgroundColor: colorScheme.surface,
            body: builder(context, scrollController),
          );
        },
      ),
    );
  }
}
