import 'package:jwt_decoder/jwt_decoder.dart';

class JWTService {
  // Singleton Instance
  static final JWTService instance = JWTService._internal();

  // Private Constructor
  JWTService._internal();

  // Method to check if a token is expired
  bool hasExpired(String token) {
    if (token.isEmpty) return true; // Assume expired if token is empty
    return JwtDecoder.isExpired(token);
  }

  // Method to decode JWT token
  Map<String, dynamic> decode(String token) {
    return JwtDecoder.decode(token);
  }
}