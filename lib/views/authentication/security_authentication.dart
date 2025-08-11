import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/buttons/linked_text_button.dart';
import '../../shared/components/buttons/primary_button.dart';

class SecurityAuthController {
  final String address;
  final FutureOr<Object?> Function(BuildContext context, String code)? onVerifyCode;
  final FutureOr<Object?> Function(BuildContext context, String address)? onResendCode;
  final Function(BuildContext context, Object? value)? whenComplete;
  final Function(BuildContext context)? contactSupport;

  const SecurityAuthController({
    required this.address,
    this.onVerifyCode,
    this.onResendCode,
    this.contactSupport,
    this.whenComplete,
  });
}

class SecurityAuthenticationView extends StatefulWidget {
  final SecurityAuthController? controller;
  const SecurityAuthenticationView({
    super.key,
    this.controller
  });

  @override
  State<SecurityAuthenticationView> createState() => _SecurityAuthenticationViewState();
}

class _SecurityAuthenticationViewState<T> extends State<SecurityAuthenticationView> with CodeAutoFill {
  SecurityAuthController _authController = SecurityAuthController(address: '');
  final CountdownTimerController _countdownController = CountdownTimerController();

  late FocusNode otpFocus  = FocusNode();

  bool enableVerifyCodeBtn = false;
  int maxDigits = 6;
  bool isMasked = true;
  String _address = '';
  String? _otpCode;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      final args = ModalRoute.of(context)?.settings.arguments;

      if(args is SecurityAuthController){
        _authController = args;
      }
      else if (widget.controller != null){
        _authController = widget.controller!;
      }
      else {
        throw FlutterError('SecurityAuthentication requires a SecurityAuthController<T>');
      }

      if(mounted) {
        setState(() {
          _address = _processAddress(_authController.address, isMasked);
        });
      }

      _countdownController.start();
    });

    listenForCode();

    /// get app signature for otp autofill
    /// Signature: BprYlPHHjsJ
    // SmsAutoFill().getAppSignature.then((signature) {
    //   debugPrint("Signature: $signature");
    // });
  }

  @override
  void codeUpdated() {
    setState(() {
      _otpCode = code;
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  String _processAddress(String address, bool isMask) {
    RegExp emailRegExp = RegExp(r'^(.)(.*)(.@.*)$');
    RegExp phoneRegExp = RegExp(r'^(?:\+94|94|0)?(\d{9})$');

    if (emailRegExp.hasMatch(address)) {
      // Email detected
      if (isMask) {
        return address.replaceAllMapped(emailRegExp, (match) {
          String firstChar = match[1]!;
          String hiddenPart = '*' * match[2]!.length;
          String domain = match[3]!;
          return '$firstChar$hiddenPart$domain';
        });
      }
      debugPrint("Detected: Email");
      return address;
    } else if (phoneRegExp.hasMatch(address)) {
      // Phone detected
      if (isMask) {
        return address.replaceAllMapped(phoneRegExp, (match) {
          String digits = match.group(1)!; // the 9-digit number part
          String firstThree = digits.substring(0, 3);
          String lastThree = digits.substring(digits.length - 3);
          String masked = '*' * (digits.length - 6);

          return '$firstThree$masked$lastThree';
        });
      }
      debugPrint("Detected: Phone Number");
      return address;
    } else {
      return address;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      appBar: AppBar(
        actions: [
          ActionIconButton.of(context).contactSupport(),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                  Text("Security Authentication",
                      style: textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    children: [
                      Text(
                          "Enter $maxDigits-digit code that has been sent to "),
                      Text(_address,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 36),
                  TextFieldPinAutoFill(
                    decoration: InputDecoration(
                        hintText: "Enter code",
                        counterText: "", // Hides character counter
                        suffixIcon: CountdownButton(
                          seconds: 60,
                          controller: _countdownController,
                          onPressed: onResendCode,
                        )
                    ),
                    autoFocus: true,
                    currentCode: _otpCode, // prefill with a code
                    codeLength: maxDigits, //code length, default 6
                    focusNode: otpFocus,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onCodeChanged: onCodeChanged,
                    onCodeSubmitted: onCodeSubmitted,
                  ),

                  const SizedBox(height: 24),
                  PrimaryButton.filled(
                    text: "Verify Code",
                    enable: enableVerifyCodeBtn,
                    onPressed: onVerifyCode,
                    width: double.infinity,
                  ),
                  // const SizedBox(height: 16),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: LinkedTextButton(
                  //       text: "Unable to verify?",
                  //       link: " Contact support",
                  //       onTap: contactSupport),
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void onCodeChanged(String value) {
    debugPrint("Changed: $value");
    _otpCode = value;

    if (value.length == maxDigits) {
      onVerifyCode();
      setState(() {
        enableVerifyCodeBtn = true;
      });
    }
    if (value.length != maxDigits && enableVerifyCodeBtn) {
      setState(() {
        enableVerifyCodeBtn = false;
      });
    }

  }

  void onCodeSubmitted(String value) {
    debugPrint("Submitted: $value");
    _otpCode = value;
    onVerifyCode();
  }

  void onResendCode() async {
    otpFocus.unfocus();
    cancel();
    _countdownController.waiting;

    setState(() {
      _otpCode = null;
      enableVerifyCodeBtn = false;
    });

    final result = await _authController.onResendCode?.call(context, _authController.address);

    if(result is bool){
      result ? _countdownController.restart() : _countdownController.reset();
    }

    otpFocus.requestFocus();
    listenForCode();

    // debugPrint("Resend result: ${result.toString()}");
  }

  void onVerifyCode() async {
    if(_otpCode == ""){
      return;
    }

    otpFocus.unfocus();
    FocusScope.of(context).unfocus();

    final result = await _authController.onVerifyCode?.call(context, _otpCode!);

    if(mounted) {
      _authController.whenComplete?.call(context, result);
    }
    // debugPrint("Verified result: ${result.toString()}");
  }

  void contactSupport() {}
}

class CountdownTimerController extends ChangeNotifier {
  VoidCallback? _startCallback;
  VoidCallback? _pauseCallback;
  VoidCallback? _resetCallback;
  VoidCallback? _stopCallback;
  VoidCallback? _restartCallback;
  VoidCallback? _waitingCallback;

  void _bind({
    required VoidCallback start,
    required VoidCallback pause,
    required VoidCallback reset,
    required VoidCallback stop,
    required VoidCallback restart,
    required VoidCallback waiting,
  }) {
    _startCallback = start;
    _pauseCallback = pause;
    _resetCallback = reset;
    _stopCallback = stop;
    _restartCallback = restart;
    _waitingCallback = waiting;
  }

  void start() => _startCallback?.call();
  void pause() => _pauseCallback?.call();
  void reset() => _resetCallback?.call();
  void stop() => _stopCallback?.call();
  void restart() => _restartCallback?.call();
  void waiting() => _waitingCallback?.call();
}

class CountdownButton extends StatefulWidget {
  final int seconds;
  final CountdownTimerController? controller;
  final VoidCallback? onPressed;
  final VoidCallback? onFinished;
  final TextStyle? textStyle;
  final String? enabledText;

  const CountdownButton({
    super.key,
    this.seconds = 60,
    this.controller,
    this.onPressed,
    this.onFinished,
    this.textStyle,
    this.enabledText,
  });

  @override
  State<CountdownButton> createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<CountdownButton> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;

    widget.controller?._bind(
      start: _start,
      pause: _pause,
      reset: _reset,
      stop: _stop,
      restart: _restart,
      waiting: _waiting,
    );
  }

  void _tick() {
    if (_remainingSeconds > 0) {
      setState(() => _remainingSeconds--);
    } else {
      _stop();
      widget.onFinished?.call();
    }
  }

  void _start() {
    if (_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _pause() {
    _isRunning = false;
    _timer?.cancel();
  }

  void _stop() {
    _pause();
    setState(() => _remainingSeconds = 0);
  }

  void _reset() {
    _pause();
    setState(() => _remainingSeconds = widget.seconds);
  }

  void _restart() {
    _pause();
    setState(() => _remainingSeconds = widget.seconds);
    _start();
  }

  void _waiting() {
    _pause();
    setState(() => _remainingSeconds = widget.seconds);
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: _isRunning ? null : widget.onPressed,
        child: !_isRunning ? Text('Send Code') : Text(
          '$_remainingSeconds s',
          style: widget.textStyle,
        )
    );
  }
}
