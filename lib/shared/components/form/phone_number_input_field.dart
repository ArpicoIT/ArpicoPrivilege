// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/country_picker_dialog.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';
//
// // intl_phone_field: ^3.2.0
//
// class PhoneInputField extends StatefulWidget {
//   final GlobalKey<FormState>? fKey;
//   final String? title;
//   final String? titleHint;
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final Function(bool focus)? onFocus;
//   final Function(bool focus)? whenFocusLost;
//   final String? initialValue;
//
//   final bool autofocus;
//   final TextInputAction? textInputAction;
//   final bool readOnly;
//   final bool enabled;
//   final String? hintText;
//   final String? labelText;
//   final InputDecoration? decoration;
//   final AutovalidateMode? autoValidateMode;
//   final String? Function(PhoneNumber?)? validator;
//   final Function(PhoneNumber value) onChanged;
//   final bool showClearButton;
//
//
//   const PhoneInputField({
//     super.key,
//     this.fKey,
//     this.title,
//     this.titleHint,
//     this.controller,
//     this.focusNode,
//     this.onFocus,
//     this.whenFocusLost,
//     this.initialValue,
//
//     this.autofocus = false,
//     this.textInputAction,
//     this.readOnly = false,
//     this.enabled = true,
//     this.hintText,
//     this.labelText,
//     this.decoration,
//     this.autoValidateMode,
//     this.validator,
//     required this.onChanged,
//     this.showClearButton = false,
//
//   });
//
//   @override
//   State<PhoneInputField> createState() => _PhoneInputFieldState();
// }
//
// class _PhoneInputFieldState extends State<PhoneInputField> {
//   late FocusNode _focusNode;
//   late TextEditingController _controller;
//   final String _initialCountryCode = 'LK';
//   bool _showClearButton = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode = widget.focusNode ?? FocusNode();
//     _controller = widget.controller ?? TextEditingController();
//
//     _focusNode.addListener(() {
//       widget.onFocus?.call(_focusNode.hasFocus);
//
//       if(!_focusNode.hasFocus){
//         widget.whenFocusLost?.call(false);
//       }
//     });
//
//     if (widget.initialValue != null) {
//       _controller.text = PhoneNumber.fromCompleteNumber(completeNumber: widget.initialValue!).number;
//     }
//
//     WidgetsBinding.instance.addPostFrameCallback((_){
//       _controller.addListener((){
//         if(_controller.text.isNotEmpty && !_showClearButton){
//           setState(() {
//             _showClearButton = true;
//           });
//         }
//         if(_controller.text.isEmpty && _showClearButton){
//           setState(() {
//             _showClearButton = false;
//           });
//         }
//       });
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant PhoneInputField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.initialValue != oldWidget.initialValue && widget.initialValue != null) {
//       _controller.text = PhoneNumber.fromCompleteNumber(completeNumber: widget.initialValue!).number;
//     }
//   }
//
//
//   @override
//   void dispose() {
//     _focusNode.unfocus();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Row buildSuffix(BuildContext context, {Function()? onPressedClear, Widget? suffix}){
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         if(widget.showClearButton && _showClearButton)
//           IconButton(
//             onPressed: onPressedClear,
//             icon: Icon(Icons.cancel)
//           )
//         else
//           const SizedBox.shrink(),
//
//         suffix ?? const SizedBox.shrink()
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget suffixIcon = buildSuffix(context,
//       onPressedClear: (){
//         _controller.clear();
//         widget.onChanged.call(PhoneNumber.fromCompleteNumber(completeNumber: ''));
//       },
//       suffix: widget.decoration?.suffixIcon
//     );
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         widget.title != null
//             ? Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: RichText(
//             text: TextSpan(
//                 text: widget.title,
//                 style: Theme.of(context).textTheme.titleSmall,
//                 children: [
//                   TextSpan(
//                       text: widget.titleHint,
//                       style: TextStyle(color: Colors.grey))
//                 ]),
//           ),
//         )
//             : const SizedBox.shrink(),
//
//         Form(
//           key: widget.fKey,
//           child: IntlPhoneField(
//             controller: _controller,
//             focusNode: _focusNode,
//             autofocus: widget.autofocus,
//             textInputAction: widget.textInputAction,
//             readOnly: widget.readOnly,
//             enabled: widget.enabled,
//             decoration: widget.decoration?.copyWith(
//                 hintText: widget.hintText,
//                 labelText: widget.labelText,
//                 enabled: widget.enabled,
//                 counterText: "",
//                 suffixIcon: suffixIcon
//             ) ?? InputDecoration(
//                 hintText: widget.hintText,
//                 labelText: widget.labelText,
//                 enabled: widget.enabled,
//                 counterText: "",
//               suffixIcon: suffixIcon
//             ),
//             invalidNumberMessage: "Invalid mobile number format",
//             initialCountryCode: _initialCountryCode,
//             autovalidateMode: AutovalidateMode.onUnfocus,
//             showCountryFlag: true,
//             dropdownTextStyle: Theme.of(context).textTheme.titleMedium,
//             pickerDialogStyle: PickerDialogStyle(
//               backgroundColor: Theme.of(context).colorScheme.surface,
//               listTileDivider: const SizedBox.shrink(),
//               searchFieldInputDecoration: InputDecoration(
//                   hintText: "Search country",
//                   suffixIcon: Icon(Icons.search)
//               ),
//             ),
//             onChanged: (value){
//               widget.onChanged.call(value);
//             },
//             onCountryChanged: (value){
//               _controller.clear();
//               widget.onChanged.call(PhoneNumber.fromCompleteNumber(completeNumber: ''));
//             },
//             validator: (phoneNumber) {
//               return phoneNumber == null || phoneNumber.number.isEmpty
//                   ? "Please enter a valid mobile number"
//                   : null;
//             },
//           ),
//         )
//
//       ],
//     );
//
//   }
// }
//
