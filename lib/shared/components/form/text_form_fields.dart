import 'package:arpicoprivilege/core/utils/formatter.dart';
import 'package:arpicoprivilege/shared/components/form/form_widgets.dart';
import 'package:flutter/material.dart';

/*class TextFormFieldNew extends StatelessWidget {
  final GlobalKey<FormFieldState>? fKey;
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
  final bool clearButtonVisibility;
  final bool autofocus;

  const TextFormFieldNew({
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
    this.clearButtonVisibility = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final _focusNode = focusNode ?? FocusNode();
    final _controller = controller ?? TextEditingController(text: initialValue);
    final ValueNotifier<bool> _hasFocusNotifier = ValueNotifier(false);

    _focusNode.addListener(() {
      _hasFocusNotifier.value = _focusNode.hasFocus;
      onFocus?.call(_focusNode.hasFocus);
    });

    return Theme(
      data: Theme.of(context).copyWith(
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const WidgetStatePropertyAll(EdgeInsets.zero),
            minimumSize: const WidgetStatePropertyAll(Size.zero),
            visualDensity: VisualDensity.compact,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          FormWidgets.titleBuilder(context, title: title, hint: titleHint),
          ValueListenableBuilder<bool>(
            valueListenable: _hasFocusNotifier,
            builder: (context, hasFocus, _) {
              return TextFormField(
                key: fKey,
                controller: _controller,
                focusNode: _focusNode,
                autofocus: autofocus,
                keyboardType: keyboardType,
                inputFormatters: [EmojiFilteringTextInputFormatter()],
                textInputAction: textInputAction,
                textCapitalization: textCapitalization,
                obscuringCharacter: obscuringCharacter,
                obscureText: obscureText,
                maxLength: maxLength,
                maxLines: maxLines,
                minLines: minLines,
                enabled: enabled,
                readOnly: readOnly,
                autovalidateMode: autoValidateMode,
                decoration: decoration.copyWith(
                  hintText: hintText,
                  filled: true,
                  fillColor: hasFocus ? Colors.grey.shade200 : Colors.transparent,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _controller,
                        builder: (context, value, _) {
                          final showClearBtn = value.text.isNotEmpty && clearButtonVisibility;
                          return FormWidgets.clearButtonBuilder(
                            context,
                            visibility: showClearBtn,
                            onPressed: () => _controller.clear(),
                            valueListenable: ValueNotifier<bool>(showClearBtn),
                            hasSuffix: decoration.suffixIcon != null,
                          );
                        },
                      ),
                      decoration.suffixIcon ?? const SizedBox.shrink(),
                    ],
                  ),
                ),
                validator: validator,
                onChanged: onChanged,
                onFieldSubmitted: onSubmitted,
                onTap: () {
                  fKey?.currentState?.reset();
                  _hasFocusNotifier.value = true;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}*/


class TextFormFieldNew extends StatefulWidget {
  final GlobalKey<FormFieldState>? fKey;
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
  final void Function()? onEditingComplete;
  final AutovalidateMode? autoValidateMode;
  final bool clearButtonVisibility;
  final bool autofocus;


  const TextFormFieldNew({
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
    this.onEditingComplete,
    this.autoValidateMode,
    this.clearButtonVisibility = false,
    this.autofocus = false,

  });

  @override
  State<TextFormFieldNew> createState() => _TextFormFieldNewState();
}

class _TextFormFieldNewState extends State<TextFormFieldNew> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  late ValueNotifier<bool> _clearBtnNotifier;
  late InputDecoration _inputDecoration;

  bool _isFocused = false;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _clearBtnNotifier = ValueNotifier<bool>(false);

    _inputDecoration = widget.decoration.copyWith(
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FormWidgets.clearButtonBuilder(
              context,
              visibility: widget.clearButtonVisibility,
              valueListenable: _clearBtnNotifier,
              onPressed: (){
                _resetValidation(true);
                _controller.clear();
              },
              hasSuffix: widget.decoration.suffixIcon != null
          ),
          widget.decoration.suffixIcon ?? const SizedBox.shrink(),
        ],
      ),
      hintText: widget.hintText,
    );

    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });

      widget.onFocus?.call(_isFocused);
      _resetValidation(_isFocused);
    });


    _controller.addListener((){
      _clearBtnNotifier.value = _controller.text.isNotEmpty;
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TextFormFieldNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != null) {
      _controller.text = widget.initialValue!;
      _clearBtnNotifier.value = _controller.text.isNotEmpty;
    }
  }

  @override
  void didChangeDependencies() {
    _clearBtnNotifier.value = _controller.text.isNotEmpty;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
                minimumSize: WidgetStatePropertyAll(Size.zero),
                visualDensity: VisualDensity.compact,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
              )
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          FormWidgets.titleBuilder(context, title: widget.title, hint: widget.titleHint),
          TextFormField(
            key: widget.fKey,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            controller: widget.controller,
            focusNode: widget.focusNode,
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
            decoration: _inputDecoration.copyWith(
                filled: !_isFocused
            ),
            validator: widget.validator,
            onEditingComplete: widget.onEditingComplete,
            // onChanged: (value){
            //   _clearBtnNotifier.value = value.isNotEmpty;
            //   widget.onChanged?.call(value);
            // },
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: () => _resetValidation(false),
            // onTap: _resetKey,
          ),
        ],
      ),
    );
  }

  // void _resetKey(){
  //   if(widget.fKey != null && _isFocused){
  //     widget.fKey?.currentState?.reset();
  //   }
  // }

  void _resetValidation(bool can){
    if(widget.fKey != null && can){
      widget.fKey?.currentState?.reset();
    }
  }

  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   _controller.dispose();
  //   _clearBtnNotifier.dispose();
  //   super.dispose();
  // }
}
