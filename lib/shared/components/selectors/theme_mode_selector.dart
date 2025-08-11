import 'package:arpicoprivilege/core/extentions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/theme_provider.dart';

Future<ThemeMode?> showThemeModePicker({
  required BuildContext context,
  required ThemeMode initialValue,
}) async {
  return await showModalBottomSheet(
      context: context,
      builder: (context){
        return ThemeModeSelector(
          initialValue: initialValue,
          onChanged: (value)=> Navigator.of(context).pop(value),
        );
      },
      showDragHandle: true
  );
}


class ThemeModeSelector extends StatefulWidget {
  final Function(ThemeMode theme) onChanged;
  final ThemeMode initialValue;
  const ThemeModeSelector({super.key,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  State<ThemeModeSelector> createState() => _ThemeModeSelectorState();
}

class _ThemeModeSelectorState extends State<ThemeModeSelector> {
  ThemeMode? _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.initialValue;
  }
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.all(12.0).copyWith(top: 0),
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant))
            ),
            child: Text("Select Theme", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))
        ),
        ...List.generate(ThemeMode.values.length, (index) {
          return RadioListTile<ThemeMode>(
            title: Text(ThemeMode.values[index].name.toUpperCaseFirst()),
            value: ThemeMode.values[index],
            groupValue: _selectedTheme,
            onChanged: (ThemeMode? value) {
              _selectedTheme = value;
              if(value != null){
                themeProvider.setTheme(value);
                Future.delayed(const Duration(milliseconds: 1000), (){
                  widget.onChanged.call(value);
                });
              }
            },
          );
        }),
        const SizedBox(height: 12.0)
      ],
    );
  }
}

