import 'package:arpicoprivilege/core/extentions/string_extensions.dart';
import 'package:flutter/material.dart';

Future<Gender?> showGenderPicker({
  required BuildContext context,
  String? initialValue,
}) async {
  return await showModalBottomSheet(
      context: context,
      builder: (context){
        return GenderSelector(
          initialValue: initialValue,
          onChanged: (value)=> Navigator.of(context).pop(value),
        );
      },
    showDragHandle: true
  );
}


class GenderSelector extends StatefulWidget {
  final Function(Gender? gender) onChanged;
  final String? initialValue;
  const GenderSelector({super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();

    if(widget.initialValue != null){
      _selectedGender = Gender.values.firstWhere((value) => value.name == widget.initialValue);
    }
  }
  @override
  Widget build(BuildContext context) {

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
            child: Text("Select Gender", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))
        ),
        ...List.generate(Gender.values.length, (index) {
          return RadioListTile<Gender>(
            title: Text(Gender.values[index].name.toUpperCaseFirst()),
            value: Gender.values[index],
            groupValue: _selectedGender,
            onChanged: (Gender? value) {
              _selectedGender = value;
              widget.onChanged.call(value);
            },
          );
        }),
        const SizedBox(height: 12.0)
      ],
    );
  }
}

enum Gender { male, female, other }
