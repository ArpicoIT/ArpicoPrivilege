import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localized_alerts/localized_alerts.dart' as appAlerts;

import '../../core/handlers/callback_handler.dart';
import '../../data/repositories/settings_repository.dart';
import '../../handler.dart';
import '../../l10n/app_translator.dart';
import '../../shared/components/buttons/primary_button.dart';
import '../../shared/customize/custom_loader.dart';
import '../../shared/customize/custom_toast.dart';
import '../../viewmodels/settings/feedback_viewmodel.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final formKey = GlobalKey<FormState>();

  final List<String> textFields = ["content"];

  // Dynamic FocusNodes for all TextFields, Dropdowns
  late final Map<String, FocusNode> focusNodes;

  // Dynamic TextEditingControllers for text input fields
  late final Map<String, TextEditingController> controllers;

  @override
  void initState() {
    // Initialize FocusNodes for TextFields
    focusNodes = {for (var key in textFields) key: FocusNode()};

    // Initialize Controllers for TextFields
    controllers = {for (var key in textFields) key: TextEditingController()};
    super.initState();
  }

  // Validation function for issue description
  String? _validateFeedback(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the feedback';
    }

    if (value.trim().isEmpty) {
      return 'Feedback cannot be just spaces';
    }

    if (value.length < 10) {
      return 'Feedback should be at least 10 characters long';
    }

    if (value.length > 500) {
      return 'Feedback should not exceed 500 characters';
    }

    // Additional checks for content can be added here (e.g., for specific keywords or pattern matching)
    return null;
  }

  Future<void> onSubmit() async {
    final toast = CustomToast.of(context);
    final loader = CustomLoader.of(context);
    final navigator = Navigator.of(context);

    unFocusBackground();

    if (formKey.currentState?.validate() != true) {
      return;
    }

    await loader.show();

    try {
      final accessToken = await getValidAccessToken();

      final result = await SettingsRepository().setFeedback(
          feedback: (controllers["content"] as TextEditingController).text,
          token: accessToken);

      await loader.close();

      if (result is CallbackSuccess && mounted) {
          await appAlerts.showAlertById(context, 'feedbackSubmitted',
                  (key) => AppTranslator.of(context).call(key));
          navigator.pop(true);
      }
      else {
        toast.showPrimary(result.message);
      }
    } catch (e) {
      await loader.close();
      toast.showPrimary(e.toString());
    }
  }

  void unFocusBackground() {
    for (var node in focusNodes.values) {
      node.unfocus();
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: unFocusBackground,
          child: Container(
            color: Colors.transparent,
            constraints: BoxConstraints(
                minHeight: mediaQuery.size.height -
                    mediaQuery.viewPadding.top -
                    mediaQuery.viewPadding.bottom -
                    kToolbarHeight),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("We Value Your Feedback",
                          style: textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),

                      const SizedBox(height: 12),
                      Text(
                          "Your feedback helps us improve! Share your experience to help us get better."),
                      const SizedBox(height: 36),
                      // FormWidgets.titleBuilder(context, title: "Feedback"),
                      TextFormField(
                        controller: controllers["content"],
                        focusNode: focusNodes["content"],
                        decoration: InputDecoration(
                          hintText: "Your experience or suggestions",
                        ),
                        minLines: 10,
                        maxLines: 10,
                        validator: _validateFeedback,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                PrimaryButton.filled(
                  text: "Submit",
                  onPressed: onSubmit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class FeedbackView extends StatefulWidget {
//   const FeedbackView({super.key});
//
//   @override
//   State<FeedbackView> createState() => _FeedbackViewState();
// }
//
// class _FeedbackViewState extends State<FeedbackView> {
//   final feedbackInputCtrl = TextEditingController();
//   final feedbackInputFocus = FocusNode();
//
//   UserNew user = UserNew();
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       try {
//         user = await getUserFromStorage();
//         if (context.mounted) {
//           setState(() {});
//         }
//       } catch (e) {
//         debugPrint(e.toString());
//       }
//     });
//   }
//
//   AppBar get appBar => AppBar(
//         title: Text("Feedback"),
//       );
//
//   String getGreeting() {
//     final hour = DateTime.now().hour;
//     final userName = (user.custFullName ?? "--").toUpperCaseFirst();
//
//     if (hour < 12) {
//       return "Good morning, $userName! ☀️";
//     } else if (hour < 18) {
//       return "Good afternoon, $userName! 🌤️";
//     } else {
//       return "Good evening, $userName! 🌙";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final mediaQuery = MediaQuery.of(context);
//
//     return Scaffold(
//       appBar: appBar,
//       resizeToAvoidBottomInset: false,
//       body: SingleChildScrollView(
//         child: GestureDetector(
//           onTap: () => unFocusBackground(context),
//           child: Container(
//             color: Colors.transparent,
//             constraints: BoxConstraints(
//                 minHeight: mediaQuery.size.height -
//                     mediaQuery.viewPadding.top -
//                     mediaQuery.viewPadding.bottom -
//                     kToolbarHeight),
//             padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   getGreeting(),
//                   style: textTheme.titleLarge
//                       ?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 24),
//                 TextField(
//                   controller: feedbackInputCtrl,
//                   focusNode: feedbackInputFocus,
//                   decoration: InputDecoration(
//                     hintText: "Write your experience or suggestions..",
//                   ),
//                   minLines: 10,
//                   maxLines: 10,
//                 ),
//                 SizedBox(height: 24),
//                 PrimaryButton.filled(
//                     text: "Share Your Feedback",
//                     onPressed: () {
//                       unFocusBackground(context);
//                       SettingsViewmodel().submitYourFeedback(context, feedbackInputCtrl.text);
//                     }
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void unFocusBackground(BuildContext context) {
//     feedbackInputFocus.unfocus();
//     FocusScope.of(context).unfocus();
//   }
// }
