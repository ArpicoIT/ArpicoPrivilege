import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import 'form_widgets.dart';

class PhoneFormFieldView extends StatefulWidget {
  static const supportedLocales = [
    Locale('ar'),
    // not supported by material yet
    // Locale('ckb'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('hu'),
    Locale('it'),
    // not supported by material yet
    // Locale('ku'),
    Locale('nb'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('tr'),
    Locale('uz'),
    Locale('zh'),
    // ...
  ];

  final GlobalKey<FormState>? formKey;
  final String? title;
  final String? titleHint;
  final String? hintText;
  final bool showClearButton;
  final bool enabled;
  final bool autofocus;
  final InputDecoration decoration;
  final Function(bool focus)? onFocus;


  final PhoneController controller;
  final FocusNode focusNode;
  final bool isCountryButtonPersistent;
  final bool mobileOnly;
  final Locale locale;

  const PhoneFormFieldView({
    super.key,
    this.formKey,
    this.title,
    this.titleHint,
    this.hintText,
    this.showClearButton = false,
    this.enabled = true,
    this.autofocus = false,
    this.decoration = const InputDecoration(),
    this.onFocus,

    required this.controller,
    required this.focusNode,
    this.isCountryButtonPersistent = true,
    this.mobileOnly = true,
    this.locale = const Locale('en', ''),
  });

  @override
  State<PhoneFormFieldView> createState() => _PhoneFormFieldViewState();
}

class _PhoneFormFieldViewState extends State<PhoneFormFieldView> {
  late FocusNode _focusNode;
  late PhoneController _controller;
  late ValueNotifier<bool> _clearBtnNotifier;

  @override
  void initState() {
    _focusNode = widget.focusNode;
    _controller = widget.controller;
    _clearBtnNotifier = ValueNotifier<bool>(false);

    _focusNode.addListener(() {
      widget.onFocus?.call(_focusNode.hasFocus);
    });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _controller.addListener((){
        _clearBtnNotifier.value = _controller.value.nsn.isNotEmpty;
      });
    });
  }


  PhoneNumberInputValidator? _getValidator(BuildContext context) {
    List<PhoneNumberInputValidator> validators = [];
    if (widget.mobileOnly) {
      validators.add(PhoneValidator.validMobile(context));
    } else {
      validators.add(PhoneValidator.valid(context));
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
    final label = PhoneFieldLocalization.of(context).phoneNumber;

    Widget suffixIcon = FormWidgets.suffixWithCloseBuilder(
        context,
        hasClearButton: widget.showClearButton,
        valueListenable: _clearBtnNotifier,
        onPressed: (){widget.formKey?.currentState?.reset();},
        suffix: widget.decoration.suffixIcon
    );

    InputDecoration decoration = widget.decoration.copyWith(
      suffixIcon: suffixIcon,
      hintText: widget.hintText ?? label,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormWidgets.titleBuilder(context, title: widget.title, hint: widget.titleHint),

        Form(
          key: widget.formKey,
          child: AutofillGroup(
            child: Localizations.override(
              context: context,
              locale: widget.locale,
              child: Builder(
                builder: (context) {
                  return PhoneFormField(
                    focusNode: widget.focusNode,
                    controller: widget.controller,
                    isCountryButtonPersistent: widget.isCountryButtonPersistent,
                    autofocus: widget.autofocus,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    countrySelectorNavigator: CountrySelectorNavigator.draggableBottomSheet(
                      searchAutofocus: true,
                      searchBoxTextStyle: TextStyle(),
                    ),
                    decoration: decoration,
                    enabled: widget.enabled,
                    countryButtonStyle: const CountryButtonStyle(
                      showFlag: true,
                      showIsoCode: false,
                      showDialCode: true,
                      showDropdownIcon: true,
                      padding: EdgeInsets.only(left: 12)
                    ),
                    validator: _getValidator(context),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // ignore: avoid_print
                    onSaved: (p) => print('saved $p'),
                    // ignore: avoid_print
                    onChanged: (p) => print('changed $p'),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}


