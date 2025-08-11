import 'dart:async';

import 'package:flutter/material.dart';

import '../../shared/customize/custom_alert.dart';

// enum CallbackStatus { success, error, warning, information, none, exception }

// class CallbackResult<T> {
//   final String message;
//   final CallbackStatus status;
//   final int code;
//   final T? data;
//
//   CallbackResult(this.message, this.status, this.code, [this.data]);
//
//   CallbackResult.empty()
//       : message = 'Empty result',
//         status = CallbackStatus.none,
//         data = null;
//
//   CallbackResult.exception(this.message)
//       : status = CallbackStatus.exception,
//         data = null;
//
//   @override
//   String toString() {
//     return message;
//   }
// }

abstract class CallbackResult<T> {
  final String message;
  final int code;
  final T? data;

  CallbackResult(this.message, this.code, [this.data]);

  @override
  String toString() {
    return message;
  }
}

class CallbackSuccess<T> extends CallbackResult<T> {
  CallbackSuccess(super.message, super.code, [super.data]);
}

class CallbackError<T> extends CallbackResult<T> {
  CallbackError(super.message, super.code, [super.data]);
}

// class CallbackException extends CallbackResult<void> {
//   CallbackException(String message) : super(message, 0);
// }





