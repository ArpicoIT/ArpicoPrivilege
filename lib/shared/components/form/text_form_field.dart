import 'package:arpicoprivilege/core/utils/formatter.dart';
import 'package:arpicoprivilege/shared/components/form/form_widgets.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/validates.dart';

class _TextFormFieldView extends StatefulWidget {
  final String? title;
  final String? titleHint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(bool focus)? onFocus;
  final String? initialValue;

  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String obscuringCharacter;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;
  final bool readOnly;

  final InputDecoration decoration;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final AutovalidateMode? autoValidateMode;
  final GlobalKey<FormFieldState>? fKey;
  final bool showClearButton;
  final bool autofocus;


  const _TextFormFieldView({
    super.key,
    this.fKey,
    this.title,
    this.titleHint,
    this.controller,
    this.focusNode,
    this.onFocus,
    this.initialValue,

    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.decoration = const InputDecoration(),
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.enabled,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autoValidateMode,
    this.showClearButton = false,
    this.autofocus = false,

  });


  @override
  State<_TextFormFieldView> createState() => _TextFormFieldViewState();
}

class _TextFormFieldViewState extends State<_TextFormFieldView> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  late ValueNotifier<bool> _clearBtnNotifier;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _clearBtnNotifier = ValueNotifier<bool>(false);

    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    _focusNode.addListener(() {
      widget.onFocus?.call(_focusNode.hasFocus);
    });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _controller.addListener((){
        _clearBtnNotifier.value = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(covariant _TextFormFieldView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void didChangeDependencies() {
    _clearBtnNotifier.value = _controller.text.isNotEmpty;
    super.didChangeDependencies();
  }

  // @override
  // void dispose() {
  //   _focusNode.unfocus();
  //   _controller.dispose();
  //   _clearBtnNotifier.dispose();
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    Widget suffixIcon = FormWidgets.suffixWithCloseBuilder(
        context,
        hasClearButton: widget.showClearButton,
        valueListenable: _clearBtnNotifier,
        onPressed: (){_controller.clear();},
        suffix: widget.decoration.suffixIcon
    );

    InputDecoration decoration = widget.decoration.copyWith(
      suffixIcon: suffixIcon,
      hintText: widget.hintText,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormWidgets.titleBuilder(context, title: widget.title, hint: widget.titleHint),
        TextFormField(
          key: widget.fKey,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          controller: _controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          inputFormatters: [
            EmojiFilteringTextInputFormatter()
          ],
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autovalidateMode: widget.autoValidateMode,
          decoration: decoration,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
        ),
      ],
    );
  }
}

class TextInputField extends _TextFormFieldView {
  const TextInputField({
    super.key,
    super.fKey,
    super.title,
    super.titleHint,
    super.controller,
    super.focusNode,
    super.onFocus,
    super.hintText,
    super.initialValue,
    super.onChanged,
    super.onSubmitted,
    super.validator,
    super.decoration,
    super.maxLength,
    super.maxLines,
    super.minLines,
    super.keyboardType,
    super.textInputAction,
    super.showClearButton,
    super.readOnly,
  });
}

class PasswordInputField extends _TextFormFieldView {
  const PasswordInputField({
    super.key,
    super.fKey,
    String? title,
    super.controller,
    super.focusNode,
    super.onFocus,
    String? hintText,
    super.initialValue,
    super.showClearButton,
  }) : super(
    title: title ?? 'Password',
    hintText: hintText ?? 'Enter your password',
    obscureText: true,
  );
}

class NoteInputField extends _TextFormFieldView {
  const NoteInputField({
    super.key,
    super.fKey,
    super.title,
    super.controller,
    super.focusNode,
    super.onFocus,
    super.hintText,
    super.initialValue,
    super.onChanged,
    super.onSubmitted,
    super.validator,
    int minLines = 5,
    super.showClearButton,
  }) : super(
    keyboardType: TextInputType.multiline,
    minLines: minLines
  );
}

class NicInputField extends _TextFormFieldView {
  NicInputField({
    super.key,
    super.fKey,
    super.title,
    super.titleHint,
    super.controller,
    super.focusNode,
    super.onFocus,
    String? hintText,
    super.initialValue,
    super.onChanged,
    super.onSubmitted,
    super.decoration,
    super.textInputAction,
    super.showClearButton,
    super.autofocus,
    super.enabled,
    super.readOnly,
    AutovalidateMode? autoValidateMode
  }) : super(
    hintText: hintText ?? "Your nic number", //  (e.g. 123456789V or 199512345678)
    maxLength: 12,
    autoValidateMode: autoValidateMode ?? AutovalidateMode.onUnfocus,
    validator: (value) {
      final nicRegex = RegExp(r'^(\d{9}[VXvx]|\d{12})$');

      if (value == null || value.isEmpty) {
        return 'Please enter a valid NIC number';
      }
      if (!nicRegex.hasMatch(value)) {
        return 'Invalid NIC number format';
      }
      return null;
    }
  );
}

class NameInputField extends _TextFormFieldView {
  NameInputField({
    super.key,
    super.fKey,
    super.title,
    super.titleHint,
    super.controller,
    super.focusNode,
    super.onFocus,
    super.hintText,
    super.initialValue,
    super.onChanged,
    InputDecoration decoration = const InputDecoration(),
    super.textInputAction,
    super.showClearButton,
    bool validationRequired = true,
  }): super (
    maxLength: 25,
    decoration: decoration.copyWith(
      counterText: ''
    ),
    autoValidateMode: AutovalidateMode.onUnfocus,
    validator: (value) => Validates.byInputType(value, TextInputType.name, validationRequired)
  );
}

class EmailInputField extends _TextFormFieldView {
  EmailInputField({
    super.key,
    super.fKey,
    super.title,
    super.titleHint,
    super.controller,
    super.focusNode,
    super.onFocus,
    super.hintText,
    super.initialValue,
    super.onChanged,
    super.decoration,
    super.textInputAction,
    super.showClearButton,
    bool validationRequired = true,
    AutovalidateMode? autoValidateMode
  }): super (
    autoValidateMode: autoValidateMode ?? AutovalidateMode.onUnfocus,
    validator: (value) => Validates.byInputType(
        value, TextInputType.emailAddress, validationRequired),
  );
}



