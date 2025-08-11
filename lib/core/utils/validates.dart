
import 'package:flutter/material.dart';

class Validates{
  static String? email(String? value) {
    final regex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if(value == null || value.isEmpty){
      return "Required*";
    }
    else if(!regex.hasMatch(value)){
      return "Invalid format";
    }
    else {
      return null;
    }
  }

  static String? password(String? value) {
    final regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~/]).{8,}$');

    if(value == null || value.isEmpty){
      return "Required*";
    }
    else if(!regex.hasMatch(value)){

      return "* Contains a uppercase and lowercase character\n"
          "* Contains a number and symbol\n"
          "* At least 8 characters";
    }
    else {
      return null;
    }
  }

  static String? mobile(String? value) {
    final regex = RegExp(r'^(\+\d{1,3}[- ]?)?\d{10}$');

    if(value == null || value.isEmpty){
      return "Required*";
    }
    else if (!regex.hasMatch(value)) {
      return 'Invalid mobile number';
    }
    else {
      return null;
    }
  }

  static String? versionNo(String? value){
    final regex = RegExp(r'^[.0-9]*$');
    if(value == null || value.isEmpty){
      return "Version Number Required*";
    }
    else if(!regex.hasMatch(value)) {
      return 'Invalid format';
    }
    else {
      return null;
    }
  }

  static String? numeric(String? value){
    final regex = RegExp(r'^[0-9]\d*(\.\d+)?$');
    if(value == null || value.isEmpty){
      return "Required*";
    }
    else if(!regex.hasMatch(value)) {
      return 'Invalid format';
    }
    else {
      return null;
    }
  }

  static String? text(String? value, {int? minimumCharacters}){
    if(value == null || value.isEmpty){
      return "Required*";
    }
    else if(minimumCharacters != null && value.length < minimumCharacters){
      return "At least $minimumCharacters characters";
    }
    else {
      return null;
    }
  }

  static String? nic(String? value, [bool isRequired = true]){
    if(value == null || value.trim().isEmpty){
      if(isRequired) {
        return 'Required*';
      } else {
        return null;
      }
    }
    else if (!RegExp(r'^(\d{9}[VXvx]|\d{12})$').hasMatch(value)) {
      return 'Enter a valid NIC number';
    }
    else {
      return null;
    }
  }

  static String? nicOrLoyaltyCard(String? value, [bool isRequired = true]) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Required*' : null;
    }

    final regex = RegExp(r'^(?:\d{10}|\d{9}[vVxX]|\d{12})$');

    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid Nic or Loyalty number';
    }

    return null; // Valid input
  }

  static String? byInputType(String? value, TextInputType inputType, [bool isRequired = true]) {
    // if (isRequired && (value == null || value.isEmpty)) {
    //   return 'required*';
    // }

    if(value == null || value.isEmpty){
      return isRequired ? 'Required*' : null;
    }
    else if(inputType == TextInputType.number){
      if (value.trim().isEmpty || !RegExp(r'^\d+$').hasMatch(value)) {
        return 'Enter a valid number';
      }
    }
    else if(inputType == TextInputType.name){
      if (value.trim().isEmpty || !RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
        return 'Enter a valid name';
      }
    }
    else if(inputType == TextInputType.emailAddress){
      if (value.trim().isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
        return 'Enter a valid email';
      }
    }
    else if(inputType == TextInputType.streetAddress){
      if (value.trim().isEmpty || value.length < 5) {
        return 'Enter a valid address';
      }
    }
    else if(inputType == TextInputType.text){
      if (value.trim().isEmpty || value.length < 2) {
        return 'Enter at least 2 characters';
      }
    } else {
      return null;
    }

    return null;
  }

  static bool isValidNic(String value) {
    final regex = RegExp(r'^(\d{9}[VXvx]|\d{12})$');
    return value.isNotEmpty && regex.hasMatch(value);
  }

  static bool isValidLoyaltyCard(String value) {
    final regex = RegExp(r'^\d{10}$');
    return value.isNotEmpty && regex.hasMatch(value);
  }

  static bool isValidEmail(String value) {
    // final regex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return value.isNotEmpty && regex.hasMatch(value);
  }
}


