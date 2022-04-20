import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/resources/helpers/permissions_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInitialLoginRepository extends Mock implements InitialLoginRepository {}
class MockPermissionsChecker extends Mock implements PermissionsChecker {}

void main() {
  group("Permissions Bloc Tests", () {
    late InitialLoginRepository initialLoginRepository;
    late PermissionsChecker permissionsChecker;
    late PermissionsBloc permissionsBloc;

    late PermissionsState _baseState;

    setUp(() {
      initialLoginRepository = MockInitialLoginRepository();
      permissionsChecker = MockPermissionsChecker();
      permissionsBloc = PermissionsBloc(initialLoginRepository: initialLoginRepository, permissionsChecker: permissionsChecker);

      _baseState = permissionsBloc.state;
    });

    tearDown(() {
      permissionsBloc.close();
    });

    test("Initial state of PermissionsBloc is PermissionsState.unknown()", () {
      expect(permissionsBloc.state, PermissionsState.unknown());
    });

    test("PermissionsBloc has allPermissionsValid getter", () {
      expect(permissionsBloc.allPermissionsValid, isA<bool>());
    });

    test("PermissionsBloc has numberValidPermissions getter", () {
      expect(permissionsBloc.numberValidPermissions, isA<int>());
    });

    test("PermissionsBloc has invalidPermissions getter", () {
      expect(permissionsBloc.invalidPermissions, isA<List<PermissionType>>());
    });

    blocTest<PermissionsBloc, PermissionsState>(
      "PermissionsBloc BleStatusChanged event changes state: [bleEnabled]",
      build: () => permissionsBloc,
      act: (bloc) => bloc.add(const BleStatusChanged(granted: true)),
      expect: () => [_baseState.update(bleEnabled: true)]
    );

    blocTest<PermissionsBloc, PermissionsState>(
      "PermissionsBloc LocationStatusChanged event changes state: [locationEnabled]",
      build: () => permissionsBloc,
      act: (bloc) => bloc.add(const LocationStatusChanged(granted: true)),
      expect: () => [_baseState.update(locationEnabled: true)]
    );

    blocTest<PermissionsBloc, PermissionsState>(
      "PermissionsBloc NotificationStatusChanged event changes state: [notificationEnabled]",
      build: () => permissionsBloc,
      act: (bloc) => bloc.add(const NotificationStatusChanged(granted: true)),
      expect: () => [_baseState.update(notificationEnabled: true)]
    );

    blocTest<PermissionsBloc, PermissionsState>(
      "PermissionsBloc UpdateAllPermissions event changes state: [bleEnabled, locationEnabled, notificationEnabled, beaconEnabled, checksComplete]",
      build: () => permissionsBloc,
      act: (bloc) => bloc.add(const UpdateAllPermissions(
        bleGranted: true,
        locationGranted: true,
        notificationGranted: true,
        beaconGranted: true,
        checksComplete: true
      )),
      expect: () => [_baseState.update(
        bleEnabled: true,
        locationEnabled: true,
        notificationEnabled: true,
        beaconEnabled: true,
        checksComplete: true
      )]
    );

    blocTest<PermissionsBloc, PermissionsState>(
      "PermissionsBloc CheckPermissions event changes state if initialLogin: [PermissionsState.isInitial()]",
      build: () => permissionsBloc,
      act: (bloc) {
        when(() => initialLoginRepository.isInitialLogin()).thenAnswer((_) async => true);
        bloc.add(CheckPermissions());
      },
      expect: () => [PermissionsState.isInitial()]
    );

    blocTest<PermissionsBloc, PermissionsState>(
      "PermissionsBloc CheckPermissions event changes state if not initialLogin: [[bleEnabled, locationEnabled, notificationEnabled, beaconEnabled, checksComplete]]",
      build: () => permissionsBloc,
      act: (bloc) {
        when(() => initialLoginRepository.isInitialLogin()).thenAnswer((_) async => false);
        
        when(() => permissionsChecker.bleEnabled()).thenAnswer((_) async => true);
        when(() => permissionsChecker.locationEnabled()).thenAnswer((_) async => false);
        when(() => permissionsChecker.notificationEnabled()).thenAnswer((_) async => true);
        when(() => permissionsChecker.beaconEnabled()).thenAnswer((_) async => false);
        
        bloc.add(CheckPermissions());
      },
      expect: () => [_baseState.update(
        bleEnabled: true,
        locationEnabled: false,
        notificationEnabled: true,
        beaconEnabled: false,
        checksComplete: true
      )]
    );
  });
}