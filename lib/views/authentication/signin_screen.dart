import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:arpicoprivilege/shared/components/buttons/action_icon_button.dart';
import 'package:arpicoprivilege/shared/customize/custom_loader.dart';
import 'package:arpicoprivilege/views/authentication/security_authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validates.dart';
import '../../handler.dart';
import '../../shared/components/form/phone_form_field2.dart';
import '../../shared/components/form/text_form_fields.dart';
import '../../shared/widgets/terms_and_privacy_checkbox.dart';
import 'package:arpicoprivilege/app/app_routes.dart';
import 'package:arpicoprivilege/shared/components/buttons/primary_button.dart';
import 'package:arpicoprivilege/shared/components/buttons/linked_text_button.dart';
import 'package:arpicoprivilege/viewmodels/authentication_viewmodel.dart';
import 'package:arpicoprivilege/views/authentication/ebill_register.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  late SignInViewmodel viewmodel;

  @override
  void initState() {
    viewmodel = SignInViewmodel()..setContext(context);
    super.initState();
  }

  Widget testMenu(BuildContext context) => PopupMenuButton<String>(
    icon: Icon(Icons.more_vert), // Menu icon
    onSelected: (String value) async {
      // Handle selection
      if (value == "anonymous_login") {

        await saveAccessToken(TEST_TOKEN);
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
        debugPrint("Anonymous Login Selected");
      } else if (value == "signin_verification") {

        final controller = SecurityAuthController(
            address: "0710930444",
            onVerifyCode: (ctx, code) async {
              debugPrint("FA verifying: $code");
              final loader = CustomLoader.of(ctx);
              await loader.show();
              return await Future.delayed(const Duration(seconds: 2), () async {
                await loader.close();
                return true;
              });
            },
            onResendCode: (ctx, address) async {
              final loader = CustomLoader.of(ctx);
              await loader.show();
              return await Future.delayed(const Duration(seconds: 2), () async {
                await loader.close();
                return true;
              });
            },
            whenComplete: (ctx, v){
              Navigator.of(ctx).pop("Verified");
            }
        );

        final result = await Navigator.of(context).pushNamed(AppRoutes.securityAuthentication, arguments: controller);
        debugPrint(result.toString());

      } else if (value == "ebill_registration") {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EBillRegisterView()));
        debugPrint("eBill Registration Selected");
      }
    },
    itemBuilder: (BuildContext context) => [
      PopupMenuItem(
        value: "anonymous_login",
        child: Text("Anonymous Login"),
      ),
      PopupMenuItem(
        value: "signin_verification",
        child: Text("Sign-in Verification"),
      ),
      PopupMenuItem(
        value: "ebill_registration",
        child: Text("E-Bill Registration"),
      ),
    ],
  );

  List<Map<String, dynamic>> get getTabData => [
    {
      "subHeading": "Sign in to continue with Your mobile number",
      "tabTitle": "Phone",
      "inputWidget": PhoneFormFieldNew(
        fKey: viewmodel.phoneInputKey,
        controller: viewmodel.phoneCtrl,
        focusNode: viewmodel.phoneFocus,
        // hintText: "eg: 712345678",
        hintText: "Enter mobile number",
        clearButtonVisibility: true,
      ),
    },
    {
      "subHeading": "Sign in to continue with Your nic or loyalty card number",
      "tabTitle": "Nic / Loyalty Card",
      "inputWidget": TextFormFieldNew(
        fKey: viewmodel.nicOrCardInputKey,
        controller: viewmodel.nicOrCardCtrl,
        focusNode: viewmodel.nicOrCardFocus,
        hintText: "Enter nic or loyalty card number",
        textInputAction: TextInputAction.done,
        clearButtonVisibility: true,
        validator: (v) => Validates.nicOrLoyaltyCard(v),
      )
    }
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return ChangeNotifierProvider(
      create: (context) => SignInViewmodel()..setContext(context),
      builder: (context, child){
        viewmodel = Provider.of<SignInViewmodel>(context);

        return Scaffold(
          appBar: AppBar(
            actions: [
              ActionIconButton.of(context).contactSupport(),
              testMenu(context), // testing ************************************************************
            ],
          ),
          body: SingleChildScrollView(
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
                        Text("Welcome Back,",
                            style: textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),

                        const SizedBox(height: 12),
                        Text(getTabData[viewmodel.selectedTabIndex]["subHeading"]),
                        const SizedBox(height: 36),
                        DefaultTabController(
                          length: 2,
                          child: ButtonsTabBar(
                            backgroundColor: Colors.transparent,
                            unselectedBackgroundColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            buttonMargin: EdgeInsets.only(right: 36),
                            labelStyle: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            unselectedLabelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            tabs: getTabData.map((e) => Tab(text: e["tabTitle"])).toList(),
                            onTap: viewmodel.onTabChanged,
                          ),
                        ),

                        const SizedBox(height: 16),
                        getTabData[viewmodel.selectedTabIndex]["inputWidget"],
                        const SizedBox(height: 32),
                        TermsAndPrivacyCheckbox(
                          onChanged: viewmodel.toggleTerms,
                          agreeToTerms: viewmodel.isTermsAccepted,
                        ),
                        const SizedBox(height: 32),
                        ValueListenableBuilder(
                            valueListenable: viewmodel.buttonNotifier,
                            builder: (context, value, child) {
                              return PrimaryButton.filled(
                                text: "Continue",
                                onPressed: viewmodel.onLoginContinue,
                                width: double.infinity,
                                enable: value,
                              );
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: LinkedTextButton(
                          text: "Don't have an account?",
                          link: " Register",
                          onTap: () => Navigator.of(context)
                              .pushNamed(AppRoutes.register)),
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
}

/*class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defSize = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return ChangeNotifierProvider(
      create: (context) => SignInViewmodel(),
      builder: (context, child){
        final signInVM = Provider.of<SignInViewmodel>(context);

        return Scaffold(
          extendBodyBehindAppBar: false,
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => signInVM.unFocusBackground(context),
              child: Container(
                // constraints: BoxConstraints(
                //   minHeight: max(kMinScreenSize.height, defSize.height-topPadding-kToolbarHeight),
                // ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  color: Colors.red.shade50,
                  child: Wrap(
                    runSpacing: 12,
                    runAlignment: WrapAlignment.spaceBetween,
                    children: [
                      Container(
                        // color: Colors.blue.withAlpha(50),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 192,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                      "assets/icons/loyalty-star2.png"),
                                ),
                              ),
                              AppName(appNameSize: 35),
                              const SizedBox(height: 4),
                              Text(
                                // "Sign in to manage your loyalty perks and\ntrack rewards."
                                  "Sign in to continue with Your mobile number",
                                  style: TextStyle(
                                      color: colorScheme
                                          .onSurfaceVariant),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: signInVM.formKey,
                        child: Column(
                          children: [
                            PhoneInputField(
                              focusNode: signInVM.mobNumInpFocus,
                              hintText: "Your mobile number",
                              onChanged: (value) => signInVM.mobile = value,
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              child: PrimaryButton.filled(
                                text: "Continue",
                                onPressed: () => signInVM.onSignInContinue(context),
                                width: double.infinity,
                                enable: signInVM.enableSignInBtn,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        // color: Colors.blue.withAlpha(50),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Stack(
                            //   alignment: Alignment.center,
                            //   children: [
                            //     Divider(),
                            //     Container(
                            //       padding: EdgeInsets.all(4),
                            //       color: Theme
                            //           .of(context)
                            //           .colorScheme
                            //           .surface,
                            //       // color: Colors.green,
                            //       child: Text("OR"),
                            //     ),
                            //   ],
                            // ),
                            LinkedTextButton(
                                text: "Don't have an account?",
                                link: " Register",
                                onTap: () =>
                                    Navigator.of(context)
                                        .pushNamed(
                                        AppRoutes.register)),
                          ],
                        ),
                      ),

                      // Container(
                      //   // color: Colors.blue.withOpacity(0.3),
                      //   alignment: Alignment.bottomCenter,
                      //   child: Wrap(
                      //     runSpacing: 24,
                      //     alignment: WrapAlignment.center,
                      //     children: [
                      //       // TextInputField(
                      //       //   controller: TextEditingController(),
                      //       //   focusNode: _focusNode1,
                      //       //   title: 'Mobile number ',
                      //       //   titleHint: '(Optional)',
                      //       //   whenFocusLost: (focus){
                      //       //     debugPrint("Focus Lost: $focus");
                      //       //   },
                      //       // ),
                      //
                      //       PhoneInputField(
                      //           hintText: "Your mobile number",
                      //           onChanged: (value) =>
                      //           authVM.mobile = value),
                      //
                      //       PrimaryButton.filled(
                      //         text: "Continue",
                      //         // onPressed: () => viewmodel.onSignin(context),
                      //         onPressed: () {
                      //           showLoader(context);
                      //         },
                      //         width: double.infinity,
                      //       ),
                      //       Container(
                      //           width: double.infinity,
                      //           padding: const EdgeInsets.symmetric(
                      //               vertical: 8),
                      //           alignment: Alignment.center,
                      //           child: const Row(
                      //             children: [
                      //               Flexible(child: Divider()),
                      //               Padding(
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal: 8),
                      //                 child: Text("OR"),
                      //               ),
                      //               Flexible(child: Divider()),
                      //             ],
                      //           )),
                      //       LinkedTextButton(
                      //           text: "Don't have an account?",
                      //           link: " Register",
                      //           onTap: () => Navigator.of(context)
                      //               .pushNamed(AppRoutes.register)),
                      //
                      //
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}*/

/*class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background clippers
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                height: 300,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                height: 200,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "HELLO SIGN IN",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email TextField
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Joydeo@gmail.com",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password TextField
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                      suffixIcon: const Icon(Icons.visibility_off, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account? ",
                          style: TextStyle(color: Colors.black54)),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Sign up",
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/

// if you need to paint scaffold use,
// LayoutBuilder(
//       builder: (context, constraints) {
//         return CustomPaint(
//           size: Size(constraints.maxWidth, constraints.maxHeight),
//           painter: PolygonPainter(
//             fillColor: colorScheme.surface,
//             topMargin: 200
//           ),
//           child: "your content"
//          )
//        }
// )
