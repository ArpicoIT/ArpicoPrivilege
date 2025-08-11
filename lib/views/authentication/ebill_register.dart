import 'package:arpicoprivilege/app/app.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:localized_alerts/localized_alerts.dart' as appAlerts;

import '../../app/app_routes.dart';
import '../../core/constants/app_consts.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/handlers/error_handler.dart';
import '../../core/utils/validates.dart';
import '../../data/mixin/authentication_mixin.dart';
import '../../data/repositories/ebill_repository.dart';
import '../../handler.dart';
import '../../l10n/app_translator.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/buttons/primary_button.dart';
import '../../shared/components/form/form_widgets.dart';
import '../../shared/components/form/phone_form_field2.dart';
import '../../shared/components/form/text_form_fields.dart';
import '../../shared/customize/custom_loader.dart';
import '../../shared/customize/custom_toast.dart';
import '../../shared/widgets/terms_and_privacy_checkbox.dart';
import 'security_authentication.dart';

class EBillRegisterView extends StatefulWidget {
  const EBillRegisterView({super.key});

  @override
  State<EBillRegisterView> createState() => _EBillRegisterViewState();
}

class _EBillRegisterViewState extends State<EBillRegisterView>
    with AuthenticationMixin {
  final phoneKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormFieldState>();

  final phoneCtrl =
      PhoneController(initialValue: PhoneNumber(isoCode: kIsoCode, nsn: ''));
  final emailCtrl = TextEditingController();

  final phoneFocus = FocusNode();
  final emailFocus = FocusNode();

  final phoneVerification = ValueNotifier(VerificationStatus.unknown);
  final emailVerification = ValueNotifier(VerificationStatus.unknown);

  bool isIntro = true;
  bool isTermsAccepted = false;
  bool isRegisterBtnEnabled = false;

  String initialPhoneNumber = "";
  String initialEmailAddress = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // initialPhoneNumber = "";
      // initialEmailAddress = "";

      final loginUser = await decodeValidLoginUser();
      initialPhoneNumber = _parsePhoneNumber(loginUser.loginCustMobNo ?? '').international;
      initialEmailAddress = loginUser.loginCustEmail ?? '';

      phoneCtrl.value = _parsePhoneNumber(initialPhoneNumber);
      emailCtrl.text = initialEmailAddress;

      phoneVerification.value = _parsePhoneNumber(initialPhoneNumber).isValid()
          ? VerificationStatus.verified
          : VerificationStatus.unknown;
      emailVerification.value = Validates.isValidEmail(initialEmailAddress)
          ? VerificationStatus.verified
          : VerificationStatus.unknown;

      _updateRegisterButtonState();

      phoneCtrl.addListener(() {
        phoneVerification.value =
            (initialPhoneNumber == phoneCtrl.value.international &&
                    phoneCtrl.value.isValid())
                ? VerificationStatus.verified
                : VerificationStatus.unknown;
        _updateRegisterButtonState();
      });

      emailCtrl.addListener(() {
        emailVerification.value = (initialEmailAddress == emailCtrl.text &&
                Validates.isValidEmail(emailCtrl.text))
            ? VerificationStatus.verified
            : VerificationStatus.unknown;
        _updateRegisterButtonState();
      });
    });

    super.initState();
  }

  PhoneNumber _parsePhoneNumber(String value) {
    try {
      return PhoneNumber.parse(value);
    } catch (e) {
      return PhoneNumber(isoCode: kIsoCode, nsn: '');
    }
  }

  void _updateRegisterButtonState() {
    // isContinueBtnEnabled =
    //     phoneVerification.value == VerificationStatus.verified && phoneCtrl.value.isValid() &&
    //         (emailCtrl.text.isEmpty
    //             ? true
    //             : Validates.isValidEmail(emailCtrl.text)
    //             ? emailVerification.value == VerificationStatus.verified
    //             : false) &&
    //         isTermsAccepted;

    if (mounted) {
      setState(() {
        isRegisterBtnEnabled = _validateInputs() && isTermsAccepted;
      });
    }
  }

  bool _validateInputs(
      {bool isAlert = false, bool triggerFieldValidation = false}) {
    final toast = CustomToast.of(context);

    if (triggerFieldValidation) {
      phoneKey.currentState?.validate();
      emailKey.currentState?.validate();
    }

    if (!phoneCtrl.value.isValid()) {
      isAlert ? toast.showPrimary("Please enter a valid phone number.") : null;
      return false;
    }

    if (phoneVerification.value != VerificationStatus.verified) {
      isAlert
          ? toast
              .showPrimary("Please verify your phone number before proceeding.")
          : null;
      return false;
    }

    final email = emailCtrl.text.trim();
    if (email.isNotEmpty) {
      if (!Validates.isValidEmail(email)) {
        isAlert
            ? toast.showPrimary("Please enter a valid email address.")
            : null;
        return false;
      }

      if (emailVerification.value != VerificationStatus.verified) {
        isAlert
            ? toast.showPrimary(
                "Please verify your email address before continuing.")
            : null;
        return false;
      }
    }

    return true;
  }

  void onToggleTerms(bool? value) {
    isTermsAccepted = value ?? false;
    _updateRegisterButtonState();
  }

  void onUnFocusBackground() {
    phoneFocus.unfocus();
    emailFocus.unfocus();
    FocusScope.of(context).unfocus();
  }

  Future<void> onVerifyPhone() async {
    final toast = CustomToast.of(context);
    final navigator = Navigator.of(context);
    final errorHandler = ErrorHandler.of(context);

    try {
      if (phoneVerification.value == VerificationStatus.verified) {
        return;
      } else if (!phoneCtrl.value.isValid()) {
        return;
      } else {
        final requested =
            await requestPhoneOtp(context, phoneCtrl.value.international);

        if (requested) {
          final controller = SecurityAuthController(
              address: phoneCtrl.value.international,
              onVerifyCode: (ctx, code) async => await verifyPhoneOtp(
                  ctx, phoneCtrl.value.international, code),
              onResendCode: (ctx, address) async =>
                  await requestPhoneOtp(ctx, phoneCtrl.value.international),
              whenComplete: (ctx, v) {
                if (v == true) {
                  Navigator.of(ctx).pop(v);
                }
              });

          final verifyResult = await navigator.pushNamed(
              AppRoutes.securityAuthentication,
              arguments: controller);

          phoneVerification.value = (verifyResult == true)
              ? VerificationStatus.verified
              : VerificationStatus.unverified;
          _updateRegisterButtonState();
        } else {
          return;
        }
      }
    } catch (e) {
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
    }
  }

  Future<void> onVerifyEmail() async {
    final toast = CustomToast.of(context);
    final navigator = Navigator.of(context);
    final errorHandler = ErrorHandler.of(context);

    try {
      if (emailVerification.value == VerificationStatus.verified) {
        return;
      } else if (!Validates.isValidEmail(emailCtrl.text)) {
        return;
      } else {
        final requested = await requestEmailOtp(context, emailCtrl.text);

        if (requested) {
          final controller = SecurityAuthController(
              address: emailCtrl.text,
              onVerifyCode: (ctx, code) async =>
                  await verifyEmailOtp(ctx, emailCtrl.text, code),
              onResendCode: (ctx, address) async =>
                  await requestEmailOtp(ctx, emailCtrl.text),
              whenComplete: (ctx, v) {
                if (v == true) {
                  Navigator.of(ctx).pop(v);
                }
              });

          final verifyResult = await navigator.pushNamed(
              AppRoutes.securityAuthentication,
              arguments: controller);

          emailVerification.value = (verifyResult == true)
              ? VerificationStatus.verified
              : VerificationStatus.unverified;
          _updateRegisterButtonState();
        } else {
          return;
        }
      }
    } catch (e) {
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
    }
  }

  Future<void> onRegister() async {
    final toast = CustomToast.of(context);
    final loader = CustomLoader.of(context);
    final errorHandler = ErrorHandler.of(context);

    try {
      if (!_validateInputs(isAlert: true, triggerFieldValidation: true)) {
        return;
      }

      await loader.show();

      final accessToken = await getValidAccessToken();
      final loginUser = await decodeValidLoginUser();
      final uuid = await getDeviceId();

      final result = await EBillRepository().eBillRegistration(
          loyaltyId: loginUser.loginCustId!,
          nic: loginUser.loginCustNic!,
          mobile: phoneCtrl.value.international,
          email: emailCtrl.text,
          name: loginUser.loginCustFullName!,
          uuid: uuid,
          token: accessToken);

      if (result is CallbackSuccess) {
        await refreshAndSaveAccessToken();
        await getAndCacheValidUser();
        await loader.close();

        if (mounted) {
          await appAlerts.showAlertById(context, 'eBillRegistered',
              (key) => AppTranslator.of(context).call(key));
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        }
        // toast.showPrimary(result.message);
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    if (isIntro) {
      return EBillRegisterIntroductionView(
          onDone: () => setState(() => isIntro = false));
    }

    return Scaffold(
      key: ValueKey('registration_form'),
      appBar: AppBar(
        actions: [
          ActionIconButton.of(context).contactSupport(),
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: onUnFocusBackground,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            constraints: BoxConstraints(
                minHeight: size.height - topPadding - kToolbarHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Quick & Easy eBill Registration!",
                    style: textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Text(
                    "Say goodbye to paper bills. Get your statements anytime, anywhere."),
                const SizedBox(height: 36),
                Column(
                  children: [
                    PhoneFormFieldNew(
                      fKey: phoneKey,
                      controller: phoneCtrl,
                      focusNode: phoneFocus,
                      title: "Mobile number",
                      hintText: "Enter mobile number",
                      textInputAction: TextInputAction.done,
                      clearButtonVisibility: !_parsePhoneNumber(initialPhoneNumber).isValid(),
                      enabled: !_parsePhoneNumber(initialPhoneNumber).isValid(),
                      decoration: InputDecoration(
                        suffixIcon: FormWidgets.verificationIndicatorBuilder(
                            context,
                            stateListener: phoneVerification,
                            hintText: 'mobile number', onPressed: () {
                          phoneFocus.hasFocus
                              ? phoneFocus.unfocus()
                              : onVerifyPhone();
                        }),
                      ),
                      // autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 24),
                    TextFormFieldNew(
                      fKey: emailKey,
                      controller: emailCtrl,
                      focusNode: emailFocus,
                      title: "Email Address",
                      titleHint: " (Optional)",
                      hintText: "Enter your email address",
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      clearButtonVisibility: true,
                      validator: (v) => Validates.byInputType(
                          v, TextInputType.emailAddress, false),
                      decoration: InputDecoration(
                          suffixIcon: FormWidgets.verificationIndicatorBuilder(
                              context,
                              stateListener: emailVerification,
                              hintText: 'email address', onPressed: () {
                            emailFocus.hasFocus
                                ? emailFocus.unfocus()
                                : onVerifyEmail();
                          }),
                          prefixIcon: Icon(Icons.email_outlined)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TermsAndPrivacyCheckbox(
                  onChanged: onToggleTerms,
                  agreeToTerms: isTermsAccepted,
                ),
                const SizedBox(height: 32),
                PrimaryButton.filled(
                  text: "Register",
                  onPressed: onRegister,
                  width: double.infinity,
                  // enable: isRegisterBtnEnabled,
                  enable: isTermsAccepted,
                  // enable: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EBillRegisterIntroductionView extends StatelessWidget {
  final Function() onDone;
  const EBillRegisterIntroductionView({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final kPageDecoration = PageDecoration(
      imageFlex: 5,
      bodyFlex: 2,
      footerFlex: 1,
      pageMargin: EdgeInsets.only(bottom: 16),
      bodyTextStyle: textTheme.bodyLarge!.copyWith(color: Colors.grey),
    );

    List<PageViewModel> listPagesViewModel = [
      // 1
      // Go Paperless, Stay Organized
      // Easily manage all your utility bills in one place
      // 2
      // Get Notified Before Due Dates
      // Never miss a payment again. Receive timely reminders and avoid late fees
      // 3
      // Track All Your Bills in One Tap
      // View payment history, download receipts, and monitor your spending with ease

      PageViewModel(
          title: "Smart Shopping, Smarter Billing",
          body:
              "Skip the paper. Get your Arpico shopping bills directly in the app",
          image: Image.asset('assets/eBills/onboard1.png'),
          footer: const SizedBox.shrink(),
          decoration: kPageDecoration),
      PageViewModel(
          title: "All Your Bills, One Place",
          body:
              "Track your Arpico purchase history and manage receipts anytime, anywhere",
          image: Image.asset('assets/eBills/onboard2.png'),
          footer: const SizedBox.shrink(),
          decoration: kPageDecoration),
      PageViewModel(
        title: "Stay Ahead with Smart Bill Reminders",
        body:
            "Get notified when your Arpico bills are ready. Pay on time, every time",
        footer: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextButton(
              onPressed: onDone,
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text("Get Started")),
        ),
        image: Image.asset('assets/eBills/onboard3.png'),
        decoration: kPageDecoration,
      ),
    ];

    return IntroductionScreen(
      pages: listPagesViewModel,
      showSkipButton: true,
      showBackButton: true,
      showDoneButton: true,
      skip: const Text("Skip"),
      back: const Text("Back"),
      next: const Text("Next"),
      done: const Text("Done"),
      dotsFlex: 2,
      onDone: onDone,
      baseBtnStyle: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          overlayColor: Colors.transparent),
      // backStyle: TextButton.styleFrom(foregroundColor: colorScheme.onSurface),
    );
  }
}

/// v1.0
/*class EBillRegisterView extends StatefulWidget {
  const EBillRegisterView({super.key});

  @override
  State<EBillRegisterView> createState() => _EBillRegisterViewState();
}

class _EBillRegisterViewState extends State<EBillRegisterView> {
  bool intro = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return EBillRegisterIntroductionView(
        onDone: () => setState(() => intro = false));

    return ChangeNotifierProvider(
      create: (context) => EBillRegisterViewmodel()..setContext(context),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            ActionIconButton.of(context).contactSupport(),
          ],
        ),
        body: Consumer<EBillRegisterViewmodel>(
          builder: (context, viewmodel, child) {
            return SingleChildScrollView(
              child: GestureDetector(
                onTap: () => viewmodel.unFocusBackground(context),
                child: Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  constraints: BoxConstraints(
                    minHeight: size.height - topPadding - kToolbarHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Quick & Easy eBill Registration!",
                              style: textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          Text(
                              "Say goodbye to paper bills. Get your statements anytime, anywhere."),
                          const SizedBox(height: 36),
                          Column(
                            children: [
                              PhoneFormFieldView(
                                formKey: viewmodel.phoneKey,
                                controller: viewmodel.phoneCtrl,
                                focusNode: viewmodel.phoneFocus,
                                title: "Mobile Number",
                                hintText: "Your mobile number",
                                decoration: InputDecoration(
                                  suffixIcon:
                                      FormWidgets.verificationIndicatorBuilder(
                                          context,
                                          stateListener:
                                              viewmodel.phoneStatusNotifier,
                                          hintText: 'mobile number',
                                          onPressed: () {
                                    viewmodel.phoneFocus.hasFocus
                                        ? viewmodel.phoneFocus.unfocus()
                                        : viewmodel.verifyPhone();
                                  }),
                                ),
                                showClearButton: true,
                              ),
                              const SizedBox(height: 16),
                              EmailInputField(
                                fKey: viewmodel.emailKey,
                                focusNode: viewmodel.emailFocus,
                                controller: viewmodel.emailCtrl,
                                title: "Email Address",
                                titleHint: " (Optional)",
                                hintText: "Enter your email address",
                                decoration: InputDecoration(
                                  suffixIcon:
                                      FormWidgets.verificationIndicatorBuilder(
                                          context,
                                          stateListener:
                                              viewmodel.emailStatusNotifier,
                                          hintText: 'email address',
                                          onPressed: () {
                                    viewmodel.emailFocus.hasFocus
                                        ? viewmodel.emailFocus.unfocus()
                                        : viewmodel.verifyEmail();
                                  }),
                                ),
                                validationRequired: false,
                                showClearButton: true,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TermsAndPrivacyCheckbox(
                            onChanged: viewmodel.toggleTerms,
                            agreeToTerms: viewmodel.isTermsAccepted,
                          ),
                          const SizedBox(height: 32),
                          ValueListenableBuilder(
                              valueListenable: viewmodel.buttonNotifier,
                              builder: (context, value, child) {
                                return PrimaryButton.filled(
                                  text: "Register",
                                  onPressed: () =>
                                      viewmodel.onRegisterContinue(),
                                  width: double.infinity,
                                  enable: value,
                                );
                              })
                        ],
                      ),
                      // Align(
                      //   alignment: Alignment.bottomRight,
                      //   child: TextButton.icon(
                      //     onPressed: () {},
                      //     icon: Icon(Icons.navigate_next),
                      //     label: Text("Skip"),
                      //     iconAlignment: IconAlignment.end,
                      //     style: TextButton.styleFrom(
                      //         foregroundColor: colorScheme.onSurface,
                      //         iconColor: colorScheme.onSurface),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}*/
