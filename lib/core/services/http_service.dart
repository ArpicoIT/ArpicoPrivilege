import 'dart:convert';
import 'package:http/http.dart' as http;

// Define a base Result class
abstract class Result<T> {}

// Define a Success class extending Result
class Success<T> extends Result<T> {
  final String message;
  final int statusCode;
  final T data;

  Success({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  @override
  String toString() {
    return 'Success: $message';
  }
}

// Define an Error class extending Result
class Error extends Result {
  final String error;
  final int statusCode;

  Error({
    required this.error,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'Error: $error';
  }
}

// // Define an Exception class extending Result
// class HttpException extends Result {
//   final String exception;
//   HttpException(this.exception);
//
//   @override
//   String toString() {
//     return 'Exception: $exception';
//   }
// }

// HttpService class with a factory method
class HttpService {

  static Result fromResponse(http.Response response) {
    try {
      final int statusCode = response.statusCode;
      final dynamic body =
          jsonDecode(response.body); // Body can be a Map or List

      if (statusCode == 200) {
        if (body is Map<String, dynamic>) {
          return Success<Map<String, dynamic>>(
            message: body["message"] ?? "Success",
            statusCode: statusCode,
            data: body,
          );
        } else if (body is List) {
          return Success<List>(
            message: "Success",
            statusCode: statusCode,
            data: body,
          );
        } else {
          return Error(
            error: "Unexpected response format",
            statusCode: statusCode,
          );
        }
      } else {
        return Error(
          error: _getErrorMessages(body),
          statusCode: statusCode,
        );
      }
    } catch (e) {
      throw response.reasonPhrase ?? e;
    }
  }

  static Future<Result> fromStreamedResponse(
      http.StreamedResponse response) async {
    try {
      final int statusCode = response.statusCode;
      final String responseBody = await response.stream.bytesToString();
      final dynamic body =
          jsonDecode(responseBody); // Body can be a Map or List

      if (statusCode == 200) {
        if (body is Map<String, dynamic>) {
          return Success<Map<String, dynamic>>(
            message: body["message"] ?? "Success",
            statusCode: statusCode,
            data: body,
          );
        } else if (body is List) {
          return Success<List>(
            message: "Success",
            statusCode: statusCode,
            data: body,
          );
        } else {
          return Error(
            error: "Unexpected response format",
            statusCode: statusCode,
          );
        }
      } else {
        return Error(
          error: _getErrorMessages(body),
          statusCode: statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static String _getErrorMessages(dynamic body) {
    if (body is! Map<String, dynamic>) return "An error occurred";

    const keys = ["message", "error", "warning"];
    for (final key in keys) {
      final value = body[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }

    return "An error occurred";
  }


  // Map<String, String> baseHeaders([Map<String, String>? headers]) {
  //   final Map<String, String> defaultHeaders = {
  //     "Access-Control-Allow-Origin": "*", // Required for CORS support to work, comment this in production mode
  //     "Access-Control-Allow-Headers":
  //         "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  //     "Content-Type": "application/json; charset=UTF-8",
  //     "Developer": "Gayan Chanaka"
  //   };
  //   if (headers != null) {
  //     defaultHeaders.addAll(headers);
  //   }
  //   return defaultHeaders;
  // }
}

/*class Success<T> extends Result {
  final String message;
  final int statusCode;
  final T data;

  Success({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  @override
  String toString() {
    return 'Success: $message';
  }
}*/

/*class HttpService {
  static Result fromResponse(http.Response response) {
    try {
      final int statusCode = response.statusCode;
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (statusCode == 200) {
        return Success(
          message: body["message"] ?? "Success",
          statusCode: statusCode,
          data: body,
        );
      } else {
        return Error(
          error: body["error"] ?? "An error occurred",
          statusCode: statusCode,
        );
      }
    } catch (e) {
      return HttpException(e.toString());
    }
  }
}*/
