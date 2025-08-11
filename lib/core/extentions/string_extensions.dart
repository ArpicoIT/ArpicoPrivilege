extension StringExtension on String {
  // RoutingData get getRoutingData {
  //   var uriData = Uri.parse(this);
  //   // print('queryParameters: ${uriData.queryParameters} path: ${uriData.path}');
  //
  //   return RoutingData(
  //     queryParameters: uriData.queryParameters,
  //     route: uriData.path,
  //   );
  // }

  String get maskPhone {
    if(length > 5){
      String firstDigits = substring(0, 2);
      String lastDigits = substring(length - 3);
      String maskedNumber = firstDigits + ('x' * (length - 5)) + lastDigits;
      return maskedNumber ;
    } else{
      return '';
    }
  }

  String get countryCodePrefix {
    if (startsWith('+')) {
      return substring(1, length);
    } else {
      return this;
    }
  }

  String toUpperCaseFirst(){
    if(isNotEmpty){
      return substring(0, 1).toUpperCase() + substring(1, length);
    } else {
      return this;
    }
  }

  String toTitleCase() {
    if (trim().isEmpty) return this;

    return split(' ')
        .map((word) =>
    word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '')
        .join(' ');
  }

  String toNormalizeMobileNumber() {
    // Remove all non-digit characters
    String digits = replaceAll(RegExp(r'\D'), '');

    // Ensure it starts with country code
    if (digits.startsWith('0')) {
      digits = '94${digits.substring(1)}'; // Replace leading 0 with country code 94
    } else if (digits.startsWith('94')) {
      // Already in the correct format
    } else if (!digits.startsWith('94')) {
      digits = '94$digits'; // If it's just the local number, add country code
    }

    return '+$digits';
  }

  // String get encrypt {
  //   final hashingService = HashingService();
  //   final configService = ConfigService();
  //   final secureStatus = configService.getConfig('secureStatus') ?? "true";
  //   if(secureStatus == "true"){
  //     return hashingService.encryptAES(this);
  //   }
  //   return this;
  // }
  // String get decrypt {
  //   final hashingService = HashingService();
  //   final configService = ConfigService();
  //   final secureStatus = configService.getConfig('secureStatus') ?? "true";
  //   if(secureStatus == "true"){
  //     return hashingService.decryptAES(this);
  //   }
  //   return this;
  // }
}