import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageProvider extends Mock implements StorageProvider {}

void main() {
  group("Initial Login Repository Tests", () {
    late StorageProvider tutorialProvider;
    late InitialLoginRepository initialLoginRepository;

    setUp(() {
      tutorialProvider = MockStorageProvider();
      when(() => tutorialProvider.write(key: any(named: "key"), value: any(named: "value")))
        .thenAnswer((_) async => null);

      when(() => tutorialProvider.read(key: any(named: "key")))
        .thenAnswer((_) async => "false");

      initialLoginRepository = InitialLoginRepository(tutorialProvider: tutorialProvider);
    });

    test("Initial Login Repository can set is initial login", () async {
      await initialLoginRepository.setIsInitialLogin(isInitial: true);
      verify(() => tutorialProvider.write(key: any(named: "key"), value: true.toString().toLowerCase())).called(1);
    });

    test("Initial Login Repository can determine if initial login", () async {
      var isInitial = await initialLoginRepository.isInitialLogin();
      expect(isInitial, isA<bool>());

      when(() => tutorialProvider.read(key: any(named: "key")))
        .thenAnswer((_) async => "true");
      isInitial = await initialLoginRepository.isInitialLogin();
      expect(isInitial, isA<bool>());

      when(() => tutorialProvider.read(key: any(named: "key")))
        .thenAnswer((_) async => null);
      isInitial = await initialLoginRepository.isInitialLogin();
      expect(isInitial, isA<bool>());
    });

    test("Initial Login Repository calls tutorialProvider.read on isInitialLogin", () async {
      await initialLoginRepository.isInitialLogin();
      verify(() => tutorialProvider.read(key: any(named: "key"))).called(1);
    });
  });
}