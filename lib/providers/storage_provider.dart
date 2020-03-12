import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageProvider {
  final storage = new FlutterSecureStorage();


  Future<String> read(String key) async {
    return await storage.read(key: key);
  }

  Future<void> write(String key, String value) async {
    return await storage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    return await storage.delete(key: key);
  }
}