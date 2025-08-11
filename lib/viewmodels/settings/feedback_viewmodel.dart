import 'package:arpicoprivilege/core/handlers/callback_handler.dart';
import 'package:arpicoprivilege/data/repositories/settings_repository.dart';
import 'package:arpicoprivilege/handler.dart';
import 'package:arpicoprivilege/shared/pages/page_alert.dart';
import 'package:arpicoprivilege/shared/customize/custom_loader.dart';
import 'package:arpicoprivilege/shared/customize/custom_toast.dart';
import 'package:flutter/material.dart';

// class FeedbackViewmodel extends ChangeNotifier {
//   final formKey = GlobalKey<FormState>();
//
//   final List<String> textFields =["content"];
//
//   // Dynamic FocusNodes for all TextFields, Dropdowns
//   late final Map<String, FocusNode> focusNodes;
//
//   // Dynamic TextEditingControllers for text input fields
//   late final Map<String, TextEditingController> controllers;
//
//   FeedbackViewmodel(){
//     // Initialize FocusNodes for TextFields
//     focusNodes = {for (var name in textFields) name: FocusNode()};
//
//     // Initialize Controllers for TextFields
//     controllers = {for (var name in textFields) name: TextEditingController()};
//   }
//
//   Future<void> submitFeedback(BuildContext context) async {
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
//
//         final feedbackResult = await SettingsRepository().setFeedback(
//             feedback: controllers["content"]!.text, token: accessToken);
//
//
//         await loader.close();
//         toast.showPrimary(feedbackResult.message);
//
//         if(feedbackResult is CallbackSuccess && context.mounted){
//           PageAlert.replace(Key("feedbackSubmitted"), context, onConfirm: (){
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
//   void unFocusBackground(BuildContext context) {
//     for (var node in focusNodes.values) {
//       node.unfocus();
//     }
//     FocusScope.of(context).unfocus();
//   }
// }