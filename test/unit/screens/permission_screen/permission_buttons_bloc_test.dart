import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/permission_screen/widgets/permission_buttons/bloc/permission_buttons_bloc.dart';

void main() {
  group("Permission Buttons Bloc Tests", () {
    late PermissionButtonsBloc permissionButtonsBloc;

    setUp(() {
      permissionButtonsBloc = PermissionButtonsBloc();
    });

    tearDown(() {
      permissionButtonsBloc.close();
    });

    test("Initial state of PermissionButtonsBloc is true", () {
      expect(permissionButtonsBloc.state, true);
    });

    blocTest<PermissionButtonsBloc, bool>(
      "PermissionButtonsBloc event enable yields state: [true]",
      build: () => permissionButtonsBloc,
      seed: () => false,
      act: (bloc) => bloc.add(PermissionButtonsEvent.enable),
      expect: () => [true]
    );

    blocTest<PermissionButtonsBloc, bool>(
      "PermissionButtonsBloc event disable yields state: [fals]",
      build: () => permissionButtonsBloc,
      act: (bloc) => bloc.add(PermissionButtonsEvent.disable),
      expect: () => [false]
    );
  });
}