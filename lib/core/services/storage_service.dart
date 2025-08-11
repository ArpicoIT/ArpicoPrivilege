import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Singleton Instance
  static final StorageService instance = StorageService._internal();

  // Private Constructor
  StorageService._internal();

  // FlutterSecureStorage instance
  final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Write a value to secure storage
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read a value from secure storage
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete a value from secure storage
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Delete all values from secure storage
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // Check if a key exists
  Future<bool> containsKey(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }
}

