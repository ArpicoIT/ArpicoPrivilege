import 'package:arpicoprivilege/core/services/storage_service.dart';
import 'package:arpicoprivilege/views/authentication/security_authentication.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../app/app_routes.dart';
import '../core/constants/app_consts.dart';
import '../core/handlers/callback_handler.dart';
import '../core/handlers/error_handler.dart';
import '../core/utils/validates.dart';
import '../data/mixin/authentication_mixin.dart';
import '../data/repositories/authentication_repository.dart';
import '../handler.dart';
import '../shared/components/form/form_widgets.dart';
import '../shared/customize/custom_alert.dart';
import '../shared/customize/custom_loader.dart';
import '../shared/customize/custom_toast.dart';

/// v1.2 new
class SignInViewmodel extends ChangeNotifier with AuthenticationMixin {
  final phoneInputKey = GlobalKey<FormState>();
  final nicOrCardInputKey = GlobalKey<FormFieldState>();

  final phoneCtrl =
      PhoneController(initialValue: PhoneNumber(isoCode: kIsoCode, nsn: ''));
  final nicOrCardCtrl = TextEditingController();

  final phoneFocus = FocusNode();
  final nicOrCardFocus = FocusNode();

  final buttonNotifier = ValueNotifier(false);
  bool isTermsAccepted = false;

  int _loginIndex = 0;
  int get selectedTabIndex => _loginIndex;

  late BuildContext _context;
  void setContext(BuildContext context) {
    _context = context;
  }

  SignInViewmodel() {
    phoneCtrl.addListener(_updateContinueButtonState);
    nicOrCardCtrl.addListener(_updateContinueButtonState);
  }

  void toggleTerms(bool? value) {
    isTermsAccepted = value ?? false;
    _updateContinueButtonState();
    unFocusBackground(_context);
    notifyListeners();
  }

  void onTabChanged(int value) {
    _loginIndex = value;
    _updateContinueButtonState();
    notifyListeners();
  }

  void _updateContinueButtonState() {
    buttonNotifier.value = isTermsAccepted;
  }

  void onLoginContinue() async {
    final toast = CustomToast.of(_context);
    final errorHandler = ErrorHandler.of(_context);

    try {
      switch (_loginIndex) {
        case 0:
          if (phoneInputKey.currentState?.validate() != true) {
            return;
          }

          if(!phoneCtrl.value.isValid()){
            toast.showPrimary("Required* mobile number");
            return;
          }

          await _startLogin(phoneCtrl.value.international);
          break;
        case 1:
          if (nicOrCardInputKey.currentState?.validate() != true) {
            return;
          }
          await _startLogin(nicOrCardCtrl.text);
          break;
      }
    } catch (e) {
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
    }
  }

  Future<void> _startLogin(String loginAddress) async {
    final alert = CustomAlert.of(_context);
    final navigator = Navigator.of(_context);

    try {
      if (_loginIndex < 0 || _loginIndex > 1) {
        throw "Invalid login type / index";
      }

      final loginWith = LoginWith.values[_loginIndex];
      final signInResult = await requestLogin(_context,
          loginWith: loginWith, loginAddress: loginAddress);

      if (signInResult.code == 200) {
        final controller = SecurityAuthController(
            address: signInResult.data?["value"] ?? "",
            onVerifyCode: (ctx, code) async => await verifyLogin(ctx,
                loginWith: loginWith, otp: code, loginAddress: loginAddress),
            onResendCode: (ctx, address) async => await requestLogin(ctx,
                loginWith: loginWith,
                loginAddress: loginAddress) is CallbackSuccess,
            whenComplete: (ctx, v) {
              if (v is CallbackSuccess) {
                Navigator.of(ctx).pop(v);
              }
            });

        final verifyResult = await navigator
            .pushNamed(AppRoutes.securityAuthentication, arguments: controller);

        if (verifyResult is CallbackSuccess) {
          navigator.pushNamedAndRemoveUntil(
              AppRoutes.appHome, (route) => false);
        } else {
          return;
        }
      } else if (signInResult.code == 404) {
        final alertResult = await alert.openDialog(
            title: signInResult.message,
            message:
                "We could not find your account. Would you like to register now?",
            type: AlertType.info,
            confirmText: "Register",
            isCanceled: true);

        if (alertResult == "OK") {
          navigator.pushNamed(AppRoutes.register, arguments: {
            "mobile": phoneCtrl.value.international,
            "nicOrCard": nicOrCardCtrl.text,
          });
        }
      } else {
        await alert.openDialog(
          title: 'Something went wrong',
          message: signInResult.message,
          type: AlertType.error,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  void unFocusBackground(BuildContext context) {
    phoneFocus.unfocus();
    FocusScope.of(context).unfocus();
  }
}

/// v1.3 new
class RegisterViewmodel extends ChangeNotifier with AuthenticationMixin {
  /// keys
  final formKey = GlobalKey<FormState>();
  final fNameInputKey = GlobalKey<FormFieldState>();
  final lNameInputKey = GlobalKey<FormFieldState>();
  final nicOrCardInputKey = GlobalKey<FormFieldState>();
  final phoneInputKey = GlobalKey<FormState>();

  final fNameCtrl = TextEditingController();
  final lNameCtrl = TextEditingController();
  final nicOrCardCtrl = TextEditingController();
  final phoneCtrl =
      PhoneController(initialValue: PhoneNumber(isoCode: kIsoCode, nsn: ''));

  final fNameFocus = FocusNode();
  final lNameFocus = FocusNode();
  final nicOrCardFocus = FocusNode();
  final phoneFocus = FocusNode();

  final buttonNotifier = ValueNotifier(false);
  bool isTermsAccepted = false;
  bool enableNicField = false;

  late BuildContext _context;
  void setContext(BuildContext context) {
    _context = context;
  }

  RegisterViewmodel() {
    fNameCtrl.addListener(_updateContinueButtonState);
    lNameCtrl.addListener(_updateContinueButtonState);
    nicOrCardCtrl.addListener(_updateContinueButtonState);
    phoneCtrl.addListener(_updateContinueButtonState);

    WidgetsBinding.instance.addPostFrameCallback((_){
      try {
        final args = ModalRoute
            .of(_context)
            ?.settings
            .arguments as Map<String, dynamic>;

        phoneCtrl.value = PhoneNumber(isoCode: kIsoCode, nsn: args['mobile']);
        nicOrCardCtrl.text = args['nicOrCard'];

      } catch (e) {
        debugPrint('requires a Map<String, dynamic> arguments');
      }
    });
  }

  void _updateContinueButtonState() {
    buttonNotifier.value = isTermsAccepted;
  }

  void toggleTerms(bool? value) {
    isTermsAccepted = value ?? false;
    _updateContinueButtonState();
    unFocusBackground();
    notifyListeners();
  }

  void unFocusBackground() {
    fNameFocus.unfocus();
    lNameFocus.unfocus();
    nicOrCardFocus.unfocus();
    phoneFocus.unfocus();
    FocusScope.of(_context).unfocus();
  }

  void onRegisterContinue() async {
    final toast = CustomToast.of(_context);
    final navigator = Navigator.of(_context);
    final errorHandler = ErrorHandler.of(_context);

    final bool? isFormValidate = formKey.currentState?.validate();
    final bool? isPhoneValidate = phoneInputKey.currentState?.validate();

    if (isFormValidate != true || isPhoneValidate != true) {
      return;
    }

    if(!phoneCtrl.value.isValid()){
      toast.showPrimary("Required* mobile number");

      return;
    }

    try {
        final requestResult = await _requestRegistration(_context);

        if (requestResult is CallbackSuccess) {
          final controller = SecurityAuthController(
              address: requestResult.data?["value"] ?? "",
              onVerifyCode: (ctx, code) async => await verifyRegistration(
                  ctx, code,
                  token: requestResult.data?["token"] ?? ""),
              onResendCode: (ctx, address) async =>
                  await _requestRegistration(ctx) is CallbackSuccess,
              whenComplete: (ctx, v) {
                if (v is CallbackSuccess) {
                  Navigator.of(ctx).pop(v);
                }
              });

          final verifyResult = await navigator.pushNamed(
              AppRoutes.securityAuthentication,
              arguments: controller);

          if (verifyResult is CallbackSuccess) {
            final isLogged = verifyResult.data!["isLogged"];
            final accessToken = verifyResult.data!["data"]["token"];

            final isTokenStored = await saveAccessToken(accessToken);

            /// start app
            if (isTokenStored) {
              navigator.pushNamedAndRemoveUntil(
                  AppRoutes.appHome, (route) => false);
            }
          } else {
            return;
          }
        } else {
          throw requestResult.message;
        }

    } catch (e) {
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
    }
  }

  Future<CallbackResult> _requestRegistration(BuildContext context) async {
    try {
      String nic = "";
      String custId = "";

      if(Validates.isValidNic(nicOrCardCtrl.text)){
        nic = nicOrCardCtrl.text;
      }
      if(Validates.isValidLoyaltyCard(nicOrCardCtrl.text)){
        custId = nicOrCardCtrl.text;
      }

      return await requestRegistration(context,
          custId: custId,
          nic: nic,
          mobile: phoneCtrl.value.international,
          email: "",
          firstName: fNameCtrl.text,
          lastName: lNameCtrl.text);
    } catch (e) {
      rethrow;
    }
  }
}

/// register v1.1
// class RegisterViewmodel extends ChangeNotifier with AuthenticationMixin {
//   final formKey = GlobalKey<FormState>();
//   final nicKey = GlobalKey<FormFieldState>();
//   final phoneKey = GlobalKey<FormState>();
//
//   final fNameCtrl = TextEditingController();
//   final lNameCtrl = TextEditingController();
//   final nicCtrl = TextEditingController();
//   final phoneCtrl =
//       PhoneController(initialValue: PhoneNumber(isoCode: kIsoCode, nsn: ''));
//
//   final fNameFocus = FocusNode();
//   final lNameFocus = FocusNode();
//   final nicFocus = FocusNode();
//   final phoneFocus = FocusNode();
//
//   final nicStatusNotifier = ValueNotifier(VerificationStatus.unknown);
//   final phoneStatusNotifier = ValueNotifier(VerificationStatus.unknown);
//
//   final buttonNotifier = ValueNotifier(false);
//   bool isTermsAccepted = false;
//   bool enableNicField = false;
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   RegisterViewmodel() {
//     nicFocus.addListener(() async {
//       if (!nicFocus.hasFocus) {
//         await verifyNic(_context);
//         _updateContinueButtonState();
//       }
//     });
//     phoneFocus.addListener(() async {
//       if (!phoneFocus.hasFocus) {
//         await verifyPhone(_context);
//         _updateContinueButtonState();
//       }
//     });
//
//     fNameCtrl.addListener(_updateContinueButtonState);
//     lNameCtrl.addListener(_updateContinueButtonState);
//     nicCtrl.addListener(_updateContinueButtonState);
//     phoneCtrl.addListener(_updateContinueButtonState);
//   }
//
//   Future<void> verifyNic(BuildContext context) async {
//     final loader = CustomLoader.of(context);
//     final alert = CustomAlert.of(context);
//     final toast = CustomToast.of(context);
//     final navigator = Navigator.of(context);
//
//     try {
//       if (nicKey.currentState!.validate() != true) {
//         return;
//       } else {
//         nicStatusNotifier.value = VerificationStatus.waiting;
//         await loader.show();
//         final result =
//             await AuthenticationRepository().verifyNicNumber(nicCtrl.text, UUID);
//         await loader.close();
//
//         if (result.code == 200) {
//           nicStatusNotifier.value = VerificationStatus.unverified;
//           if(await alert.show(
//               title: "Account Already Exists",
//               type: AlertType.info,
//               message:
//                   "The NIC number ${nicCtrl.text} is already associated with an account.\n"
//                   "Would you like to log in instead?",
//               confirmText: "Login Now",
//               isCanceled: true
//           ) == "OK"){
//             if(context.mounted) {
//               await SignInViewmodel().login(
//                   context, index: 1, loginAddress: nicCtrl.text);
//             }
//           }
//         } else if (result.code == 404) {
//           nicStatusNotifier.value = VerificationStatus.verified;
//         } else {
//           throw result.message;
//         }
//       }
//     } catch (e) {
//       nicStatusNotifier.value = VerificationStatus.unknown;
//       await loader.close();
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<void> verifyPhone(BuildContext context) async {
//     final loader = CustomLoader.of(context);
//     final alert = CustomAlert.of(context);
//     final toast = CustomToast.of(context);
//
//     try {
//       phoneStatusNotifier.value = VerificationStatus.unknown;
//
//       if (phoneKey.currentState!.validate() != true || !phoneCtrl.value.isValid()) {
//         return;
//       }
//       else {
//         phoneStatusNotifier.value = VerificationStatus.waiting;
//         await loader.show();
//         final result = await AuthenticationRepository()
//             .verifyMobileNumber(phoneCtrl.value.international);
//         await loader.close();
//
//         if (result is CallbackSuccess) {
//           final bool isLoyalty = result.data!["loyalty"] == "true";
//
//           if (isLoyalty) {
//             phoneStatusNotifier.value = VerificationStatus.unverified;
//             if(await alert.show(
//                 title: "Account Already Exists",
//                 type: AlertType.info,
//                 message:
//                     "The mobile number ${phoneCtrl.value.international} is already registered.\n"
//                     "Would you like to log in instead?",
//                 confirmText: "Login Now",
//                 isCanceled: true) == "OK"){
//               if(context.mounted) {
//                 await SignInViewmodel().login(
//                     context, index: 0, loginAddress: phoneCtrl.value.international);
//               }
//             }
//           } else {
//             phoneStatusNotifier.value = VerificationStatus.verified;
//           }
//         }
//         else {
//           throw result.message;
//         }
//       }
//     } catch (e) {
//       phoneStatusNotifier.value = VerificationStatus.unknown;
//       await loader.close();
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   void _updateContinueButtonState() {
//     buttonNotifier.value = fNameCtrl.text.isNotEmpty &&
//         lNameCtrl.text.isNotEmpty &&
//         nicCtrl.text.isNotEmpty &&
//         phoneCtrl.value.isValid() &&
//         nicStatusNotifier.value == VerificationStatus.verified &&
//         phoneStatusNotifier.value == VerificationStatus.verified &&
//         isTermsAccepted;
//   }
//
//   void toggleTerms(bool? value) {
//     isTermsAccepted = value ?? false;
//     _updateContinueButtonState();
//     unFocusBackground(_context);
//     notifyListeners();
//   }
//
//   void unFocusBackground(BuildContext context) {
//     fNameFocus.unfocus();
//     lNameFocus.unfocus();
//     nicFocus.unfocus();
//     phoneFocus.unfocus();
//     FocusScope.of(context).unfocus();
//   }
//
//   Future<void> onRegisterContinue(BuildContext context) async {
//     final toast = CustomToast.of(context);
//     final navigator = Navigator.of(context);
//
//     try {
//       if (formKey.currentState?.validate() != true) {
//         throw "Please complete all required fields.";
//       } else if (nicKey.currentState?.validate() != true) {
//         throw "User nic number must be validated.";
//       } else if (phoneKey.currentState?.validate() != true ||
//           !phoneCtrl.value.isValid()) {
//         throw "User mobile number must be validated.";
//       } else {
//         /// send otp
//         final requestOtp = await _requestMobileOtp(context);
//
//         if (!requestOtp) {
//           return;
//         }
//
//         /// verify otp
//         bool? verified;
//         if (context.mounted) {
//           verified = await SecurityAuthentication.open<bool>(context,
//               address: phoneCtrl.value.international,
//               onVerifyCode: (ctx, code) async =>
//                   await _verifyMobileOtp(ctx, code),
//               onResendCode: (ctx, address) async =>
//                   await _requestMobileOtp(ctx));
//         }
//
//         if (verified != true) {
//           return;
//         }
//
//         /// registration
//         bool registered = false;
//         if (context.mounted) {
//           registered = await _loyaltyRegister(context);
//         }
//
//         if (registered != true) {
//           return;
//         }
//
//         /// start app
//         navigator.pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
//       }
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<bool> _loyaltyRegister(BuildContext context) async {
//     final loader = CustomLoader.of(context);
//     final toast = CustomToast.of(context);
//     final alert = CustomAlert.of(context);
//     try {
//       await loader.show();
//       final registerResult = await AuthenticationRepository()
//           .loyaltyRegister(
//               nic: nicCtrl.text,
//               mobile: phoneCtrl.value.international,
//               firstName: fNameCtrl.text,
//               lastName: lNameCtrl.text,
//               email: "",
//               uuid: UUID);
//       await loader.close();
//
//       if (registerResult is CallbackSuccess) {
//         final isLogged = registerResult.data!["isLogged"];
//         final accessToken = registerResult.data!["token"];
//
//         return setAccessTokenToStorage(accessToken);
//       } else {
//         await alert.show(
//             title: "Something went wrong",
//             type: AlertType.error,
//             message: registerResult.message);
//         return false;
//       }
//     } catch (e) {
//       toast.showPrimary(e.toString());
//       await loader.close();
//     }
//     return false;
//   }
//
//   Future<bool> _requestMobileOtp(BuildContext context) async {
//     final loader = CustomLoader.of(context);
//     final toast = CustomToast.of(context);
//     try {
//       await loader.show();
//       final requestOtpResult = await AuthenticationRepository().requestOtp(
//           nic: nicCtrl.text, mobile: phoneCtrl.value.international, uuid: UUID);
//       await loader.close();
//
//       toast.showPrimary(requestOtpResult.message);
//       return requestOtpResult is CallbackSuccess;
//     } catch (e) {
//       toast.showPrimary(e.toString());
//       await loader.close();
//     }
//     return false;
//   }
//
//   Future<bool> _verifyMobileOtp(BuildContext context, String otpCode) async {
//     final loader = CustomLoader.of(context);
//     final toast = CustomToast.of(context);
//     try {
//       await loader.show();
//       final verifyOtpResult = await AuthenticationRepository().verifyOtp(
//           nic: nicCtrl.text, mobile: phoneCtrl.value.international, otp: otpCode);
//       await loader.close();
//
//       toast.showPrimary(verifyOtpResult.message);
//       return verifyOtpResult is CallbackSuccess;
//     } catch (e) {
//       toast.showPrimary(e.toString());
//       await loader.close();
//     }
//     return false;
//   }
//
//   /* Future<bool> onRegisterContinueNew(
//       BuildContext context, {
//       required String firstName,
//       required String lastName,
//       required String nic,
//       required String mobile,
//     }) async {
//       final loader = CustomLoader.of(context);
//       final alert = CustomAlert.of(context);
//       final toast = CustomToast.of(context);
//       final navigator = Navigator.of(context);
//
//       Map<String, dynamic> callbackResult = {};
//
//       try {
//         // bool isLogged = true;
//         // String? accessToken;
//
//         await loader.show();
//         final registerResult = await AuthenticationRepository()
//             .loyaltyRegistration(
//                 nic: nic,
//                 mobile: mobile,
//                 firstName: firstName,
//                 lastName: lastName,
//                 email: "",
//                 uuid: "123456789");
//         await loader.show();
//
//         if (registerResult is CallbackSuccess) {
//           final isLogged = registerResult.data!["isLogged"];
//           final accessToken = registerResult.data!["token"];
//
//           await setAccessTokenToStorage(accessToken);
//
//           return true;
//         } else {
//           await alert.show(
//               title: "Something went wrong",
//               type: AlertType.error,
//               message: registerResult.message);
//           return false;
//         }
//
//         // change behind process
//
//         // if (accessToken == null) {
//         //   throw "User access token not found.";
//         // } else if (isLogged) {
//         //   throw "You already logged in.";
//         // } else if (enableEBillRegistration &&
//         //     !isEBillRegistered &&
//         //     context.mounted) {
//         //   await _eBillRegistration(context, accessToken);
//         // } else {
//         //   /// break
//         // }
//         //
//         // /// save token in storage
//         // await setAccessTokenToStorage(accessToken);
//         //
//         // /// navigate home screen
//         // navigator.pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
//       } catch (e) {
//         await loader.close();
//         toast.showPrimary(e.toString());
//         return false;
//       }
//     }*/
//
//   /*Future<void> onRegisterContinue(
//       BuildContext context, {
//       required String firstName,
//       required String lastName,
//       required String nic,
//       required String mobile,
//     }) async {
//       final loader = CustomLoader.of(context);
//       final alert = CustomAlert.of(context);
//       final toast = CustomToast.of(context);
//       final navigator = Navigator.of(context);
//
//       try {
//         bool isLogged = true;
//         String? accessToken;
//
//         /// go to mobile number verification with otp
//         final navigateStatus = await Navigator.of(context).pushNamed(
//             AppRoutes.otpVerification,
//             arguments: OtpVerificationScreen(
//                 nic: nic,
//                 address: mobile,
//                 addressVisibility:
//                     true)); // replace this **********************************************************************
//
//         /// check navigator return status as [CallbackStatus]
//         if (navigateStatus is CallbackSuccess) {
//           return;
//         } else {
//           await loader.show();
//
//           /// call loyalty registration API
//           final resultLoyalty = await AuthenticationRepository()
//               .loyaltyRegistration(
//                   nic: nic,
//                   mobile: mobile,
//                   firstName: firstName,
//                   lastName: lastName,
//                   email: "",
//                   uuid: "123456789");
//
//           /// check resultLoyalty status is [Success]
//           /// catch resultLoyalty data
//           if (resultLoyalty is CallbackSuccess) {
//             toast.showPrimary(resultLoyalty.message);
//             isLogged = resultLoyalty.data!["isLogged"];
//             accessToken = resultLoyalty.data!["token"];
//           } else {
//             await alert.show(
//                 title: "Something went wrong",
//                 type: AlertType.error,
//                 message: resultLoyalty.message);
//             return;
//           }
//         }
//
//         /// save token in storage
//         await setAccessTokenToStorage(accessToken);
//
//         /// navigate home screen
//         navigator.pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
//       } catch (e) {
//         await loader.close();
//         toast.showPrimary(e.toString());
//       } finally {
//         await loader.close();
//       }
//     }*/
//
//   /*Future<bool> _eBillRegistration(
//       BuildContext context, String accessToken) async {
//     final loader = CustomLoader.of(context);
//     final toast = CustomToast.of(context);
//
//     bool isSuccess = false;
//     try {
//       /// get user by decrypted token
//       final User user = await getUserByAccessToken(accessToken);
//
//       await loader.show("Registering E-Bill, please wait...");
//
//       /// call ebill registration
//       final resultEBillReg = await EBillRepository().eBillRegistration(
//         loyaltyId: user.custId!,
//         nic: user.custNic!,
//         mobile: user.custMobNo1!,
//         email: user.custEmail1!,
//         name: user.custFullName!,
//         uuid: "123456789", // user.custUuid!,
//         token: accessToken,
//       );
//
//       toast.showPrimary(resultEBillReg.message);
//       isSuccess = resultEBillReg is CallbackSuccess;
//
//       await loader.close();
//     } catch (e) {
//       await loader.close();
//     }
//
//     return isSuccess;
//   }*/
//
//   /*void onVerifyNicNew(BuildContext context, String? nicNumber) async {
//       final loader = CustomLoader.of(context);
//       final alert = CustomAlert.of(context);
//       final toast = CustomToast.of(context);
//       final navigator = Navigator.of(context);
//
//       try {
//         // nicStatusListener.value = VerificationStatus.unknown;
//
//         if (nicNumber == null || nicNumber == "") {
//           throw "Please fill the missing information.";
//         } else if (nicKey.currentState!.validate() != true) {
//           return;
//         } else {
//           nicStatusNotifier.value = VerificationStatus.waiting;
//           await loader.show();
//           final result =
//               await AuthenticationRepository().verifyNicNumber(nicNumber);
//           await loader.close();
//
//           if (result.code == 200) {
//             nicStatusNotifier.value = VerificationStatus.unverified;
//             final alertRes = await alert.show(
//                 title: "Oops..!",
//                 type: AlertType.error,
//                 message:
//                     "User with ID card number: $nicNumber, is already signed in. "
//                     "Please use a different ID card or contact support for assistance.",
//                 confirmText: "Contact Support",
//                 isCanceled: true);
//
//             if (alertRes == "OK") {
//               await navigator.pushNamed(AppRoutes.helpCenter);
//             }
//           } else if (result.code == 404) {
//             nicStatusNotifier.value = VerificationStatus.verified;
//           } else {
//             throw result.message;
//           }
//         }
//       } catch (e) {
//         nicStatusNotifier.value = VerificationStatus.unknown;
//         await loader.close();
//         toast.showPrimary(e.toString());
//       }
//     }*/
//
//   /*void onVerifyMobileNew(BuildContext context, PhoneNumber? phoneNumber) async {
//       final loader = CustomLoader.of(context);
//       final alert = CustomAlert.of(context);
//       final toast = CustomToast.of(context);
//
//       try {
//         // mobileStatusListener.value = VerificationStatus.unknown;
//
//         if (phoneNumber == null || phoneNumber.number == "") {
//           throw "Please fill the missing information.";
//         } else if (mobileKey.currentState!.validate() != true) {
//           return;
//         } else if (phoneNumber.isValidNumber()) {
//           phoneStatusNotifier.value = VerificationStatus.waiting;
//           await loader.show();
//           final result = await AuthenticationRepository()
//               .verifyMobileNumber(phoneNumber.completeNumber);
//           await loader.close();
//
//           if (result is CallbackSuccess) {
//             final bool isLoyalty = result.data!["loyalty"] == "true";
//             isEBillRegistered = result.data!["ebill"] == "true";
//
//             if (isLoyalty) {
//               phoneStatusNotifier.value = VerificationStatus.unverified;
//               await alert.show(
//                   title: "Oops..!",
//                   type: AlertType.error,
//                   message:
//                       "User with Mobile number: ${phoneNumber.completeNumber}, is already signed in. "
//                       "Please use a different Mobile number or contact support for assistance.",
//                   confirmText: "Contact Support",
//                   isCanceled: true);
//             } else {
//               phoneStatusNotifier.value = VerificationStatus.verified;
//             }
//           } else {
//             throw result.message;
//           }
//         } else {
//           // nothing
//         }
//       } catch (e) {
//         phoneStatusNotifier.value = VerificationStatus.unknown;
//         await loader.close();
//         toast.showPrimary(e.toString());
//       }
//     }*/
//
//   /*Future<void> onVerifyNic(BuildContext context, bool focus) async {
//       final toast = CustomToast.of(context);
//
//       try {
//         if (focus) {
//           nicStatusListener.value = VerificationStatus.unknown;
//         } else {
//           if (nic == null || nic == "") {
//             throw "Please fill the missing information.";
//           } else if (nicKey.currentState!.validate() != true) {
//             return;
//           } else {
//             final isExist = await _checkNicIsExist(context);
//
//             /// handle nic suffix icon
//             nicStatusListener.value = isExist
//                 ? VerificationStatus.unverified
//                 : VerificationStatus.verified;
//           }
//         }
//       } catch (e) {
//         toast.showPrimary(e.toString());
//       }
//
//       notifyListeners();
//     }
//     Future<bool> _checkNicIsExist(BuildContext context, String nic) async {
//       final loader = CustomLoader.of(context);
//       final alert = CustomAlert.of(context);
//       final toast = CustomToast.of(context);
//
//       /// def value must be true in production mode
//       bool isExist = true;
//
//       /// check nic number isExist,
//       try {
//           await loader.show();
//           final result = await AuthenticationRepository().verifyNicNumber(nic);
//           await loader.close();
//
//           if(result.code == 200){
//             await alert.show(
//                 title: "Oops..!",
//                 type: AlertType.error,
//                 message:
//                 "User with ID card number: $nic, is already signed in. "
//                     "Please use a different ID card or contact support for assistance.");
//           }
//           else if(result.code == 404){
//             isExist = false;
//           }
//           else {
//             throw result.message;
//           }
//       } catch (e) {
//         await loader.close();
//         toast.showPrimary(e.toString());
//       }
//
//       return isExist;
//     }*/
//
//   /*Future<void> onVerifyMobile(BuildContext context, bool focus) async {
//       final toast = CustomToast.of(context);
//
//       try {
//         if (focus) {
//           mobileStatusListener.value = VerificationStatus.unknown;
//         } else {
//           if (mobile == null || mobile?.number == "") {
//             throw "Please fill the missing information.";
//           } else if (mobileKey.currentState!.validate() != true) {
//             return;
//           } else {
//             final isExist = await _checkMobileIsExist(context);
//
//             /// handle nic suffix icon
//             mobileStatusListener.value = isExist
//                 ? VerificationStatus.unverified
//                 : VerificationStatus.verified;
//           }
//         }
//       } catch (e) {
//         toast.showPrimary(e.toString());
//       }
//
//       notifyListeners();
//     }
//     Future<bool> _checkMobileIsExist(BuildContext context) async {
//       final loader = CustomLoader.of(context);
//       final alert = CustomAlert.of(context);
//       final toast = CustomToast.of(context);
//
//       /// def value must be true in production mode
//       bool isExist = true;
//
//       /// check nic number isExist,
//       try {
//         if (mobile == null) {
//           throw "Mobile number not found.";
//         } else {
//           await loader.show();
//
//           final result = await AuthenticationRepository().verifyMobileNumber(mobile!.completeNumber);
//
//           if (result.data == null) {
//             throw result.message;
//           } else {
//             /// isExist value is true, it means already signed in user
//             /// if not, no user signed in according NIC number
//             isExist = result.data!["loyalty"] == "true";
//             isEBillRegistered = result.data!["ebill"] == "true";
//
//             if (isExist) {
//               await alert.show(
//                   title: "Oops..!",
//                   type: AlertType.error,
//                   message:
//                   "User with Mobile number: ${mobile!.completeNumber}, is already signed in. "
//                       "Please use a different Mobile number or contact support for assistance.");
//             } else {
//               // break
//             }
//           }
//         }
//       } catch (e) {
//         await loader.close();
//         toast.showPrimary(e.toString());
//       } finally {
//         await loader.close();
//       }
//
//       return isExist;
//     }*/
// }

/// register v1.2
// class RegisterViewmodelNew extends ChangeNotifier with AuthenticationMixin {
//   /// keys
//   final formKey = GlobalKey<FormState>();
//   final fNameKey = GlobalKey<FormFieldState>();
//   final lNameKey = GlobalKey<FormFieldState>();
//   final nicKey = GlobalKey<FormFieldState>();
//   final phoneKey = GlobalKey<FormState>();
//
//   final fNameCtrl = TextEditingController();
//   final lNameCtrl = TextEditingController();
//   final nicCtrl = TextEditingController();
//   final phoneCtrl =
//       PhoneController(initialValue: PhoneNumber(isoCode: kIsoCode, nsn: ''));
//
//   final fNameFocus = FocusNode();
//   final lNameFocus = FocusNode();
//   final nicFocus = FocusNode();
//   final phoneFocus = FocusNode();
//
//   final buttonNotifier = ValueNotifier(false);
//   bool isTermsAccepted = false;
//   bool enableNicField = false;
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   RegisterViewmodelNew() {
//     fNameCtrl.addListener(_updateContinueButtonState);
//     lNameCtrl.addListener(_updateContinueButtonState);
//     nicCtrl.addListener(_updateContinueButtonState);
//     phoneCtrl.addListener(_updateContinueButtonState);
//   }
//
//   void _updateContinueButtonState() {
//     // buttonNotifier.value = fNameCtrl.text.isNotEmpty &&
//     //     lNameCtrl.text.isNotEmpty &&
//     //     nicCtrl.text.isNotEmpty &&
//     //     phoneCtrl.value.isValid() &&
//     //     isTermsAccepted;
//     buttonNotifier.value = isTermsAccepted;
//   }
//
//   void toggleTerms(bool? value) {
//     isTermsAccepted = value ?? false;
//     _updateContinueButtonState();
//     unFocusBackground();
//     notifyListeners();
//   }
//
//   void unFocusBackground() {
//     fNameFocus.unfocus();
//     lNameFocus.unfocus();
//     nicFocus.unfocus();
//     phoneFocus.unfocus();
//     FocusScope.of(_context).unfocus();
//   }
//
//   Future<void> onRegisterContinueNew() async {
//     final toast = CustomToast.of(_context);
//     final navigator = Navigator.of(_context);
//
//     try {
//       final bool? isFormValidate = formKey.currentState?.validate();
//       final bool? isPhoneValidate = phoneKey.currentState?.validate();
//
//       if (isFormValidate != true || isPhoneValidate != true) {
//         return;
//       } else {
//
//         final requestResult = await _requestRegistration(_context);
//
//         if (requestResult is CallbackSuccess) {
//           bool? verified;
//           CallbackResult? verifyResult;
//
//           final controller = SecurityAuthController(
//               address: requestResult.data?["value"] ?? "",
//               onVerifyCode: (ctx, code) async {
//                 verifyResult = await _verifyRegistration(
//                     ctx, code,
//                     isFromTrancData: requestResult.data?["isFromTrancData"] ?? false,
//                     token: requestResult.data?["token"] ?? "");
//               },
//               onResendCode: (ctx, address) async => await _requestRegistration(ctx) is CallbackError
//           );
//
//           navigator.pushNamed(AppRoutes.securityAuthentication, arguments: controller);
//
//           return;
//
//
//
//
//
//
//           if (_context.mounted) {
//             verified = await SecurityAuthentication.open<bool>(_context,
//                 address: requestResult.data?["value"] ?? "",
//                 onVerifyCode: (ctx, code) async {
//                   verifyResult = await _verifyRegistration(
//                       ctx, code,
//                       isFromTrancData: requestResult.data?["isFromTrancData"] ?? false,
//                       token: requestResult.data?["token"] ?? "");
//                   return verifyResult is CallbackSuccess;
//                 },
//                 onResendCode: (ctx, address) async =>
//                 await _requestRegistration(ctx) is CallbackSuccess);
//           }
//
//           if(verified == true && verifyResult is CallbackSuccess) {
//
//             final isLogged = verifyResult!.data!["isLogged"];
//             final accessToken = verifyResult!.data!["data"]["token"];
//
//             final isTokenStored = await setAccessTokenToStorage(accessToken);
//
//             /// start app
//             if(isTokenStored){
//               navigator.pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
//             }
//             return;
//           }
//           return;
//         } else {
//           throw requestResult.message;
//         }
//       }
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<void> onRegisterContinueOld() async {
//     final toast = CustomToast.of(_context);
//     final navigator = Navigator.of(_context);
//
//     try {
//       final bool? isFormValidate = formKey.currentState?.validate();
//       final bool? isPhoneValidate = phoneKey.currentState?.validate();
//
//       if (isFormValidate != true || isPhoneValidate != true) {
//         return;
//       } else {
//
//         final requestResult = await _requestRegistration(_context);
//
//         if (requestResult is CallbackSuccess) {
//           bool? verified;
//           CallbackResult? verifyResult;
//
//
//           if (_context.mounted) {
//             verified = await SecurityAuthentication.open<bool>(_context,
//                 address: requestResult.data?["value"] ?? "",
//                 onVerifyCode: (ctx, code) async {
//                   verifyResult = await _verifyRegistration(
//                       ctx, code,
//                       isFromTrancData: requestResult.data?["isFromTrancData"] ?? false,
//                       token: requestResult.data?["token"] ?? "");
//                   return verifyResult is CallbackSuccess;
//                 },
//                 onResendCode: (ctx, address) async =>
//                 await _requestRegistration(ctx) is CallbackSuccess);
//           }
//
//           if(verified == true && verifyResult is CallbackSuccess) {
//
//             final isLogged = verifyResult!.data!["isLogged"];
//             final accessToken = verifyResult!.data!["data"]["token"];
//
//             final isTokenStored = await setAccessTokenToStorage(accessToken);
//
//             /// start app
//             if(isTokenStored){
//               navigator.pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
//             }
//             return;
//           }
//           return;
//         } else {
//           throw requestResult.message;
//         }
//       }
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<void> onRegisterContinue() async {
//     final toast = CustomToast.of(_context);
//     final navigator = Navigator.of(_context);
//
//     try {
//       if (formKey.currentState?.validate() != true) {
//         return;
//       } else if (phoneKey.currentState?.validate() != true ||
//           !phoneCtrl.value.isValid()) {
//         throw "Mobile number must be valid";
//       } else {
//         final requestResult = await _requestRegistration(_context);
//
//         if (requestResult is CallbackSuccess) {
//           bool? verified;
//           CallbackResult? verifyResult;
//
//           if (_context.mounted) {
//             verified = await SecurityAuthentication.open<bool>(_context,
//                 address: requestResult.data?["value"] ?? "",
//                 onVerifyCode: (ctx, code) async {
//                   verifyResult = await _verifyRegistration(
//                       ctx, code,
//                       isFromTrancData: requestResult.data?["isFromTrancData"] ?? false,
//                       token: requestResult.data?["token"] ?? "");
//                   return verifyResult is CallbackSuccess;
//                 },
//                 onResendCode: (ctx, address) async =>
//                     await _requestRegistration(ctx) is CallbackSuccess);
//           }
//
//           if(verified == true && verifyResult is CallbackSuccess) {
//
//             final isLogged = verifyResult!.data!["isLogged"];
//             final accessToken = verifyResult!.data!["data"]["token"];
//
//             final isTokenStored = await setAccessTokenToStorage(accessToken);
//
//             /// start app
//             if(isTokenStored){
//               navigator.pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
//             }
//             return;
//           }
//           return;
//         } else {
//           throw requestResult.message;
//         }
//       }
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<CallbackResult> _requestRegistration(BuildContext context) async {
//     final loader = CustomLoader.of(context);
//     final toast = CustomToast.of(context);
//     try {
//       await loader.show();
//
//       final String uuid = await getDeviceId();
//
//       final result = await AuthenticationRepository()
//           .requestLoyaltyRegistration(
//           nic: nicCtrl.text,
//           mobile: phoneCtrl.value.international,
//           firstName: fNameCtrl.text,
//           lastName: lNameCtrl.text,
//           uuid: uuid);
//
//       await loader.close();
//       toast.showPrimary(result.message);
//
//       return result;
//     } catch (e) {
//       await loader.close();
//       rethrow;
//     }
//   }
//
//   Future<CallbackResult> _verifyRegistration(BuildContext context, String code,
//       {required bool isFromTrancData, required String token}) async {
//
//     final loader = CustomLoader.of(context);
//     final toast = CustomToast.of(context);
//
//     try {
//       await loader.show();
//
//       if(token.startsWith("Bearer ")) {
//         token = token.replaceFirst('Bearer ', '');
//       }
//
//       final result = await AuthenticationRepository().verifyLoyaltyRegistration(
//           otp: code,
//           token: token,
//           existingCustomer: isFromTrancData
//       );
//
//       await loader.close();
//       toast.showPrimary(result.message);
//
//       return result;
//     } catch (e) {
//       await loader.close();
//       rethrow;
//     }
//   }
//
// }

/// signin v1.1
// class SignInViewmodel extends ChangeNotifier with AuthenticationMixin {
//   final phoneInputKey = GlobalKey<FormState>();
//   final nicOrCardInputKey = GlobalKey<FormFieldState>();
//
//   final phoneCtrl =
//   PhoneController(initialValue: PhoneNumber(isoCode: kIsoCode, nsn: ''));
//   final nicOrCardCtrl = TextEditingController();
//
//   final phoneFocus = FocusNode();
//   final nicOrCardFocus = FocusNode();
//
//   final buttonNotifier = ValueNotifier(false);
//   bool isTermsAccepted = false;
//
//   int _loginIndex = 0;
//   int get selectedTabIndex => _loginIndex;
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   SignInViewmodel() {
//     phoneCtrl.addListener(_updateContinueButtonState);
//     nicOrCardCtrl.addListener(_updateContinueButtonState);
//   }
//
//   void toggleTerms(bool? value) {
//     isTermsAccepted = value ?? false;
//     _updateContinueButtonState();
//     unFocusBackground(_context);
//     notifyListeners();
//   }
//
//   void onTabChanged(int value) {
//     _loginIndex = value;
//     _updateContinueButtonState();
//     notifyListeners();
//   }
//
//   void _updateContinueButtonState() {
//     bool isValidField = true;
//     // switch (_loginIndex) {
//     //   case 0:
//     //     isValidField = phoneCtrl.value.isValid();
//     //     break;
//     //   case 1:
//     //     isValidField = Validates.isValidNic(nicCtrl.text);
//     //     break;
//     // }
//     buttonNotifier.value = isValidField && isTermsAccepted;
//   }
//
//   void onLoginContinue() async {
//     final toast = CustomToast.of(_context);
//
//     try {
//       switch (_loginIndex) {
//         case 0:
//           if (phoneInputKey.currentState?.validate() == true) {
//             await _login(phoneCtrl.value.international);
//           } else {
//             throw "Mobile number must be validated.";
//           }
//           break;
//         case 1:
//           if (nicOrCardInputKey.currentState?.validate() == true ||
//               Validates.isValidNicOrLoyaltyCard(nicOrCardCtrl.text)) {
//             await _login(nicOrCardCtrl.text);
//           } else {
//             throw "Nic or Card number must be validated.";
//           }
//           break;
//       }
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<void> _login(String loginAddress) async {
//     final alert = CustomAlert.of(_context);
//     final toast = CustomToast.of(_context);
//     final navigator = Navigator.of(_context);
//
//     try {
//       if (_loginIndex < 0 || _loginIndex > 1) {
//         throw "Invalid login type / index";
//       }
//
//       final loginWith = LoginWith.values[_loginIndex];
//       final signInResult = await requestLogin(_context, loginWith: loginWith, loginAddress: loginAddress);
//
//       if (signInResult.code == 200) {
//         final controller = SecurityAuthController(
//             address: signInResult.data?["value"] ?? "",
//             onVerifyCode: (ctx, code) async => await verifyLogin(ctx, loginWith: loginWith, otp: code, loginAddress: loginAddress),
//             onResendCode: (ctx, address) async => await requestLogin(ctx, loginWith: loginWith, loginAddress: loginAddress) is CallbackSuccess,
//             whenComplete: (ctx, v) {
//               if (v is CallbackSuccess) {
//                 Navigator.of(ctx).pop(v);
//               }
//             });
//
//         final verifyResult = await navigator.pushNamed(AppRoutes.securityAuthentication, arguments: controller);
//
//         if (verifyResult is CallbackSuccess) {
//           navigator.pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
//         }
//         else {
//           return;
//         }
//       } else if (signInResult.code == 404) {
//         final alertResult = await alert.show(
//             title: signInResult.message,
//             message:
//             "We could not find your account. Would you like to register now?",
//             type: AlertType.info,
//             confirmText: "Register",
//             isCanceled: true);
//
//         if (alertResult == "OK") {
//           navigator.pushNamed(AppRoutes.register);
//         }
//       } else {
//         await alert.show(
//           title: 'Something went wrong',
//           message: signInResult.message,
//           type: AlertType.error,
//         );
//       }
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   // Future<CallbackResult<Map<String, dynamic>>> _requestLogin(
//   //     BuildContext context,
//   //     {required int index,
//   //     required String loginAddress}) async {
//   //   final loader = CustomLoader.of(context);
//   //   final toast = CustomToast.of(context);
//   //
//   //   try {
//   //     await loader.show();
//   //     late CallbackResult<Map<String, dynamic>> signInResult;
//   //     switch (index) {
//   //       case 0:
//   //         signInResult =
//   //             await AuthenticationRepository().login(phone: loginAddress);
//   //         break;
//   //       case 1:
//   //         signInResult =
//   //             await AuthenticationRepository().login(nic: loginAddress);
//   //         break;
//   //     }
//   //     await loader.close();
//   //     toast.showPrimary(signInResult.message);
//   //     return signInResult;
//   //   } catch (e) {
//   //     await loader.close();
//   //     toast.showPrimary(e.toString());
//   //     return CallbackError(e.toString(), 400);
//   //   }
//   // }
//   //
//   // Future<bool> _verifyLogin(BuildContext context,
//   //     {required int index,
//   //     required String otp,
//   //     required String loginAddress}) async {
//   //   final loader = CustomLoader.of(context);
//   //   final toast = CustomToast.of(context);
//   //
//   //   try {
//   //     await loader.show();
//   //     late CallbackResult<Map<String, dynamic>> loginVerifyResult;
//   //     switch (index) {
//   //       case 0:
//   //         loginVerifyResult = await AuthenticationRepository()
//   //             .loginVerify(otp: otp, phone: loginAddress);
//   //         break;
//   //       case 1:
//   //         loginVerifyResult = await AuthenticationRepository()
//   //             .loginVerify(otp: otp, nic: loginAddress);
//   //         break;
//   //     }
//   //     await loader.close();
//   //
//   //     // check loginVerifyResult status
//   //     if (loginVerifyResult is CallbackSuccess) {
//   //       final accessToken = loginVerifyResult.data!["token"];
//   //       // save token in storage
//   //       return setAccessTokenToStorage(accessToken);
//   //     } else {
//   //       toast.showPrimary(loginVerifyResult.message);
//   //       return false;
//   //     }
//   //   } catch (e) {
//   //     await loader.close();
//   //     toast.showPrimary(e.toString());
//   //   }
//   //   return false;
//   // }
//
//   void unFocusBackground(BuildContext context) {
//     phoneFocus.unfocus();
//     FocusScope.of(context).unfocus();
//   }
// }
