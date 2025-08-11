// import 'package:arpicoprivilege/core/handlers/callback_handler.dart';
// import 'package:arpicoprivilege/core/handlers/error_handler.dart';
// import 'package:arpicoprivilege/core/utils/validates.dart';
// import 'package:arpicoprivilege/data/repositories/authentication_repository.dart';
// import 'package:arpicoprivilege/data/repositories/ebill_repository.dart';
// import 'package:arpicoprivilege/viewmodels/authentication_viewmodel.dart';
// import 'package:arpicoprivilege/viewmodels/base_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:phone_form_field/phone_form_field.dart';
//
// import '../../app/app_routes.dart';
// import '../../core/constants/app_consts.dart';
// import '../../data/mixin/authentication_mixin.dart';
// import '../../handler.dart';
// import '../../shared/components/form/form_widgets.dart';
// import '../../shared/pages/page_alert.dart';
// import '../../shared/customize/custom_loader.dart';
// import '../../shared/customize/custom_toast.dart';
// import '../../views/authentication/security_authentication.dart';
// import '../../views/OLD/security_authentication_old.dart';
//
// class EBillRegisterViewmodel extends BaseViewModel with AuthenticationMixin {
//   final phoneKey = GlobalKey<FormState>();
//   final emailKey = GlobalKey<FormFieldState>();
//
//   final phoneCtrl = PhoneController(initialValue: PhoneNumber(isoCode: kIsoCode, nsn: ''));
//   final emailCtrl = TextEditingController();
//   String initialPhoneNumber = "";
//   String initialEmailAddress = "";
//
//   final phoneFocus = FocusNode();
//   final emailFocus = FocusNode();
//
//   bool isTermsAccepted = false;
//   final buttonNotifier = ValueNotifier(false);
//
//   final phoneStatusNotifier = ValueNotifier(VerificationStatus.unknown);
//   final emailStatusNotifier = ValueNotifier(VerificationStatus.unknown);
//
//   EBillRegisterViewmodel() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final loginUser = await decodeValidLoginUser();
//       initialPhoneNumber =
//           _parsePhoneNumber(loginUser.loginCustMobNo ?? "").international;
//       initialEmailAddress = loginUser.loginCustEmail ?? "";
//
//       // initialPhoneNumber = "";
//       // initialEmailAddress = "";
//
//       phoneCtrl.value = _parsePhoneNumber(initialPhoneNumber);
//       emailCtrl.text = initialEmailAddress;
//
//       phoneStatusNotifier.value =
//       _parsePhoneNumber(initialPhoneNumber).isValid()
//           ? VerificationStatus.verified
//           : VerificationStatus.unknown;
//       emailStatusNotifier.value = Validates.isValidEmail(initialEmailAddress)
//           ? VerificationStatus.verified
//           : VerificationStatus.unknown;
//       _updateRegisterButtonState();
//
//       phoneCtrl.addListener(() {
//         phoneStatusNotifier.value =
//         (initialPhoneNumber == phoneCtrl.value.international &&
//             phoneCtrl.value.isValid())
//             ? VerificationStatus.verified
//             : VerificationStatus.unknown;
//         _updateRegisterButtonState();
//       });
//
//       emailCtrl.addListener(() {
//         emailStatusNotifier.value = (initialEmailAddress == emailCtrl.text &&
//             Validates.isValidEmail(emailCtrl.text))
//             ? VerificationStatus.verified
//             : VerificationStatus.unknown;
//         _updateRegisterButtonState();
//       });
//     });
//   }
//
//   PhoneNumber _parsePhoneNumber(String value) {
//     try {
//       return PhoneNumber.parse(value);
//     } catch (e) {
//       return PhoneNumber(isoCode: kIsoCode, nsn: '');
//     }
//   }
//
//   void toggleTerms(bool? value) {
//     isTermsAccepted = value ?? false;
//     _updateRegisterButtonState();
//     notifyListeners();
//   }
//
//   void _updateRegisterButtonState() {
//     buttonNotifier.value =
//         phoneStatusNotifier.value == VerificationStatus.verified &&
//             phoneCtrl.value.isValid() &&
//             (emailCtrl.text.isEmpty
//                 ? true
//                 : Validates.isValidEmail(emailCtrl.text)
//                 ? emailStatusNotifier.value == VerificationStatus.verified
//                 : false) &&
//             isTermsAccepted;
//   }
//
//   Future<void> onRegisterContinue() async {
//     final toast = CustomToast.of(context);
//     final loader = CustomLoader.of(context);
//     final navigator = Navigator.of(context);
//
//     try {
//       await loader.show();
//
//       final accessToken = await getValidAccessToken();
//       final loginUser = await decodeValidLoginUser();
//       final uuid = await getDeviceId();
//
//       final result = await EBillRepository().eBillRegistration(
//           loyaltyId: loginUser.loginCustId!,
//           nic: loginUser.loginCustNic!,
//           mobile: phoneCtrl.value.international,
//           email: emailStatusNotifier.value == VerificationStatus.verified
//               ? emailCtrl.text
//               : null,
//           name: loginUser.loginCustFullName!,
//           uuid: uuid,
//           token: accessToken);
//
//       if (result is CallbackSuccess && context.mounted) {
//         final accessToken = await getValidAccessToken();
//         final user = await getAndCacheValidUser();
//         await loader.close();
//
//         if (context.mounted) {
//           PageAlert.replace(Key("eBillRegistered"), context,
//               onConfirm: () {
//                 navigator.pop();
//               });
//         }
//         toast.showPrimary(result.message);
//       } else {
//         await loader.close();
//         toast.showPrimary(result.message);
//       }
//     } catch (e) {
//       await loader.close();
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<void> verifyPhone() async {
//     final toast = CustomToast.of(context);
//     final navigator = Navigator.of(context);
//     final errorHandler = ErrorHandler.of(context);
//
//
//     try {
//       if (phoneStatusNotifier.value == VerificationStatus.verified) {
//         return;
//       } else if (!phoneCtrl.value.isValid()) {
//         return;
//       } else {
//         final requested = await requestPhoneOtp(context, phoneCtrl.value.international);
//
//         if (requested) {
//           final controller = SecurityAuthController(
//               address: phoneCtrl.value.international,
//               onVerifyCode: (ctx, code) async => await verifyPhoneOtp(ctx, phoneCtrl.value.international, code),
//               onResendCode: (ctx, address) async => await requestPhoneOtp(ctx, phoneCtrl.value.international),
//               whenComplete: (ctx, v) {
//                 if (v == true) {
//                   Navigator.of(ctx).pop(v);
//                 }
//               });
//
//           final verifyResult = await navigator.pushNamed(AppRoutes.securityAuthentication, arguments: controller);
//
//           phoneStatusNotifier.value = (verifyResult == true)
//               ? VerificationStatus.verified
//               : VerificationStatus.unverified;
//           _updateRegisterButtonState();
//         } else {
//           return;
//         }
//       }
//     } catch (e) {
//       final error = await errorHandler.showDialog(e);
//       (error != null) ? toast.showPrimary(error.toString()) : null;
//     }
//   }
//
//   Future<void> verifyEmail() async {
//     final toast = CustomToast.of(context);
//     final navigator = Navigator.of(context);
//     final errorHandler = ErrorHandler.of(context);
//
//     try {
//       if (emailStatusNotifier.value == VerificationStatus.verified) {
//         return;
//       } else if (!Validates.isValidEmail(emailCtrl.text)) {
//         return;
//       } else {
//         final requested = await requestEmailOtp(context, emailCtrl.text);
//
//         if (requested) {
//           final controller = SecurityAuthController(
//               address: emailCtrl.text,
//               onVerifyCode: (ctx, code) async => await verifyEmailOtp(ctx, emailCtrl.text, code),
//               onResendCode: (ctx, address) async => await requestEmailOtp(ctx, emailCtrl.text),
//               whenComplete: (ctx, v) {
//                 if (v == true) {
//                   Navigator.of(ctx).pop(v);
//                 }
//               });
//
//           final verifyResult = await navigator.pushNamed(AppRoutes.securityAuthentication, arguments: controller);
//
//           emailStatusNotifier.value = (verifyResult == true)
//               ? VerificationStatus.verified
//               : VerificationStatus.unverified;
//           _updateRegisterButtonState();
//         } else {
//           return;
//         }
//       }
//     } catch (e) {
//       final error = await errorHandler.showDialog(e);
//       (error != null) ? toast.showPrimary(error.toString()) : null;
//     }
//   }
//
//   void unFocusBackground(BuildContext context) {
//     phoneFocus.unfocus();
//     emailFocus.unfocus();
//     FocusScope.of(context).unfocus();
//   }
// }
//
// /*class EBillRegisterViewmodel extends ChangeNotifier with AuthenticationMixin {
//   final phoneKey = GlobalKey<FormState>();
//   final emailKey = GlobalKey<FormFieldState>();
//
//   final phoneCtrl =
//       PhoneController(initialValue: PhoneNumber(isoCode: kIsoCode, nsn: ''));
//   final emailCtrl = TextEditingController();
//   String initialPhoneNumber = "";
//   String initialEmailAddress = "";
//
//   final phoneFocus = FocusNode();
//   final emailFocus = FocusNode();
//
//   bool isTermsAccepted = false;
//   final buttonNotifier = ValueNotifier(false);
//
//   final phoneStatusNotifier = ValueNotifier(VerificationStatus.unknown);
//   final emailStatusNotifier = ValueNotifier(VerificationStatus.unknown);
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   EBillRegisterViewmodel() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final loginUser = await getValidLoginUser();
//       initialPhoneNumber =
//           _parsePhoneNumber(loginUser.loginCustMobNo ?? "").international;
//       initialEmailAddress = loginUser.loginCustEmail ?? "";
//
//       // initialPhoneNumber = "";
//       // initialEmailAddress = "";
//
//       phoneCtrl.value = _parsePhoneNumber(initialPhoneNumber);
//       emailCtrl.text = initialEmailAddress;
//
//       phoneStatusNotifier.value =
//           _parsePhoneNumber(initialPhoneNumber).isValid()
//               ? VerificationStatus.verified
//               : VerificationStatus.unknown;
//       emailStatusNotifier.value = Validates.isValidEmail(initialEmailAddress)
//           ? VerificationStatus.verified
//           : VerificationStatus.unknown;
//       _updateRegisterButtonState();
//
//       phoneCtrl.addListener(() {
//         phoneStatusNotifier.value =
//             (initialPhoneNumber == phoneCtrl.value.international &&
//                     phoneCtrl.value.isValid())
//                 ? VerificationStatus.verified
//                 : VerificationStatus.unknown;
//         _updateRegisterButtonState();
//       });
//
//       emailCtrl.addListener(() {
//         emailStatusNotifier.value = (initialEmailAddress == emailCtrl.text &&
//                 Validates.isValidEmail(emailCtrl.text))
//             ? VerificationStatus.verified
//             : VerificationStatus.unknown;
//         _updateRegisterButtonState();
//       });
//     });
//   }
//
//   PhoneNumber _parsePhoneNumber(String value) {
//     try {
//       return PhoneNumber.parse(value);
//     } catch (e) {
//       return PhoneNumber(isoCode: kIsoCode, nsn: '');
//     }
//   }
//
//   void toggleTerms(bool? value) {
//     isTermsAccepted = value ?? false;
//     _updateRegisterButtonState();
//     notifyListeners();
//   }
//
//   void _updateRegisterButtonState() {
//     buttonNotifier.value =
//         phoneStatusNotifier.value == VerificationStatus.verified &&
//             phoneCtrl.value.isValid() &&
//             (emailCtrl.text.isEmpty
//                 ? true
//                 : Validates.isValidEmail(emailCtrl.text)
//                     ? emailStatusNotifier.value == VerificationStatus.verified
//                     : false) &&
//             isTermsAccepted;
//   }
//
//   Future<void> onRegisterContinue() async {
//     final toast = CustomToast.of(_context);
//     final loader = CustomLoader.of(_context);
//     final navigator = Navigator.of(_context);
//
//     try {
//       await loader.show();
//
//       final accessToken = await getValidAccessToken();
//       final loginUser = await getValidLoginUser();
//       final uuid = await getDeviceId();
//
//       final result = await EBillRepository().eBillRegistration(
//           loyaltyId: loginUser.loginCustId!,
//           nic: loginUser.loginCustNic!,
//           mobile: phoneCtrl.value.international,
//           email: emailStatusNotifier.value == VerificationStatus.verified
//               ? emailCtrl.text
//               : null,
//           name: loginUser.loginCustFullName!,
//           uuid: uuid,
//           token: accessToken);
//
//       if (result is CallbackSuccess && _context.mounted) {
//         final accessToken = await getValidAccessToken();
//         final user = await getValidUser();
//         await loader.close();
//
//         if (_context.mounted) {
//           PageAlert.replace(Key("eBillRegistered"), _context,
//               onConfirm: () {
//             navigator.pop();
//           });
//         }
//         toast.showPrimary(result.message);
//       } else {
//         await loader.close();
//         toast.showPrimary(result.message);
//       }
//     } catch (e) {
//       await loader.close();
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<void> verifyPhone() async {
//     final toast = CustomToast.of(_context);
//     final navigator = Navigator.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//
//     try {
//       if (phoneStatusNotifier.value == VerificationStatus.verified) {
//         return;
//       } else if (!phoneCtrl.value.isValid()) {
//         return;
//       } else {
//         final requested = await requestPhoneOtp(_context, phoneCtrl.value.international);
//
//         if (requested) {
//           final controller = SecurityAuthController(
//               address: phoneCtrl.value.international,
//               onVerifyCode: (ctx, code) async => await verifyPhoneOtp(ctx, phoneCtrl.value.international, code),
//               onResendCode: (ctx, address) async => await requestPhoneOtp(ctx, phoneCtrl.value.international),
//               whenComplete: (ctx, v) {
//                 if (v == true) {
//                   Navigator.of(ctx).pop(v);
//                 }
//               });
//
//           final verifyResult = await navigator.pushNamed(AppRoutes.securityAuthentication, arguments: controller);
//
//           phoneStatusNotifier.value = (verifyResult == true)
//               ? VerificationStatus.verified
//               : VerificationStatus.unverified;
//           _updateRegisterButtonState();
//         } else {
//           return;
//         }
//       }
//     } catch (e) {
//       final error = await errorHandler.showDialog(e);
//       (error != null) ? toast.showPrimary(error.toString()) : null;
//     }
//   }
//
//   Future<void> verifyEmail() async {
//     final toast = CustomToast.of(_context);
//     final navigator = Navigator.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       if (emailStatusNotifier.value == VerificationStatus.verified) {
//         return;
//       } else if (!Validates.isValidEmail(emailCtrl.text)) {
//         return;
//       } else {
//         final requested = await requestEmailOtp(_context, emailCtrl.text);
//
//         if (requested) {
//           final controller = SecurityAuthController(
//               address: emailCtrl.text,
//               onVerifyCode: (ctx, code) async => await verifyEmailOtp(ctx, emailCtrl.text, code),
//               onResendCode: (ctx, address) async => await requestEmailOtp(ctx, emailCtrl.text),
//               whenComplete: (ctx, v) {
//                 if (v == true) {
//                   Navigator.of(ctx).pop(v);
//                 }
//               });
//
//           final verifyResult = await navigator.pushNamed(AppRoutes.securityAuthentication, arguments: controller);
//
//           emailStatusNotifier.value = (verifyResult == true)
//               ? VerificationStatus.verified
//               : VerificationStatus.unverified;
//           _updateRegisterButtonState();
//         } else {
//           return;
//         }
//       }
//     } catch (e) {
//       final error = await errorHandler.showDialog(e);
//       (error != null) ? toast.showPrimary(error.toString()) : null;
//     }
//   }
//
//   void unFocusBackground(BuildContext context) {
//     phoneFocus.unfocus();
//     emailFocus.unfocus();
//     FocusScope.of(context).unfocus();
//   }
// }*/
