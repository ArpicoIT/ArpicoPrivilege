import 'dart:convert';

import 'package:arpicoprivilege/data/models/eBill.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_consts.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/services/configure_service.dart';
import '../../core/services/http_service.dart';

class EBillRepository {
  /// Host url
  final hostUrl = ConfigService().getConfig('appDomain');

  /// Api endpoints
  static const String EBILL_REGISTRATION = '/ebill_registration';
  static const String EBILL_RECEIPT_INFO = '/receipt_info';
  static const String EBILL_RECEIPTS = '/ebill_details';

  Future<CallbackResult<Map<String, dynamic>>> eBillRegistration({
    required String loyaltyId,
    required String nic,
    required String mobile,
    required String? email,
    required String name,
    required String uuid,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$hostUrl$EBILL_REGISTRATION');

      final response = await http.post(url,
          body: json.encode({
            "loyId": loyaltyId,
            "name": name,
            "email": email,
            "nic": nic,
            "phoneNo": mobile,
            "uuid": uuid
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, {
          "isLogged": result.data["isLogged"],
          "token": result.data["data"]["token"]
        });
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<List<EBill>>> getEBills(
      {required String? custId,
      required String? custMobile,
      String? ebillNo,
      String? receiptNo,
      String? curDate,
      required String token,
      int? limit,
      int? offset}) async {
    try {
      final url = Uri.parse('$hostUrl$EBILL_RECEIPTS').replace(
          queryParameters: {
            'limit': limit.toString(),
            'offset': offset.toString()
          });

      // test values
      // custId = "0065087646";
      // custMobile = "0710930444";

      final response = await http.post(url,
          body: json.encode({
            "cardId": custId??"",
            "mobileNo": custMobile??"",
            "ebillNo": ebillNo??"",
            "receiptNo": receiptNo??"",
            "curDate": curDate??"",
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, EBill.mapFromList(result.data)
        );
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }
}
