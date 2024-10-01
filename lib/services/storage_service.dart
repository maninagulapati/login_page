import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage =  FlutterSecureStorage();

  // Save token to secure storage
  Future<void> writeToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // Read token from secure storage
  Future<String?> readToken() async {
    return await _storage.read(key: 'token');
  }

  // Delete token from secure storage
  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}
