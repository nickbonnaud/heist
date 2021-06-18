import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/auth_screen/widgets/cubit/keyboard_visible_cubit.dart';

void main() {
  group("Keyboard Visible Cubit Tests", () {
    late KeyboardVisibleCubit keyboardVisibleCubit;

    setUp(() {
      keyboardVisibleCubit = KeyboardVisibleCubit();
    });

    tearDown(() {
      keyboardVisibleCubit.close();
    });

    test("Initial state of KeyboardVisibleCubit is false", () {
      expect(keyboardVisibleCubit.state, false);
    });

    blocTest<KeyboardVisibleCubit, bool>(
      "KeyboardVisibleCubit toggle event changes state: [!isVisible]",
      build: () => keyboardVisibleCubit,
      act: (cubit) => cubit.toggle(isVisible: !keyboardVisibleCubit.state),
      expect: () => [true]
    );
  });
}