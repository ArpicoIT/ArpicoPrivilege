import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localized_alerts/localized_alerts.dart' as appAlerts;

import '../../core/handlers/callback_handler.dart';
import '../../data/repositories/settings_repository.dart';
import '../../handler.dart';
import '../../l10n/app_translator.dart';
import '../../shared/components/buttons/primary_button.dart';
import '../../shared/components/form/form_widgets.dart';
import '../../shared/customize/custom_loader.dart';
import '../../shared/customize/custom_toast.dart';
import '../../viewmodels/settings/helpcenter_viewmodel.dart';

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {

  final formKey = GlobalKey<FormState>();

  final List<String> textFields =["content", "contact", "name"];

  // Dynamic FocusNodes for all TextFields, Dropdowns
  late final Map<String, FocusNode> focusNodes;

  // Dynamic TextEditingControllers for text input fields
  late final Map<String, TextEditingController> controllers;

  late final Map<String, String> initialValues;

  @override
  void initState() {
    // Initialize FocusNodes for TextFields
    focusNodes = {for (var name in textFields) name: FocusNode()};

    // Initialize Controllers for TextFields
    controllers = {for (var name in textFields) name: TextEditingController()};

    initialValues = {for (var name in textFields) name: ""};

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginUser = await decodeValidLoginUser();

      initialValues["contact"] = loginUser.loginCustMobNo ?? "";
      initialValues["name"] = loginUser.loginCustFullName ?? "";

      controllers["contact"]?.text = initialValues["contact"] ?? "";
      controllers["name"]?.text = initialValues["name"] ?? "";

      setState(() {});
    });
    super.initState();
  }

  // Validation function for contact
  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your contact number or email';
    }

    // Mobile number validation (example: 10-15 digits, optional '+')
    String mobilePattern = r'^\+?\d{10,15}$';
    // Email validation pattern
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

    RegExp mobileRegExp = RegExp(mobilePattern);
    RegExp emailRegExp = RegExp(emailPattern);

    if (!mobileRegExp.hasMatch(value) && !emailRegExp.hasMatch(value)) {
      return 'Please enter a valid mobile number or email address';
    }
    return null;
  }

  // Validation function for issue description
  String? _validateIssue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please describe the issue';
    }

    if (value.trim().isEmpty) {
      return 'Issue description cannot be just spaces';
    }

    if (value.length < 10) {
      return 'Issue description should be at least 10 characters long';
    }

    if (value.length > 500) {
      return 'Issue description should not exceed 500 characters';
    }

    // Additional checks for content can be added here (e.g., for specific keywords or pattern matching)
    return null;
  }

  // Validation function for name
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }

    // Regular expression to validate name (only letters and spaces)
    String namePattern = r'^[A-Za-z\s]+$';
    RegExp regExp = RegExp(namePattern);

    if (!regExp.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

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
      final loginUser = await decodeValidLoginUser();

      final result = await SettingsRepository().setQuestion(
          custId: loginUser.loginCustId!,
          custName: (controllers["name"] as TextEditingController).text,
          custContact: (controllers["contact"] as TextEditingController).text,
          content: (controllers["content"] as TextEditingController).text,
          token: accessToken
      );

      await loader.close();

      if (result is CallbackSuccess && mounted) {
        await appAlerts.showAlertById(context, 'issueSubmitted',
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

    final disableStyle = TextStyle(color: Colors.grey);

    return Scaffold(
      appBar: AppBar(
        title: Text("Help Center"),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: unFocusBackground,
          child: Container(
            color: Colors.transparent,
            constraints: BoxConstraints(
                minHeight: mediaQuery.size.height - mediaQuery.viewPadding.top - mediaQuery.viewPadding.bottom - kToolbarHeight
            ),
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
                      Text("How can we help you today?",
                          style: textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),

                      const SizedBox(height: 12),
                      Text("Describe your issue or question, and add any relevant details."),
                      const SizedBox(height: 36),
                      FormWidgets.titleBuilder(context, title: "Issue or Question"),
                      TextFormField(
                        controller: controllers["content"],
                        focusNode: focusNodes["content"],
                        decoration: InputDecoration(
                          hintText: "Your issue or question",
                        ),
                        minLines: 10,
                        maxLines: 10,
                        validator: _validateIssue,
                      ),
                      const SizedBox(height: 24),
                      FormWidgets.titleBuilder(context, title: "Contact"),
                      TextFormField(
                        controller: controllers["contact"],
                        focusNode: focusNodes["contact"],
                        readOnly: initialValues["contact"] != "",
                        style: initialValues["contact"] != "" ? disableStyle : null,
                        decoration: InputDecoration(
                          hintText: "Your mobile or email",
                        ),
                        validator: _validateContact,
                      ),
                      const SizedBox(height: 24),
                      FormWidgets.titleBuilder(context, title: "Name"),
                      TextFormField(
                        controller: controllers["name"],
                        focusNode: focusNodes["name"],
                        readOnly: initialValues["name"] != "",
                        style: initialValues["name"] != "" ? disableStyle : null,
                        decoration: InputDecoration(
                          hintText: "Your name",
                        ),
                        validator: _validateName,
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