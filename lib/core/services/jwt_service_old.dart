import 'package:arpicoprivilege/core/services/storage_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'configure_service.dart';

class JWTServiceOld {
  // Singleton Instance
  static final JWTServiceOld instance = JWTServiceOld._internal();

  // Private Constructor
  JWTServiceOld._internal();

  // Configuration Service
  final _configService = ConfigService();

  /// Generate a JWT token
  String generate (Map<String, dynamic> payload) {
    try {
      final jwt = JWT(payload);
      final String? secretKey = _configService.getConfig('jwtSecret');
      if(secretKey == null){
        throw Exception('JWT secret key is not available');
      }
      final token = jwt.sign(SecretKey(secretKey));
      return token;
    } on JWTException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  /// Verify and decode a JWT token
  Map<String, dynamic> verify (token) {
    try {
      final String? secretKey = _configService.getConfig('jwtSecret');
      if(secretKey == null){
        throw Exception('JWT secret key is not available');
      }

      final jwt = JWT.verify(token, SecretKey(secretKey));
      return jwt.payload;
    } on JWTExpiredException {
      throw Exception('JWT expired');
    } on JWTException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  /// Decode a JWT token without verification
  Map<String, dynamic> decode (token) {
    try {
      final jwt = JWT.decode(token);
      return jwt.payload;
    } on JWTException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

}