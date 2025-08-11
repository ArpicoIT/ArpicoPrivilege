import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/buttons/primary_button.dart';

enum _Variant{page, body, widget}

class PageAlert extends StatelessWidget {
  final Function()? onConfirm;
  final EdgeInsetsGeometry? padding;
  PageAlert({super.key, this.onConfirm, this.padding}): _variant = _Variant.page;

  PageAlert.body({super.key, this.onConfirm, this.padding}): _variant = _Variant.body;

  PageAlert.widget({super.key, this.onConfirm, this.padding}): _variant = _Variant.widget;

  final _Variant _variant;

  static Future<T> replace<T>(
      Key key,
      BuildContext context, {
        Function()? onConfirm,
        EdgeInsetsGeometry? padding,
        T? result,
      }) async {
    return await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PageAlert(
          key: key,
          onConfirm: onConfirm,
          padding: padding,
        )), result:  result);
  }

  Map<String, IconData> iconMap = {
    'home': Icons.home,
    'settings': Icons.settings,
    'alert': Icons.warning,
    'favorite': Icons.favorite,
    'person': Icons.person,
  };

  IconData? getIconFromString(String? iconName) {
    if(iconName == null){
      return null;
    }

    return iconMap[iconName] ?? Icons.help; // Default icon if not found
  }


  late double _aspectRatio;
  late double _spacing;
  late double _titleSize;
  late double _messageSize;

  Widget buildBody(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: FutureBuilder(
        future: getData(context, (key as ValueKey).value.toString()),
        builder: (context, snapshot) {
          final textTheme = Theme.of(context).textTheme;
          final colorScheme = Theme.of(context).colorScheme;

          if (snapshot.data != null) {
            final Map<String, dynamic> data = snapshot.data!;
            final String image = data["image"] as String? ?? '';
            final String title = data["title"] as String? ?? '';
            final String message = data["message"] as String? ?? '';
            final String confText = data["confirmText"] as String? ?? '';
            final IconData? confIcon = getIconFromString(data["confirmIcon"] as String?);

            // final Widget buildImage = AspectRatio(
            //     aspectRatio: _aspectRatio,
            //     child: Image.asset(image,
            //         errorBuilder: (context, err, st) => const SizedBox.shrink()));
            //
            // final Widget buildTitle = Text(title, style: TextStyle(fontSize: _titleSize, fontWeight: FontWeight.w500));
            //
            // final Widget buildMessage = Text(message,
            //     style: TextStyle(fontSize: _messageSize, color: colorScheme.onSurfaceVariant),
            //     textAlign: TextAlign.center);
            //
            // final Widget buildConfirmButton = PrimaryButton.filled(
            //     icon: confIcon,
            //     text: confText,
            //     onPressed: onConfirm
            // );
            //
            //
            // return Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     if (image.isNotEmpty) ...[
            //       AspectRatio(
            //           aspectRatio: _aspectRatio,
            //           child: Image.asset(image,
            //               errorBuilder: (context, err, st) => const SizedBox.shrink())),
            //       const SizedBox(height: 12)
            //     ] else
            //       const SizedBox.shrink(),
            //     Text(title, style: TextStyle(fontSize: _titleSize, fontWeight: FontWeight.w500)),
            //     SizedBox(height: _spacing),
            //     Text(message,
            //         style: TextStyle(fontSize: _messageSize, color: colorScheme.onSurfaceVariant),
            //         textAlign: TextAlign.center),
            //
            //     if(onConfirm != null)
            //       ...[
            //         SizedBox(height: _spacing * 1.4),
            //         PrimaryButton.filled(
            //             icon: confIcon,
            //             text: confText, onPressed: onConfirm
            //         ),
            //       ] else const SizedBox.shrink()
            //
            //   ],
            // );

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (image.isNotEmpty) ...[
                    AspectRatio(
                        aspectRatio: _aspectRatio,
                        child: Image.asset(image,
                            errorBuilder: (context, err, st) =>
                            const SizedBox.shrink())),
                    const SizedBox(height: 12)
                  ] else
                    const SizedBox.shrink(),
                  Text(title, style: TextStyle(fontSize: _titleSize, fontWeight: FontWeight.w500)),
                  SizedBox(height: _spacing),
                  Text(message,
                      style: TextStyle(fontSize: _messageSize, color: colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center),

                  if(onConfirm != null)
                    ...[
                      SizedBox(height: _spacing * 1.4),
                      PrimaryButton.filled(
                          icon: confIcon,
                          text: confText, onPressed: onConfirm
                      ),
                    ] else const SizedBox.shrink()

                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
  );

  @override
  Widget build(BuildContext context) {

    switch(_variant){
      case _Variant.page:
        _aspectRatio = 2;
        _spacing = 16;
        _titleSize = 20;
        _messageSize = 16;

        return Scaffold(
          appBar: AppBar(),
          body: buildBody(context),
        );
      case _Variant.body:
        _aspectRatio = 2;
        _spacing = 16;
        _titleSize = 20;
        _messageSize = 16;

        return Scaffold(
          body: buildBody(context),
        );

      case _Variant.widget:
        _aspectRatio = 3;
        _spacing = 12;
        _titleSize = 18;
        _messageSize = 14;

        return buildBody(context);
    }
  }


  Future<Map<String, dynamic>?> getData(
      BuildContext context, String key) async {
    try {
      final response = await rootBundle.loadString("assets/alerts/alerts.json");
      return json.decode(response)[key];
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}

