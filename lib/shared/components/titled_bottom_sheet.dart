import 'package:flutter/material.dart';

class TitledBottomSheet extends StatelessWidget {
  final String title;
  final WidgetBuilder builder;
  final TextStyle? titleStyle;
  const TitledBottomSheet({super.key,
    required this.builder,
    required this.title,
    this.titleStyle,
  });

  static Future show({
    required BuildContext context,
    required String title,
    required WidgetBuilder builder,
    TextStyle? titleStyle,
  }) async => await showModalBottomSheet(
    context: context,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (context) => TitledBottomSheet(
      title: title,
      builder: builder,
      titleStyle: titleStyle,
    ),
    // showDragHandle: true
  );

  static void close<T>(BuildContext context, [T? result])=> Navigator.of(context).maybePop(result);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(title, style: titleStyle ?? const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: ()=> close(context),
                    icon: const Icon(Icons.close)
                ),
              )
            ],
          ),
        ),
        builder(context)
      ],
    );
  }
}
