import 'dart:async';

import 'package:flutter/material.dart';

class TimerController {
  TimerController({Duration? duration}){
    _duration = duration ?? Duration(minutes: 1);
    _remainingTime.value = _duration.inSeconds;
  }
  late Duration _duration;

  Timer? _timer;
  final ValueNotifier<int> _remainingTime = ValueNotifier(0);

  void _run(){
    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      if (_remainingTime.value > 0) {
        _remainingTime.value--;
        // debugPrint(_remainingTime.value.toString());
      } else {
        timer.cancel();
      }
    });
  }

  void start() {
    if(_remainingTime.value == 0 && _timer != null){
      if(_timer!.isActive) {
        _timer?.cancel();
      }
      return;
    }
    _run();
  }

  void restart() {
    _remainingTime.value = _duration.inSeconds;
    _run();
  }

  void pause() {
    _timer?.cancel();
  }

  void reset() {
    _remainingTime.value = _duration.inSeconds;
    _timer?.cancel();
  }

  void reassemble() {
    _remainingTime.value = 0;
    _timer?.cancel();
  }

  void dispose(){
    _timer?.cancel();
    _remainingTime.dispose();
  }

  Duration get duration => _duration;

  ValueNotifier get remainingTime => _remainingTime;


}

class TimerButton extends StatelessWidget {
  final TimerController controller;
  final void Function()? onPressed;
  final String label;
  final ButtonStyle? style;

  const TimerButton({
    super.key,
    required this.controller,
    this.onPressed,
    required this.label,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: controller.remainingTime,
        builder: (context, time, child) {
          return TextButton(
            onPressed: (time==0) ? (){
              controller.restart();
              onPressed?.call();
            } : null,
            style: style,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(time>0) ...[
                  Text('${time}s'),
                  const SizedBox(width: 4)
                ],

                Text(label),
              ],
            ),
          );
        }
    );
  }
}