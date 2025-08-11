import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../core/constants/app_consts.dart';
import 'form_widgets.dart';

export 'package:phone_form_field/phone_form_field.dart';

class PhoneFormFieldNew extends StatefulWidget {
  final GlobalKey<FormState>? fKey;
  // final String? initialValue;
  final String? title;
  final String? titleHint;
  final String? hintText;
  final bool clearButtonVisibility;
  final bool enabled;
  final bool autofocus;
  final InputDecoration decoration;
  final Function(bool focus)? onFocus;


  final PhoneController? controller;
  final FocusNode? focusNode;
  final bool isCountryButtonPersistent;
  final bool mobileOnly;
  final Locale locale;
  final AutovalidateMode? autoValidateMode;
  final TextInputAction? textInputAction;
  final void Function()? onEditingComplete;
  final bool isRequired;

  const PhoneFormFieldNew({
    super.key,
    this.fKey,
    this.title,
    this.titleHint,
    this.hintText,
    this.clearButtonVisibility = false,
    this.enabled = true,
    this.autofocus = false,
    this.decoration = const InputDecoration(),
    this.onFocus,

    this.controller,
    this.focusNode,
    this.isCountryButtonPersistent = true,
    this.mobileOnly = true,
    this.locale = const Locale('en', ''),
    this.autoValidateMode,
    this.textInputAction,
    this.onEditingComplete,
    this.isRequired = true
  });

  @override
  State<PhoneFormFieldNew> createState() => _PhoneFormFieldNewState();
}

class _PhoneFormFieldNewState extends State<PhoneFormFieldNew> {
  late FocusNode _focusNode;
  late PhoneController _controller;
  late ValueNotifier<bool> _clearBtnNotifier;
  late InputDecoration _inputDecoration;

  bool _isFocused = false;


  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? PhoneController(initialValue: PhoneNumber(isoCode: kIsoCode, nsn: ''));
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
              },
              hasSuffix: widget.decoration.suffixIcon != null
          ),
          widget.decoration.suffixIcon ?? const SizedBox.shrink(),
        ],
      ),
      hintText: widget.hintText ?? PhoneFieldLocalization.of(context).phoneNumber,
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });

      widget.onFocus?.call(_isFocused);
      widget.fKey?.currentState?.reassemble();
      // _resetValidation(_isFocused);
    });

    _controller.addListener((){
      _clearBtnNotifier.value = _controller.value.nsn.isNotEmpty;
    });

    super.initState();
  }


  PhoneNumberInputValidator? _getValidator(BuildContext context) {
    List<PhoneNumberInputValidator> validators = [];
    if (widget.mobileOnly) {
      validators.add(PhoneValidator.validMobile(context));
    } else {
      validators.add(PhoneValidator.valid(context));
    }
    if(widget.isRequired) {
      validators.add(PhoneValidator.required(context, errorText: "Required*"));
    }
    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }

  @override
  void didChangeDependencies() {
    _clearBtnNotifier.value = _controller.value.nsn.isNotEmpty;
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
        children: [
          FormWidgets.titleBuilder(context, title: widget.title, hint: widget.titleHint),
          Form(
            key: widget.fKey,
            child: AutofillGroup(
              child: Localizations.override(
                context: context,
                locale: widget.locale,
                child: Builder(
                  builder: (context) {
                    return PhoneFormField(
                      focusNode: _focusNode,
                      controller: _controller,
                      isCountryButtonPersistent: widget.isCountryButtonPersistent,
                      autofocus: widget.autofocus,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      countrySelectorNavigator: CountrySelectorNavigator.draggableBottomSheet(
                        searchAutofocus: true,
                        searchBoxTextStyle: TextStyle(),
                      ),
                      autovalidateMode: widget.autoValidateMode,
                      decoration: _inputDecoration.copyWith(
                          filled: !_isFocused
                      ),
                      textInputAction: widget.textInputAction,
                      enabled: widget.enabled,
                      countryButtonStyle: const CountryButtonStyle(
                          showFlag: true,
                          showIsoCode: false,
                          showDialCode: true,
                          showDropdownIcon: true,
                          padding: EdgeInsets.only(left: 12)
                      ),
                      validator: _getValidator(context),
                      onSaved: (p) => debugPrint('saved $p'),
                      onChanged: (p) => debugPrint('changed $p'),
                      onEditingComplete: widget.onEditingComplete,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _resetValidation(bool can){
    if(widget.fKey != null && can){
      widget.fKey?.currentState?.reset();
    }
  }
}