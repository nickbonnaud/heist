import 'package:flutter/material.dart';
import 'package:heist/providers/storage_provider.dart';

@immutable
class InitialLoginRepository {
  final StorageProvider _tutorialProvider;

  static const String PERMISSIONS_KEY = 'permissions';

  const InitialLoginRepository({required StorageProvider tutorialProvider})
    : _tutorialProvider = tutorialProvider;

  Future<void> setIsInitialLogin({required bool isInitial}) async {
    return await _tutorialProvider.write(key: PERMISSIONS_KEY, value: isInitial.toString().toLowerCase());
  }

  Future<bool> isInitialLogin() async {
    final String? isInitial = await _tutorialProvider.read(key: PERMISSIONS_KEY);
    // setIsInitialLogin(true);
    if (isInitial == null) {
      await setIsInitialLogin(isInitial: true);
      return true;
    }

    return isInitial.toLowerCase() == 'true';
  }
}