import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/home_screen/widgets/peek_sheet/widgets/logo_buttons_list/widgets/shared_list_items/logo_button/widgets/logo_transaction_button/bloc/logo_transaction_button_bloc.dart';

void main() {
  group("Logo Transaction Button Bloc Tests", () {
    late LogoTransactionButtonBloc logoTransactionButtonBloc;
    late LogoTransactionButtonState _baseState;

    setUp(() {
      logoTransactionButtonBloc = LogoTransactionButtonBloc();
      _baseState = logoTransactionButtonBloc.state;
    });

    tearDown(() {
      logoTransactionButtonBloc.close();
    });

    test("Initial state of LogoTransactionButtonBloc is LogoTransactionButtonState.initial()", () {
      expect(logoTransactionButtonBloc.state, LogoTransactionButtonState.initial());
    });

    blocTest<LogoTransactionButtonBloc, LogoTransactionButtonState>(
      "LogoTransactionButtonBloc TogglePressed event yields state: [isPressed: !state.pressed]",
      build: () => logoTransactionButtonBloc,
      act: (bloc) => bloc.add(TogglePressed()),
      expect: () => [_baseState.update(isPressed: !_baseState.pressed)]
    );
  });
}