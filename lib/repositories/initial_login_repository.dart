import 'package:flutter/material.dart';
import 'package:heist/providers/storage_provider.dart';

@immutable
class InitialLoginRepository {
  static const String permissionsKey = 'permissions';
  final StorageProvider? _tutorialProvider;

  const InitialLoginRepository({StorageProvider? tutorialProvider})
    : _tutorialProvider = tutorialProvider;

  Future<void> setIsInitialLogin({required bool isInitial}) async {
    StorageProvider tutorialProvider = _getStorageProvider();
    
    return await tutorialProvider.write(key: permissionsKey, value: isInitial.toString().toLowerCase());
  }

  Future<bool> isInitialLogin() async {
    StorageProvider tutorialProvider = _getStorageProvider();

    String? isInitial = await tutorialProvider.read(key: permissionsKey);
    // setIsInitialLogin(true);
    if (isInitial == null) {
      await setIsInitialLogin(isInitial: true);
      return true;
    }

    return isInitial.toLowerCase() == 'true';
  }

  StorageProvider _getStorageProvider() {
    return _tutorialProvider ?? const StorageProvider();
  }
}