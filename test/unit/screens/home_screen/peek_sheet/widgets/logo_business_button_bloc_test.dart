import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/home_screen/widgets/home_screen_body/widgets/peek_sheet/widgets/logo_buttons_list/widgets/shared_list_items/logo_button/widgets/logo_business_button/bloc/logo_business_button_bloc.dart';

void main() {
  group("Logo Business Button Bloc Tests", () {
    late LogoBusinessButtonBloc logoBusinessButtonBloc;

    late LogoBusinessButtonState _baseState;

    setUp(() {
      logoBusinessButtonBloc = LogoBusinessButtonBloc();
      _baseState = logoBusinessButtonBloc.state;
    });

    tearDown(() {
      logoBusinessButtonBloc.close();
    });

    test("Initial state of LogoBusinessButtonBloc is LogoBusinessButtonState.initial()", () {
      expect(logoBusinessButtonBloc.state, LogoBusinessButtonState.initial());
    });

    blocTest<LogoBusinessButtonBloc, LogoBusinessButtonState>(
      "LogoBusinessButtonBloc TogglePressed event yields state: [isPressed: !state.pressed]",
      build: () => logoBusinessButtonBloc,
      act: (bloc) => bloc.add(TogglePressed()),
      expect: () => [_baseState.update(isPressed: !_baseState.pressed)]
    );
  });
}