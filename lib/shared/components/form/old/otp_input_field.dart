import 'package:flutter/material.dart';

// flutter_otp_text_field: ^1.2.0

class OtpInputField extends StatefulWidget {
  final Function(String value) onChanged;
  final Function(String value)? onSubmitted;
  final int maxDigits;
  final bool autoFocus;

  const OtpInputField({
    super.key,
    required this.onChanged,
    this.onSubmitted,
    this.maxDigits = 6,
    this.autoFocus = true
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late int _maxDigits;
  late List<String> _otp;
  late List<TextEditingController> _digitController;
  late List<FocusNode> _digitFocus;


  @override
  void initState() {
    _maxDigits = widget.maxDigits;
    _otp = List.generate(_maxDigits, (index) => ' ');
    _digitController = List.generate(_maxDigits, (index) => TextEditingController());
    _digitFocus = List.generate(_maxDigits, (index) => FocusNode());

    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _digitController) {
      controller.dispose();
    }
    for (var focusNode in _digitFocus) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String _getOtp(int index, String value) {
    _otp[index] = value;
    return _otp.join();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        alignment: WrapAlignment.spaceBetween,
        children: [
          for (int i in Iterable.generate(_maxDigits))
            SizedBox(
              width: 54.0,
              child: TextFormField(
                controller: _digitController[i],
                focusNode: _digitFocus[i],
                autofocus: (i == 0 && widget.autoFocus),
                textInputAction: (i < _maxDigits - 1)
                    ? TextInputAction.next
                    : TextInputAction.done,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: const InputDecoration(
                    counterText: '',
                ),
                textAlign: TextAlign.center,
                onEditingComplete: () {
                  if (i < _maxDigits - 1) {
                    FocusScope.of(context).requestFocus(_digitFocus[i + 1]);
                  } else {
                    _digitFocus[i].unfocus();
                  }
                },
                onChanged: (String value) {
                  final otp = _getOtp(i, value);
                  widget.onChanged.call(otp);

                  if (value.isNotEmpty) {
                    if (i < _maxDigits - 1) {
                      FocusScope.of(context).requestFocus(_digitFocus[i + 1]);
                    } else {
                      FocusScope.of(context).unfocus();
                      widget.onSubmitted?.call(otp);
                    }
                  }
                },
                onFieldSubmitted: (value) {
                  if (i == _maxDigits - 1) {
                    final otp = _getOtp(i, value);
                    widget.onSubmitted?.call(otp);
                  }
                },
              ),
            ),
        ],
      )
    );
  }

}
