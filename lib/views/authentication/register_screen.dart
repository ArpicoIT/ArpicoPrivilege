import 'package:arpicoprivilege/shared/components/form/text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/validates.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/buttons/primary_button.dart';
import '../../shared/components/buttons/linked_text_button.dart';
import '../../shared/components/form/phone_form_field.dart';
import '../../shared/components/form/phone_form_field2.dart';
import '../../shared/components/form/text_form_field.dart';
import '../../shared/widgets/terms_and_privacy_checkbox.dart';
import '../../viewmodels/authentication_viewmodel.dart';

/// v1.3
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterViewmodel viewmodel;

  @override
  void initState() {
    viewmodel = RegisterViewmodel()..setContext(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return ChangeNotifierProvider(
      create: (context) => RegisterViewmodel()..setContext(context),
      builder: (context, child){
        viewmodel = Provider.of<RegisterViewmodel>(context);

        return Scaffold(
          appBar: AppBar(
            actions: [
              ActionIconButton.of(context).contactSupport(),
            ],
          ),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: viewmodel.unFocusBackground,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                constraints: BoxConstraints(
                  minHeight: size.height-topPadding-kToolbarHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Create Account", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Text("Create your account to start your rewards journey with us"),
                        const SizedBox(height: 36),
                        Form(
                          key: viewmodel.formKey,
                          child: Column(
                            children: [
                              TextFormFieldNew(
                                fKey: viewmodel.fNameInputKey,
                                controller: viewmodel.fNameCtrl,
                                focusNode: viewmodel.fNameFocus,
                                title: "First Name",
                                hintText: "Enter first name",
                                textInputAction: TextInputAction.next,
                                clearButtonVisibility: true,
                                validator: (v) => Validates.byInputType(v, TextInputType.name),
                                onEditingComplete: () => viewmodel.lNameFocus.requestFocus(),
                              ),
                              const SizedBox(height: 24),
                              TextFormFieldNew(
                                fKey: viewmodel.lNameInputKey,
                                controller: viewmodel.lNameCtrl,
                                focusNode: viewmodel.lNameFocus,
                                title: "Last Name",
                                // titleHint: " (Optional)",
                                hintText: "Enter last name",
                                textInputAction: TextInputAction.next,
                                clearButtonVisibility: true,
                                validator: (v) => Validates.byInputType(v, TextInputType.name),
                                onEditingComplete: () => viewmodel.nicOrCardFocus.requestFocus(),
                              ),
                              const SizedBox(height: 24),
                              TextFormFieldNew(
                                fKey: viewmodel.nicOrCardInputKey,
                                controller: viewmodel.nicOrCardCtrl,
                                focusNode: viewmodel.nicOrCardFocus,
                                title: "Nic / loyalty card number",
                                // hintText: "eg: 199512345V / 199512345678",
                                hintText: "Enter nic or loyalty card number",
                                textInputAction: TextInputAction.next,
                                clearButtonVisibility: true,
                                validator: (v) => Validates.nicOrLoyaltyCard(v),
                                onEditingComplete: () => viewmodel.phoneFocus.requestFocus(),
                              ),
                              const SizedBox(height: 24),
                              PhoneFormFieldNew(
                                fKey: viewmodel.phoneInputKey,
                                controller: viewmodel.phoneCtrl,
                                focusNode: viewmodel.phoneFocus,
                                title: "Mobile number",
                                // hintText: "eg: 712345678",
                                hintText: "Enter mobile number",
                                textInputAction: TextInputAction.done,
                                clearButtonVisibility: true,
                                // autoValidateMode: AutovalidateMode.onUserInteraction,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        TermsAndPrivacyCheckbox(
                          onChanged: viewmodel.toggleTerms,
                          agreeToTerms: viewmodel.isTermsAccepted,
                        ),
                        const SizedBox(height: 32),
                        ValueListenableBuilder(
                            valueListenable: viewmodel.buttonNotifier,
                            builder: (context, value, child){
                              return PrimaryButton.filled(
                                text: "Continue",
                                onPressed: viewmodel.onRegisterContinue,
                                width: double.infinity,
                                enable: value,
                              );
                            }
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: LinkedTextButton(
                          text: "Already have an account?",
                          link: " Signin",
                          onTap: () => Navigator.of(context).pop()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// v1.2
/*class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterViewmodelNew viewmodel;

  @override
  void initState() {
    viewmodel = RegisterViewmodelNew()..setContext(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return ChangeNotifierProvider(
      create: (context) => RegisterViewmodelNew()..setContext(context),
      builder: (context, child){
        viewmodel = Provider.of<RegisterViewmodelNew>(context);

        return Scaffold(
          appBar: AppBar(
            actions: [
              ActionIconButton.contactSupport(context),
            ],
          ),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: viewmodel.unFocusBackground,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                constraints: BoxConstraints(
                  minHeight: size.height-topPadding-kToolbarHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Create Account", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Text("Create your account to start your rewards journey with us"),
                        const SizedBox(height: 36),
                        Form(
                          key: viewmodel.formKey,
                          child: Column(
                            children: [
                              TextFormFieldNew(
                                fKey: viewmodel.fNameKey,
                                controller: viewmodel.fNameCtrl,
                                focusNode: viewmodel.fNameFocus,
                                title: "First Name",
                                hintText: "Enter first name",
                                textInputAction: TextInputAction.next,
                                clearButtonVisibility: true,
                                validator: (v) => Validates.byInputType(v, TextInputType.name),
                              ),
                              const SizedBox(height: 24),
                              TextFormFieldNew(
                                fKey: viewmodel.lNameKey,
                                controller: viewmodel.lNameCtrl,
                                focusNode: viewmodel.lNameFocus,
                                title: "Last Name",
                                hintText: "Enter last name",
                                textInputAction: TextInputAction.next,
                                clearButtonVisibility: true,
                                validator: (v) => Validates.byInputType(v, TextInputType.name),
                              ),
                              const SizedBox(height: 24),
                              TextFormFieldNew(
                                fKey: viewmodel.nicKey,
                                controller: viewmodel.nicCtrl,
                                focusNode: viewmodel.nicFocus,
                                title: "NIC Number",
                                // hintText: "eg: 199512345V / 199512345678",
                                hintText: "Enter nic number",
                                textInputAction: TextInputAction.done,
                                clearButtonVisibility: true,
                                validator: (v) => Validates.nic(v),
                              ),
                              const SizedBox(height: 24),
                              PhoneFormFieldNew(
                                fKey: viewmodel.phoneKey,
                                controller: viewmodel.phoneCtrl,
                                focusNode: viewmodel.phoneFocus,
                                title: "Mobile Number",
                                // hintText: "eg: 712345678",
                                hintText: "Enter mobile number",
                                clearButtonVisibility: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        TermsAndPrivacyCheckbox(
                          onChanged: viewmodel.toggleTerms,
                          agreeToTerms: viewmodel.isTermsAccepted,
                        ),
                        const SizedBox(height: 32),
                        ValueListenableBuilder(
                            valueListenable: viewmodel.buttonNotifier,
                            builder: (context, value, child){
                              return PrimaryButton.filled(
                                text: "Continue",
                                onPressed: viewmodel.onRegisterContinue,
                                width: double.infinity,
                                enable: value,
                              );
                            }
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: LinkedTextButton(
                          text: "Already have an account?",
                          link: " Signin",
                          onTap: () => Navigator.of(context).pop()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}*/

/// v1.1
/*class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return ChangeNotifierProvider(
      create: (context) => RegisterViewmodel()..setContext(context),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            ActionIconButton.contactSupport(context),
          ],
        ),
        body: Consumer<RegisterViewmodel>(
            builder: (context, viewModel, child) {
              return SingleChildScrollView(
                child: GestureDetector(
                  onTap: () => viewModel.unFocusBackground(context),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    constraints: BoxConstraints(
                      minHeight: size.height-topPadding-kToolbarHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Create Account", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            Text("Create your account to start your rewards journey with us"),
                            const SizedBox(height: 36),
                            Form(
                              key: viewModel.formKey,
                              child: Column(
                                children: [
                                  NameInputField(
                                    controller: viewModel.fNameCtrl,
                                    focusNode: viewModel.fNameFocus,
                                    title: "First Name",
                                    hintText: "Your first name",
                                    textInputAction: TextInputAction.next,
                                    showClearButton: true,
                                  ),
                                  const SizedBox(height: 16),
                                  NameInputField(
                                    controller: viewModel.lNameCtrl,
                                    focusNode: viewModel.lNameFocus,
                                    title: "Last Name",
                                    titleHint: " (Optional)",
                                    hintText: "Your last name",
                                    textInputAction: TextInputAction.next,
                                    // validationRequired: false,
                                    showClearButton: true,
                                  ),
                                  const SizedBox(height: 16),
                                  PhoneFormFieldView(
                                    formKey: viewModel.phoneKey,
                                    controller: viewModel.phoneCtrl,
                                    focusNode: viewModel.phoneFocus,
                                    title: "Mobile Number",
                                    hintText: "Your mobile number",
                                    // enabled: false,
                                    decoration: InputDecoration(
                                      suffixIcon: FormWidgets.verificationIndicatorBuilder(
                                          context,
                                          stateListener: viewModel.phoneStatusNotifier,
                                          hintText: "mobile number",
                                          onPressed: () {
                                            viewModel.phoneFocus.hasFocus ? viewModel.phoneFocus.unfocus() : viewModel.verifyPhone(context);
                                          }
                                      ),
                                    ),
                                    showClearButton: true,
                                  ),
                                  const SizedBox(height: 16),
                                  NicInputField(
                                    fKey: viewModel.nicKey,
                                    controller: viewModel.nicCtrl,
                                    focusNode: viewModel.nicFocus,
                                    title: "NIC Number",
                                    enabled: false,
                                    // readOnly: true,
                                    decoration: InputDecoration(
                                      suffixIcon: FormWidgets.verificationIndicatorBuilder(
                                        context,
                                        stateListener: viewModel.nicStatusNotifier,
                                        hintText: "NIC number",
                                        onPressed: () {
                                          viewModel.nicFocus.hasFocus ? viewModel.nicFocus.unfocus() : viewModel.verifyNic(context);
                                        },
                                      ),
                                      counterText: '',
                                    ),
                                    showClearButton: true,
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                      alignment: Alignment.centerLeft ,
                                    child: RichText(
                                        text: TextSpan(
                                          style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                          text: "You must verify your ",
                                          children: [
                                            TextSpan(text: "mobile number", style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                            TextSpan(text: " before entering your NIC."),
                                          ]
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            TermsAndPrivacyCheckbox(
                              onChanged: viewModel.toggleTerms,
                              agreeToTerms: viewModel.isTermsAccepted,
                            ),
                            const SizedBox(height: 32),
                            ValueListenableBuilder(
                                valueListenable: viewModel.buttonNotifier,
                                builder: (context, value, child){
                                  return PrimaryButton.filled(
                                    text: "Continue",
                                    onPressed: () => viewModel.onRegisterContinue(context),
                                    width: double.infinity,
                                    enable: value,
                                  );
                                }
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: LinkedTextButton(
                                text: "Already have an account?",
                                link: " Signin",
                                onTap: () => Navigator.of(context).pop()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}*/

/// v 1.0
/*class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // late CallbackHandler callback;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildVerifiedSuffix({
    required ValueNotifier<VerificationStatus> stateListener,
    required String hintText,
    required VoidCallback onPressed,
  }) {
    return ValueListenableBuilder(
      valueListenable: stateListener,
      builder: (context, state, _) {
        final colorScheme = Theme.of(context).colorScheme;
        Widget icon;
        String message;

        switch (state) {
          case VerificationStatus.verified:
            icon = const Icon(Icons.verified_rounded,
                color: Colors.green, size: 24);
            message = 'Your $hintText is confirmed';
            break;
          case VerificationStatus.unverified:
            icon = Icon(Icons.block, color: colorScheme.error, size: 24);
            message = 'Your $hintText must be verified first.';
            break;
          case VerificationStatus.unknown:
            icon = Text('Verify',
                style: TextStyle(color: colorScheme.onPrimaryContainer));
            message = 'Please verify your $hintText to proceed.';
            break;
          case VerificationStatus.waiting:
            // TODO: Handle this case.
            throw UnimplementedError();
        }

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            tooltip: message,
            onPressed: onPressed,
            icon: icon,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defSize = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return ChangeNotifierProvider(
      create: (context) => RegisterViewmodel(),
      builder: (context, child) {
        final registerVM = Provider.of<RegisterViewmodel>(context);

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => registerVM.unFocusBackground(context),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: max(kMinScreenSize.height,
                      defSize.height - topPadding - kToolbarHeight),
                ),
                color: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AspectRatio(
                      aspectRatio: 2.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Create Account",
                              style: Theme.of(context).textTheme.headlineLarge),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 4),
                            child: Text(
                              "Create your account to start your rewards journey with us",
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: registerVM.formKey,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: NameInputField(
                                  focusNode: registerVM.fstNameInpFocus,
                                  title: "First Name",
                                  hintText: "Your first name",
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) =>
                                      registerVM.firstName = value,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: NameInputField(
                                  focusNode: registerVM.lstNameInpFocus,
                                  title: "Last Name",
                                  hintText: "Your last name",
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) =>
                                      registerVM.lastName = value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          NicInputField(
                            fKey: registerVM.nicKey,
                            focusNode: registerVM.nicNumInpFocus,
                            title: "NIC Number",
                            onChanged: (value) => registerVM.nic = value,
                            onFocus: (focus) =>
                                registerVM.onVerifyNic(context, focus),
                            decoration: InputDecoration(
                              suffixIcon: buildVerifiedSuffix(
                                stateListener: registerVM.nicVerificationStatus,
                                hintText: 'NIC number',
                                onPressed: () => registerVM
                                        .nicNumInpFocus.hasFocus
                                    ? registerVM.nicNumInpFocus.unfocus()
                                    : registerVM.onVerifyNic(context, false),
                              ),
                              counterText: '',
                            ),
                          ),
                          const SizedBox(height: 24),
                          PhoneInputField(
                            fKey: registerVM.mobileKey,
                            focusNode: registerVM.mobNumInpFocus,
                            title: "Mobile Number",
                            hintText: "Your mobile number",
                            onChanged: (value) => registerVM.mobile = value,
                            onFocus: (focus) =>
                                registerVM.onVerifyMobile(context, focus),
                            decoration: InputDecoration(
                              suffixIcon: buildVerifiedSuffix(
                                stateListener:
                                    registerVM.mobileVerificationStatus,
                                hintText: 'mobile number',
                                onPressed: () => registerVM
                                        .mobNumInpFocus.hasFocus
                                    ? registerVM.mobNumInpFocus.unfocus()
                                    : registerVM.onVerifyMobile(context, false),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 400),
                            transitionBuilder: (widget, animation) =>
                                FadeTransition(
                              opacity: animation,
                              child: widget,
                            ),
                            child: (!registerVM.isEBillRegistered)
                                ? SwitchListTile.adaptive(
                                    value: registerVM.enableEBillRegistration,
                                    onChanged: (value) =>
                                        registerVM.enableEBillRegistration = value,
                                    title: const Text('Register Arpico E-Bill'),
                                    subtitle: const Text(
                                        'Receive all bills on your mobile phone'),
                                    contentPadding: EdgeInsets.zero,
                                  )
                                : const SizedBox(),
                          )

                          // IconButton(
                          //     onPressed: () => registerVM.isEBillRegistered =
                          //     !registerVM.isEBillRegistered,
                          //     icon: Icon(Icons.add)),

                          // ValueListenableBuilder(
                          //   valueListenable:
                          //       registerVM.enableEBillServiceNotifier,
                          //   builder: (context, value, child) {
                          //     return SwitchListTile.adaptive(
                          //       value: value,
                          //       enableFeedback: false,
                          //       onChanged: null,
                          //       // onChanged: (newValue) => registerVM
                          //       //     .enableEBillServiceNotifier
                          //       //     .value = newValue,
                          //       title: const Text('Enable eBill Service'),
                          //       subtitle: const Text(
                          //           'Receive all bills on your mobile phone'),
                          //       contentPadding: EdgeInsets.zero,
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: PrimaryButton.filled(
                            enable: registerVM.enableRegisterBtn,
                            text: "Continue",
                            onPressed: () =>
                                registerVM.onRegisterContinue(context),
                            width: double.infinity,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Divider(),
                            Container(
                              padding: EdgeInsets.all(4),
                              color: Theme.of(context).colorScheme.surface,
                              child: Text("OR"),
                            ),
                          ],
                        ),
                        LinkedTextButton(
                            text: "Already have an account?",
                            link: " Signin",
                            onTap: () => Navigator.of(context).pop())
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}*/

