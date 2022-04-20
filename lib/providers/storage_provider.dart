import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@immutable
class StorageProvider {
  final storage = const FlutterSecureStorage();


  Future<String?> read({required String key}) async {
    return await storage.read(key: key);
  }

  Future<void> write({required String key, required String value}) async {
    return await storage.write(key: key, value: value);
  }

  Future<void> delete({required String key}) async {
    return await storage.delete(key: key);
  }
}