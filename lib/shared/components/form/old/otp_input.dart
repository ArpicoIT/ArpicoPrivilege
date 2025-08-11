import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInputField extends StatefulWidget {
  final Function(String code)? onEditingComplete;
  final Function(String code)? onChanged;
  final int maxDigits;
  final bool autoFocus;
  final String? initialValue;
  final TextInputType keyboardType;

  const OTPInputField({
    super.key,
    this.onEditingComplete,
    this.onChanged,
    this.maxDigits = 6,
    this.autoFocus = true,
    this.initialValue,
    this.keyboardType = TextInputType.number,
  });

  @override
  State<OTPInputField> createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late List<String> _code;
  late int _maxDigits;

  int _buttonIndex = 0;
  Timer? _timer;

  /// for testing
  bool FIELD_VISIBILITY = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _maxDigits = widget.maxDigits;

    _code = List.generate(_maxDigits, (i) => ' ');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoFocus) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });

    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        _setSelection();
      }
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // controller.text = code[_buttonIndex];
        if (_controller.text.isNotEmpty) {
          _setSelection();
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant OTPInputField oldWidget) {
    if (widget.initialValue != null &&
        widget.initialValue != oldWidget.initialValue) {
      if (widget.initialValue!.length == widget.maxDigits) {
        _code = widget.initialValue!.split('');
        _code = _code.map((e) => e == '' ? ' ' : e).toList();
        setState(() {});
      }
    }

    if (widget.maxDigits != oldWidget.maxDigits) {
      _maxDigits = widget.maxDigits;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setSelection() {
    _controller.selection = const TextSelection(
      baseOffset: 0,
      extentOffset: 1,
    );
  }

  void _callOnEditingComplete(List<String> code) {
    if (!code.contains(' ')) {
      _timer = Timer(const Duration(milliseconds: 600), (){
        widget.onEditingComplete?.call(code.join());
      });
    }
  }

  // void showMobileKeyboard(BuildContext context) {
  //   WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  //   // FocusScope.of(context).requestFocus(btnFocusNode);
  //
  //
  //   // Show the numeric keyboard
  //   SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  //
  //   // Set the keyboard input type to numeric
  //   SystemChannels.textInput.invokeMethod<void>('TextInput.setClient', [
  //     0, // Client ID (use a unique value if managing multiple clients)
  //     {
  //       'inputType': {
  //         'name': 'TextInputType.number',
  //         'signed': true,
  //         'decimal': false,
  //       },
  //       'textCapitalization': 'TextCapitalization.none', // Set text capitalization (required field)
  //       'inputAction': 'TextInputAction.done', // Action button on the keyboard
  //       'keyboardAppearance': 'KeyboardAppearance.dark', // Keyboard appearance (optional)
  //       'autocorrect': false, // Disable autocorrect (optional)
  //     }
  //   ]);
  // }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: FIELD_VISIBILITY
            ? const TextSelectionThemeData()
            : const TextSelectionThemeData(
                cursorColor: Colors.transparent, // Change the cursor color
                selectionColor:
                    Colors.transparent, // Change the selection background color
                selectionHandleColor: Colors
                    .transparent, // Change the color of the selection handles
              ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextSelectionTheme(
            data: FIELD_VISIBILITY
                ? const TextSelectionThemeData()
                : const TextSelectionThemeData(
                    cursorColor: Colors.transparent, // Change the cursor color
                    selectionColor: Colors
                        .transparent, // Change the selection background color
                    selectionHandleColor: Colors
                        .transparent, // Change the color of the selection handles
                  ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLength: _maxDigits,
              style:
                  TextStyle(color: FIELD_VISIBILITY ? null : Colors.transparent),
              textInputAction: (_buttonIndex == _maxDigits - 1)
                  ? TextInputAction.done
                  : TextInputAction.none,
              showCursor: true,
              textAlign: TextAlign.center,
              keyboardType: widget.keyboardType,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxDigits),
              ],
              decoration: FIELD_VISIBILITY
                  ? const InputDecoration(counterText: "")
                  : const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                      counter: SizedBox.shrink(),
                      counterText: "",
                      isDense: true),
              onEditingComplete: () {
                _focusNode.unfocus();
                _callOnEditingComplete(_code);
              },
              onChanged: (text) async {
                // controller.selection = TextSelection.collapsed(offset: index);
                // int cursorPos = controller.selection.base.offset;
                // print("Text: $text");
                // print("Current Position: $cursorPos");
                // controller.text = text;

                _code[_buttonIndex] = text;
                _code = _code.map((e) => e == '' ? ' ' : e).toList();
                widget.onChanged?.call(_code.join());

                if (text.isNotEmpty) {
                  _buttonIndex++;
                  if (_buttonIndex > _maxDigits - 1) {
                    _focusNode.unfocus();
                    _callOnEditingComplete(_code);
                    _buttonIndex = _maxDigits - 1;
                  }
                } else {
                  _buttonIndex--;
                  if (_buttonIndex < 0) {
                    _focusNode.unfocus();
                    _buttonIndex = 0;
                  }
                }

                _controller.text = _code[_buttonIndex];
                setState(() {});
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < _maxDigits; i++)
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(_focusNode);

                    _controller.text = _code[i];
                    _buttonIndex = i;

                    if (_controller.text.isNotEmpty) {
                      _setSelection();
                    }

                    setState(() {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    constraints:
                        const BoxConstraints(minHeight: 52.0, minWidth: 52.0),
                    decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.fromBorderSide(
                            (_buttonIndex == i && _focusNode.hasFocus)
                                ? BorderSide(
                                    color: colorScheme.primary, width: 1.2)
                                : BorderSide.none
                            // : BorderSide(color: colorScheme.outline.withAlpha(50), width: 1.2)
                            )),
                    child: Text(_code[i],
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('FIELD_VISIBILITY', FIELD_VISIBILITY));
  }
}

/*class OTPInputField extends StatefulWidget {
  final Function(String code)? onEditingComplete;
  final Function(String code)? onChanged;
  final int maxDigits;
  final bool autoFocus;
  final String? initialValue;

  const OTPInputField({super.key,
    this.onEditingComplete,
    this.onChanged,
    this.maxDigits = 4,
    this.autoFocus = true,
    this.initialValue,
  });

  @override
  State<OTPInputField> createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  late List<String> code;

  int _buttonIndex = 0;

  @override
  void initState() {
    super.initState();
    code = List.generate(4, (i) => ' ');

    WidgetsBinding.instance.addPostFrameCallback((_){
      if(widget.autoFocus){
        FocusScope.of(context).requestFocus(focusNode);
      }
    });

    controller.addListener((){
      if(controller.text.isNotEmpty) {
        _setSelection();
      }
    });

    focusNode.addListener((){
      if(focusNode.hasFocus){
        controller.text = code[_buttonIndex];
        if(controller.text.isNotEmpty) {
          _setSelection();
        }
      }
    });
  }

  void _setSelection() {
    controller.selection = const TextSelection(
      baseOffset: 0,
      extentOffset: 1,
    );
  }

  // void showMobileKeyboard(BuildContext context) {
  //   WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  //   // FocusScope.of(context).requestFocus(btnFocusNode);
  //
  //
  //   // Show the numeric keyboard
  //   SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  //
  //   // Set the keyboard input type to numeric
  //   SystemChannels.textInput.invokeMethod<void>('TextInput.setClient', [
  //     0, // Client ID (use a unique value if managing multiple clients)
  //     {
  //       'inputType': {
  //         'name': 'TextInputType.number',
  //         'signed': true,
  //         'decimal': false,
  //       },
  //       'textCapitalization': 'TextCapitalization.none', // Set text capitalization (required field)
  //       'inputAction': 'TextInputAction.done', // Action button on the keyboard
  //       'keyboardAppearance': 'KeyboardAppearance.dark', // Keyboard appearance (optional)
  //       'autocorrect': false, // Disable autocorrect (optional)
  //     }
  //   ]);
  // }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 4; i++)
              FloatingActionButton(
                elevation: 0,
                backgroundColor: (_buttonIndex == i && focusNode.hasFocus) ? Colors.purpleAccent : null,
                onPressed: () {
                  if(!focusNode.hasFocus){
                    FocusScope.of(context).requestFocus(focusNode);
                  }

                  controller.text = code[i];
                  _buttonIndex = i;

                  if (controller.text.isNotEmpty) {
                    _setSelection();
                  }

                  setState(() {});
                },
                child: Text(code[i]),
              ),
          ],
        ),
        const SizedBox(height: 24.0),
        TextField(
          controller: controller, //TextEditingController(text: code[_buttonIndex]),
          focusNode: focusNode,
          maxLength: 4,
          style: const TextStyle(letterSpacing: 10, fontSize: 24),
          showCursor: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            counterText: "",
            border: OutlineInputBorder(),
          ),
          onChanged: (text) {
            code[_buttonIndex] = text;
            code = code.map((e) => e == '' ? ' ' : e).toList();

            widget.onChanged?.call(code.join());

            if(text.isNotEmpty) {
              _buttonIndex++;
              if (_buttonIndex > 3) {
                if(!code.contains(' ')) {
                  widget.onEditingComplete?.call(code.join());
                }
                FocusScope.of(context).unfocus();
                _buttonIndex = 3;
              }
            } else {
              _buttonIndex--;
              if (_buttonIndex < 0) {
                FocusScope.of(context).unfocus();
                _buttonIndex = 0;
              }
            }

            // code = code.map((e) => e == '' ? ' ' : e).toList();
            controller.text = code[_buttonIndex];

            setState(() {});
          },
        ),

      ],
    );
  }

}*/
