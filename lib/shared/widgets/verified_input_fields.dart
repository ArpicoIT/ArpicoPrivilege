// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/country_picker_dialog.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';
// import 'package:provider/provider.dart';
//
// import '../../viewmodels/authentication_viewmodel.dart';
// import '../enum.dart';
//
// Widget _buildVerifiedSuffix({
//   required ValueNotifier<VerificationStatus> stateListener,
//   required String tooltipHintText,
//   required VoidCallback onPressed,
// }) {
//   return ValueListenableBuilder(
//     valueListenable: stateListener,
//     builder: (context, state, _) {
//       final colorScheme = Theme.of(context).colorScheme;
//       Widget icon;
//       String message;
//
//       switch (state) {
//         case VerificationStatus.verified:
//           icon =
//               const Icon(Icons.verified_rounded, color: Colors.green, size: 24);
//           message = 'Your $tooltipHintText is confirmed.';
//           break;
//         case VerificationStatus.unverified:
//           icon = Icon(Icons.error_rounded, color: colorScheme.error, size: 24);
//           message = 'Your $tooltipHintText must be verified first.';
//           break;
//         case VerificationStatus.unknown:
//           icon = Text('Verify',
//               style: TextStyle(color: colorScheme.onPrimaryContainer));
//           message = 'Please verify your $tooltipHintText to proceed.';
//           break;
//
//         case VerificationStatus.waiting:
//           return CupertinoActivityIndicator();
//       }
//
//       return Padding(
//         padding: const EdgeInsets.only(right: 8),
//         child: IconButton(
//           tooltip: message,
//           onPressed: onPressed,
//           icon: icon,
//         ),
//       );
//     },
//   );
// }
//
// class VerifiedNicField extends StatefulWidget {
//   final FocusNode? focusNode;
//   final TextEditingController? controller;
//   final InputDecoration? decoration;
//   const VerifiedNicField(
//       {super.key, this.focusNode, this.controller, this.decoration});
//
//   @override
//   State<VerifiedNicField> createState() => VerifiedNicFieldState();
// }
//
// class VerifiedNicFieldState extends State<VerifiedNicField> {
//   late FocusNode _focusNode;
//   late TextEditingController _controller;
//
//   final fieldKey = GlobalKey<FormFieldState>();
//   final statusListener = ValueNotifier(VerificationStatus.unknown);
//   final _authFactory = AuthenticationFactory2();
//
//   @override
//   void initState() {
//     _focusNode = widget.focusNode ?? FocusNode();
//     _controller = widget.controller ?? TextEditingController();
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       _focusNode.addListener(() {
//         if (_focusNode.hasFocus) {
//           statusListener.value = VerificationStatus.unknown;
//         } else {
//           widget.focusNode?.unfocus();
//           onVerifyNic();
//         }
//       });
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant VerifiedNicField oldWidget) {
//     // if(widget.focusNode != oldWidget.focusNode && widget.focusNode != null){
//     //   _focusNode = widget.focusNode!;
//     // }
//     if(widget.controller != oldWidget.controller && widget.controller != null){
//       _controller = widget.controller!;
//     }
//
//     super.didUpdateWidget(oldWidget);
//   }
//
//   void onVerifyNic() async {
//     if (fieldKey.currentState!.validate() == true) {
//       statusListener.value = VerificationStatus.waiting;
//       statusListener.value =
//           await _authFactory.verifyNic(context, _controller.text);
//     } else {
//       return;
//     }
//   }
//
//   Widget get _getSuffixIcon => _buildVerifiedSuffix(
//       stateListener: statusListener,
//       tooltipHintText: 'Your nic number',
//       onPressed: () =>
//           _focusNode.hasFocus ? _focusNode.unfocus() : onVerifyNic());
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//         key: fieldKey,
//         controller: _controller,
//         focusNode: _focusNode,
//         decoration: widget.decoration
//                 ?.copyWith(suffixIcon: _getSuffixIcon, counterText: "") ??
//             InputDecoration(suffixIcon: _getSuffixIcon, counterText: ""),
//         maxLength: 12,
//         autovalidateMode: AutovalidateMode.onUnfocus,
//         validator: (value) {
//           final nicRegex = RegExp(r'^(\d{9}[VXvx]|\d{12})$');
//
//           if (value == null || value.isEmpty) {
//             return 'Please enter a valid nic number.';
//           }
//           if (!nicRegex.hasMatch(value)) {
//             return 'Invalid nic number format.';
//           }
//           return null;
//         });
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     _controller.dispose();
//     fieldKey.currentState?.dispose();
//     super.dispose();
//   }
// }
//
// class VerifiedMobileField extends StatefulWidget {
//   final TextEditingController controller;
//   final FocusNode? focusNode;
//   final String? initialCountryCode;
//   final InputDecoration? decoration;
//   const VerifiedMobileField(
//       {super.key,
//       required this.controller,
//       this.focusNode,
//       this.initialCountryCode,
//       this.decoration});
//
//   @override
//   State<VerifiedMobileField> createState() => VerifiedMobileFieldState();
// }
//
// class VerifiedMobileFieldState extends State<VerifiedMobileField> {
//   late FocusNode _focusNode;
//   final TextEditingController _controller = TextEditingController();
//
//   final fieldKey = GlobalKey<FormState>();
//   final statusListener = ValueNotifier(VerificationStatus.unknown);
//   final _authFactory = AuthenticationFactory2();
//
//   PhoneNumber _phoneNumber =
//       PhoneNumber(countryISOCode: "", countryCode: "", number: "");
//
//   @override
//   void initState() {
//     super.initState();
//
//     _focusNode = widget.focusNode ?? FocusNode();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       _focusNode.addListener(() {
//         if (_focusNode.hasFocus) {
//           statusListener.value = VerificationStatus.unknown;
//         } else {
//           onVerifyMobile();
//         }
//       });
//
//       _controller.addListener(() {
//         widget.controller.text = _phoneNumber.completeNumber;
//       });
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant VerifiedMobileField oldWidget) {
//     // if(widget.focusNode != oldWidget.focusNode && widget.focusNode != null){
//     //   _focusNode = widget.focusNode!;
//     // }
//     if(widget.controller != oldWidget.controller){
//       _phoneNumber = PhoneNumber.fromCompleteNumber(completeNumber: widget.controller.text);
//       _controller.text = _phoneNumber.number;
//     }
//
//     super.didUpdateWidget(oldWidget);
//   }
//
//   // @override
//   // void didUpdateWidget(covariant VerifiedMobileField oldWidget) {
//   //   if (widget.initialValue != oldWidget.initialValue && widget.initialValue != null) {
//   //     _phoneNumber = PhoneNumber.fromCompleteNumber(completeNumber: widget.initialValue!);
//   //     _controller.text = _phoneNumber.number;
//   //   }
//   //
//   //   super.didUpdateWidget(oldWidget);
//   // }
//
//   void onVerifyMobile() async {
//     if (_controller.text.isEmpty) {
//       throw "Please fill the missing information.";
//     }
//     else if (fieldKey.currentState!.validate() != true) {
//       return;
//     }
//     else if(_phoneNumber.isValidNumber()){
//       statusListener.value = VerificationStatus.waiting;
//       statusListener.value =
//           await _authFactory.verifyMobile(context, _phoneNumber.completeNumber);
//     } else {
//       // nothing
//     }
//   }
//
//   Widget get _getSuffixIcon => _buildVerifiedSuffix(
//       stateListener: statusListener,
//       tooltipHintText: 'Your mobile number',
//       onPressed: () =>
//           _focusNode.hasFocus ? _focusNode.unfocus() : onVerifyMobile());
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: fieldKey,
//       child: IntlPhoneField(
//         controller: _controller,
//         focusNode: _focusNode,
//         decoration: widget.decoration
//                 ?.copyWith(suffixIcon: _getSuffixIcon, counterText: "") ??
//             InputDecoration(suffixIcon: _getSuffixIcon, counterText: ""),
//
//         // autofocus: widget.autofocus,
//         // textInputAction: widget.textInputAction,
//         // readOnly: widget.readOnly,
//         // enabled: widget.enabled,
//
//         keyboardType: TextInputType.phone,
//         invalidNumberMessage: "Invalid mobile number format",
//         initialCountryCode: widget.initialCountryCode ?? "LK",
//         autovalidateMode: AutovalidateMode.onUnfocus,
//         showCountryFlag: false,
//         dropdownTextStyle: Theme.of(context).textTheme.titleMedium,
//         pickerDialogStyle: PickerDialogStyle(
//           backgroundColor: Theme.of(context).colorScheme.surface,
//           listTileDivider: const SizedBox.shrink(),
//           searchFieldInputDecoration: InputDecoration(
//               hintText: "Search country", suffixIcon: Icon(Icons.search)),
//         ),
//         onChanged: (value) {
//           _phoneNumber = value;
//         },
//         onCountryChanged: (value) {
//           _phoneNumber = PhoneNumber(countryISOCode: "", countryCode: "", number: "");
//           _controller.clear();
//           widget.controller.clear();
//         },
//         validator: (phoneNumber) {
//           return phoneNumber == null || phoneNumber.number.isEmpty
//               ? "Please enter a valid mobile number"
//               : null;
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     _controller.dispose();
//     fieldKey.currentState?.dispose();
//     super.dispose();
//   }
// }
