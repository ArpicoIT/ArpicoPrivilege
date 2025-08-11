class NICValidator {
  static final List<Map<String, dynamic>> dArray = [
    {'month': 'January', 'days': 31},
    {'month': 'February', 'days': 29},
    {'month': 'March', 'days': 31},
    {'month': 'April', 'days': 30},
    {'month': 'May', 'days': 31},
    {'month': 'June', 'days': 30},
    {'month': 'July', 'days': 31},
    {'month': 'August', 'days': 31},
    {'month': 'September', 'days': 30},
    {'month': 'October', 'days': 31},
    {'month': 'November', 'days': 30},
    {'month': 'December', 'days': 31},
  ];

  static Map<String, dynamic> extractData(String nicNumber) {
    Map<String, dynamic> result = {'year': '', 'dayList': 0, 'character': ''};

    if (nicNumber.length == 10) {
      result['year'] = '19${nicNumber.substring(0, 2)}';
      result['dayList'] = int.parse(nicNumber.substring(2, 5));
      result['character'] = nicNumber.substring(9);
    } else if (nicNumber.length == 12) {
      result['year'] = nicNumber.substring(0, 4);
      result['dayList'] = int.parse(nicNumber.substring(4, 7));
      result['character'] = 'no';
    }
    return result;
  }

  static Map<String, String> findDayAndGender(int days) {
    int dayList = days;
    String gender = dayList < 500 ? 'Male' : 'Female';
    if (dayList >= 500) dayList -= 500;

    for (var monthData in dArray) {
      if (dayList > monthData['days']) {
        dayList -= monthData['days'] as int;
      } else {
        return {'day': dayList.toString(), 'month': monthData['month'], 'gender': gender};
      }
    }
    return {'day': '', 'month': '', 'gender': gender};
  }

  static bool validation(String nicNumber) {
    if (nicNumber.length == 10) {
      return RegExp(r'^[0-9]{9}[vxVX]$').hasMatch(nicNumber);
    } else if (nicNumber.length == 12) {
      return RegExp(r'^[0-9]{12}$').hasMatch(nicNumber);
    }
    return false;
  }

  static String getFormattedDate(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$month/$day/$year';
  }

  static Map<String, String> validateNIC(String nicNumber) {
    if (!validation(nicNumber)) {
      return {'error': 'You entered an invalid NIC number'};
    }

    var extractedData = extractData(nicNumber);
    var dayList = extractedData['dayList'] as int;
    var foundData = findDayAndGender(dayList);

    String year = extractedData['year'];
    String birthdayStr = '${foundData['day']}-${foundData['month']}-$year';
    DateTime birthday = DateTime.parse('$year-${dArray.indexWhere((m) => m['month'] == foundData['month']) + 1}-${foundData['day']}');
    String formattedBirthday = getFormattedDate(birthday);

    return {
      'birthday': 'Birthday: $formattedBirthday',
      'gender': 'Gender: ${foundData['gender']}'
    };
  }
}