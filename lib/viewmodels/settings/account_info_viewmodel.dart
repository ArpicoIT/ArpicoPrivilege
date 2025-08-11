
import 'package:arpicoprivilege/core/handlers/callback_handler.dart';
import 'package:arpicoprivilege/data/mixin/authentication_mixin.dart';
import 'package:arpicoprivilege/data/repositories/user_repository.dart';
import 'package:arpicoprivilege/handler.dart';
import 'package:arpicoprivilege/shared/pages/page_alert.dart';
import 'package:arpicoprivilege/shared/customize/custom_loader.dart';
import 'package:arpicoprivilege/shared/customize/custom_toast.dart';
import 'package:arpicoprivilege/viewmodels/base_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localized_alerts/localized_alerts.dart' as appAlerts;

import '../../app/app_routes.dart';
import '../../core/handlers/error_handler.dart';
import '../../core/utils/validates.dart';
import '../../data/repositories/app_cache_repository.dart';
import '../../l10n/app_translator.dart';
import '../../shared/components/form/form_widgets.dart';
import '../../views/authentication/security_authentication.dart';

class AccountInfoViewmodel extends BaseViewModel with AuthenticationMixin {
  // 🧾 Field Names
  final List<String> textFields = [
    "firstName",
    "lastName",
    "birthday",
    "nic",
    "mobile",
    "email",
    "address1",
    "address2",
    "address3",
    "city",
  ];

  final List<String> dropdownFields = [
    "title",
    "gender",
  ];

  // 🧠 Form State
  final formKey = GlobalKey<FormState>();

  late final Map<String, TextEditingController> controllers;
  late final Map<String, FocusNode> focusNodes;

  // ⬇️ Dropdown Selections
  late final Map<String, String> selectedItems;

  final List<String> titleOptions = ["Mr.", "Mrs.", "Miss", "Ms."];
  final List<String> genderOptions = ["Male", "Female", "Other"];

  // 📡 Reactive State Notifiers
  final buttonNotifier = ValueNotifier<bool>(true);
  final emailStatusNotifier = ValueNotifier<VerificationStatus>(
    VerificationStatus.unknown,
  );

  AccountInfoViewmodel(){
    // Initialize Controllers for TextFields
    controllers = {for (var key in textFields) key: TextEditingController()};

    // Initialize FocusNodes for TextFields
    focusNodes = {for (var key in textFields) key: FocusNode()};

    // Initialize Strings for Dropdowns
    selectedItems = {for (var key in dropdownFields) key: ""};

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final toast = CustomToast.of(context);

      try {
        final user = AppCacheRepository.loadUserCache();

        // Storing values for all field types
        selectedItems["title"] =
        (titleOptions.contains(user?.custTitle) ? user?.custTitle : "")!;
        selectedItems["gender"] =
        (genderOptions.contains(user?.custSex) ? user?.custSex : "")!;
        controllers["firstName"]?.text = user?.custFirstName ?? "";
        controllers["lastName"]?.text = user?.custLastName ?? "";
        controllers["birthday"]?.text = user?.custDob == null
            ? ""
            : DateFormat('MMMM dd, yyyy').format(user!.custDob!);
        controllers["nic"]?.text = user?.custNic ?? "";
        controllers["mobile"]?.text = user?.custMobNo1 ?? "";
        controllers["email"]?.text = user?.custEmail1 ?? "";
        controllers["address1"]?.text = user?.custPreAdd1 ?? "";
        controllers["address2"]?.text = user?.custPreAdd2 ?? "";
        controllers["address3"]?.text = user?.custPreAdd3 ?? "";
        controllers["city"]?.text = user?.custPreCity ?? "";

        if (context.mounted) {
          notifyListeners();
        }

        emailStatusNotifier.value = Validates.isValidEmail(user?.custEmail1??"")
            ? VerificationStatus.verified
            : VerificationStatus.unknown;
        _updateButtonState();

        controllers["email"]!.addListener(() {
          emailStatusNotifier.value = (user?.custEmail1 == controllers["email"]!.text &&
              Validates.isValidEmail(controllers["email"]!.text))
              ? VerificationStatus.verified
              : VerificationStatus.unknown;
          _updateButtonState();
        });
      } catch (e) {
        toast.showPrimary(e.toString());
      }
    });
  }

  void _updateButtonState(){}


  bool get isEmailValidated => (controllers["email"]!.text.isEmpty
      ? true
      : Validates.isValidEmail(controllers["email"]!.text)
      ? emailStatusNotifier.value == VerificationStatus.verified
      : false);

  Future<void> onUpdate() async {
    final toast = CustomToast.of(context);
    final loader = CustomLoader.of(context);
    final errorHandler = ErrorHandler.of(context);

    unFocusBackground();

    if (formKey.currentState!.validate() != true) {
      return;
    }

    if(!isEmailValidated){
      toast.showPrimary("Email address should be either empty or verified");
      return;
    }

    try {
      await loader.show();

      final accessToken = await getValidAccessToken();
      final loginUser = await decodeValidLoginUser();

      final result = await UserRepository().updateUserDetails(
        custId: loginUser.loginCustId,
        title: selectedItems["title"],
        firstName: controllers["firstName"]?.text,
        lastName: controllers["lastName"]?.text,
        gender: selectedItems["gender"],
        mobile: controllers["mobile"]?.text,
        address1: controllers["address1"]?.text,
        address2: controllers["address2"]?.text,
        address3: controllers["address3"]?.text,
        email: controllers["email"]?.text,
        city: controllers["city"]?.text,
        token: accessToken,
      );

      if (result is CallbackSuccess) {
        await refreshAndSaveAccessToken();
        await getAndCacheValidUser();
        await loader.close();

        if (context.mounted) {
          await appAlerts.showAlertById(context, 'profileUpdated',
                  (key) => AppTranslator.of(context).call(key));
          if (context.mounted) Navigator.of(context).pop(true);
        }
      } else {
        await loader.close();
        toast.showPrimary(result.message);
      }
    } catch (e) {
      await loader.close();
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
    }
  }

  Future<void> verifyEmail() async {
    final toast = CustomToast.of(context);
    final navigator = Navigator.of(context);
    final errorHandler = ErrorHandler.of(context);

    if (emailStatusNotifier.value == VerificationStatus.verified || !Validates.isValidEmail(controllers["email"]!.text)) {
      return;
    }

    try {
      final requested = await requestEmailOtp(context, controllers["email"]!.text);

      if(!requested){
        return;
      }

      final controller = SecurityAuthController(
          address: controllers["email"]!.text,
          onVerifyCode: (ctx, code) async => await verifyEmailOtp(ctx, controllers["email"]!.text, code),
          onResendCode: (ctx, address) async => await requestEmailOtp(ctx, controllers["email"]!.text),
          whenComplete: (ctx, v) {
            if (v == true) {
              Navigator.of(ctx).pop(v);
            }
          });

      final result = await navigator.pushNamed(
          AppRoutes.securityAuthentication,
          arguments: controller);

      emailStatusNotifier.value = (result == true)
          ? VerificationStatus.verified
          : VerificationStatus.unverified;
      _updateButtonState();

    } catch (e) {
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
    }
  }

  void unFocusBackground() {
    for (var node in focusNodes.values) {
      node.unfocus();
    }
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    // Dispose FocusNodes and Controllers
    for (var node in focusNodes.values) {
      node.dispose();
    }
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

/// v1.0
// class AccountInfoViewmodel extends ChangeNotifier with AuthenticationMixin {
//   final formKey = GlobalKey<FormState>();
//
//   final List<String> textFields = [
//     "firstName",
//     "lastName",
//     "birthday",
//     "nic",
//     "mobile",
//     "email",
//     "address1",
//     "address2",
//     "address3",
//     "city"
//   ];
//
//   final List<String> dropdowns = ["title", "gender"];
//
//   // Dynamic FocusNodes for all TextFields, Dropdowns
//   late final Map<String, FocusNode> focusNodes;
//
//   // Dynamic TextEditingControllers for text input fields
//   late final Map<String, TextEditingController> controllers;
//
//   // Dynamic Strings for dropdown fields
//   late final Map<String, String> selectedItems;
//
//   final List<String> titleOptions = ["Mr.", "Mrs.", "Miss", "Ms."];
//   final List<String> genderOptions = ["Male", "Female", "Other"];
//
//   final buttonNotifier = ValueNotifier(true);
//   final emailStatusNotifier = ValueNotifier(VerificationStatus.unknown);
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   AccountInfoViewmodel(){
//     // Initialize Controllers for TextFields
//     controllers = {for (var name in textFields) name: TextEditingController()};
//
//     // Initialize FocusNodes for TextFields
//     focusNodes = {for (var name in textFields) name: FocusNode()};
//
//     // Initialize Strings for Dropdowns
//     selectedItems = {for (var name in dropdowns) name: ""};
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final toast = CustomToast.of(_context);
//       try {
//         final user = AppCacheRepository.loadUserCache();
//
//         // Storing values for all field types
//         selectedItems["title"] =
//         (titleOptions.contains(user?.custTitle) ? user?.custTitle : "")!;
//         selectedItems["gender"] =
//         (genderOptions.contains(user?.custSex) ? user?.custSex : "")!;
//         controllers["firstName"]?.text = user?.custFirstName ?? "";
//         controllers["lastName"]?.text = user?.custLastName ?? "";
//         controllers["birthday"]?.text = user?.custDob == null
//             ? ""
//             : DateFormat('MMMM dd, yyyy').format(user!.custDob!);
//         controllers["nic"]?.text = user?.custNic ?? "";
//         controllers["mobile"]?.text = user?.custMobNo1 ?? "";
//         controllers["email"]?.text = user?.custEmail1 ?? "";
//         controllers["address1"]?.text = user?.custPreAdd1 ?? "";
//         controllers["address2"]?.text = user?.custPreAdd2 ?? "";
//         controllers["address3"]?.text = user?.custPreAdd3 ?? "";
//         controllers["city"]?.text = user?.custPreCity ?? "";
//
//         if (_context.mounted) {
//           notifyListeners();
//         }
//
//         emailStatusNotifier.value = Validates.isValidEmail(user?.custEmail1??"")
//             ? VerificationStatus.verified
//             : VerificationStatus.unknown;
//         _updateButtonState();
//
//         controllers["email"]!.addListener(() {
//           emailStatusNotifier.value = (user?.custEmail1 == controllers["email"]!.text &&
//               Validates.isValidEmail(controllers["email"]!.text))
//               ? VerificationStatus.verified
//               : VerificationStatus.unknown;
//           _updateButtonState();
//         });
//       } catch (e) {
//         toast.showPrimary(e.toString());
//       }
//     });
//   }
//
//   void _updateButtonState(){
//     // for future development
//   }
//
//   void _updateStorageLoginUser() async {
//     // final User user = (await getUserFromStorage()).copyWith(
//     //   custEmail1: controllers["email"]?.text
//     // );
//     //
//     // await AppCacheRepository.saveUserCache(user);
//   }
//
//   bool get isEmailValidated => (controllers["email"]!.text.isEmpty
//       ? true
//       : Validates.isValidEmail(controllers["email"]!.text)
//       ? emailStatusNotifier.value == VerificationStatus.verified
//       : false);
//
//   Future<void> onUpdateDetails(BuildContext context) async {
//     final toast = CustomToast.of(context);
//     final loader = CustomLoader.of(context);
//     final navigator = Navigator.of(context);
//     try {
//       unFocusBackground(context);
//
//       if (formKey.currentState!.validate() != true) {
//         return;
//       } else if(!isEmailValidated){
//         toast.showPrimary("Email address should be either empty or verified.");
//         return;
//       }
//       else {
//         await loader.show();
//
//         final accessToken = await getValidAccessToken();
//         final loginUser = await decodeValidLoginUser();
//
//         final result = await UserRepository().updateUserDetails(
//           custId: loginUser.loginCustId,
//           title: selectedItems["title"],
//           firstName: controllers["firstName"]?.text,
//           lastName: controllers["lastName"]?.text,
//           gender: selectedItems["gender"],
//           mobile: controllers["mobile"]?.text,
//           address1: controllers["address1"]?.text,
//           address2: controllers["address2"]?.text,
//           address3: controllers["address3"]?.text,
//           email: controllers["email"]?.text,
//           city: controllers["city"]?.text,
//           token: accessToken,
//         );
//
//         if (result is CallbackSuccess && context.mounted) {
//           final accessToken = await getValidAccessToken();
//           final user = await getAndCacheValidUser();
//           await loader.close();
//
//           if(context.mounted){
//             PageAlert.replace(Key("profileUpdated"), context, onConfirm: (){
//               navigator.pop();
//             });
//           }
//           toast.showPrimary(result.message);
//         } else {
//           await loader.close();
//           toast.showPrimary(result.message);
//         }
//       }
//     } catch (e) {
//       await loader.close();
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<void> verifyEmail() async {
//     final toast = CustomToast.of(_context);
//     final navigator = Navigator.of(_context);
//
//     try {
//       if (emailStatusNotifier.value == VerificationStatus.verified || !Validates.isValidEmail(controllers["email"]!.text)) {
//         return;
//       }
//       else {
//           final requested = await requestEmailOtp(_context, controllers["email"]!.text);
//
//           if(requested){
//             final controller = SecurityAuthController(
//                 address: controllers["email"]!.text,
//                 onVerifyCode: (ctx, code) async => await verifyEmailOtp(ctx, controllers["email"]!.text, code),
//                 onResendCode: (ctx, address) async => await requestEmailOtp(ctx, controllers["email"]!.text),
//                 whenComplete: (ctx, v) {
//                   if (v == true) {
//                     Navigator.of(ctx).pop(v);
//                   }
//                 });
//
//             final verifyResult = await navigator.pushNamed(
//                 AppRoutes.securityAuthentication,
//                 arguments: controller);
//
//             emailStatusNotifier.value = (verifyResult == true)
//                 ? VerificationStatus.verified
//                 : VerificationStatus.unverified;
//
//             if(verifyResult == true) {
//               _updateStorageLoginUser();
//             }
//
//             _updateButtonState();
//           }
//           else {
//             throw "An error occur";
//           }
//       }
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//   }
//
//
//   void unFocusBackground(BuildContext context) {
//     for (var node in focusNodes.values) {
//       node.unfocus();
//     }
//     FocusScope.of(context).unfocus();
//   }
//
//   @override
//   void dispose() {
//     // Dispose FocusNodes and Controllers
//     for (var node in focusNodes.values) {
//       node.dispose();
//     }
//     for (var controller in controllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
// }