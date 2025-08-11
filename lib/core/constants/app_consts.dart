
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

const Size kMinScreenSize = Size(480, 720);

IsoCode kIsoCode = IsoCode.LK;
bool keepAppHomeState = true;

const Duration kShortTimeout = Duration(seconds: 10);
const Duration kDefaultTimeout = Duration(seconds: 15);
const Duration kLongTimeout = Duration(seconds: 60);
