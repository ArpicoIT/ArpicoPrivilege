// import 'package:arpicoprivilege/core/handlers/callback_handler.dart';
// import 'package:arpicoprivilege/data/repositories/settings_repository.dart';
// import 'package:arpicoprivilege/handler.dart';
// import 'package:arpicoprivilege/shared/pages/page_alert.dart';
// import 'package:arpicoprivilege/shared/customize/custom_loader.dart';
// import 'package:arpicoprivilege/shared/customize/custom_toast.dart';
// import 'package:flutter/material.dart';
//
// class HelpCenterViewmodel extends ChangeNotifier {
//   final formKey = GlobalKey<FormState>();
//
//   final List<String> textFields =["content", "contact", "name"];
//
//   // Dynamic FocusNodes for all TextFields, Dropdowns
//   late final Map<String, FocusNode> focusNodes;
//
//   // Dynamic TextEditingControllers for text input fields
//   late final Map<String, TextEditingController> controllers;
//
//   late final Map<String, String> initialValues;
//
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   HelpCenterViewmodel(){
//     // Initialize FocusNodes for TextFields
//     focusNodes = {for (var name in textFields) name: FocusNode()};
//
//     // Initialize Controllers for TextFields
//     controllers = {for (var name in textFields) name: TextEditingController()};
//
//     initialValues = {for (var name in textFields) name: ""};
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final loginUser = await decodeValidLoginUser();
//
//       initialValues["contact"] = loginUser.loginCustMobNo ?? "";
//       initialValues["name"] = loginUser.loginCustFullName ?? "";
//
//       controllers["contact"]?.text = initialValues["contact"] ?? "";
//       controllers["name"]?.text = initialValues["name"] ?? "";
//
//       notifyListeners();
//     });
//   }
//
//   Future<void> onSubmit() async {
//     final toast = CustomToast.of(context);
//     final loader = CustomLoader.of(context);
//     final navigator = Navigator.of(context);
//
//     try {
//       if (!formKey.currentState!.validate()) {
//         return;
//       }
//       else {
//         unFocusBackground(context);
//
//         await loader.show();
//
//         final accessToken = await getValidAccessToken();
//         final loginUser = await decodeValidLoginUser();
//
//         final resultFeedback = await SettingsRepository().setQuestion(
//             custId: loginUser.loginCustId!,
//             custName: controllers["name"]!.text,
//             custContact: controllers["contact"]!.text,
//             content: controllers["content"]!.text,
//             token: accessToken
//         );
//
//         await loader.close();
//         if (result is CallbackSuccess && mounted) {
//           await appAlerts.showAlertById(context, 'issueSubmitted',
//                   (key) => AppTranslator.of(context).call(key));
//           navigator.pop(true);
//         }
//         else {
//           toast.showPrimary(result.message);
//         }
//
//         toast.showPrimary(resultFeedback.message);
//
//         if(resultFeedback is CallbackSuccess && mounted){
//           PageAlert.replace(Key("issueSubmitted"), context, onConfirm: (){
//             navigator.pop();
//           });
//         }
//       }
//     } catch (e) {
//       await loader.close();
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   void unFocusBackground() {
//     for (var node in focusNodes.values) {
//       node.unfocus();
//     }
//     FocusScope.of(context).unfocus();
//   }
// }