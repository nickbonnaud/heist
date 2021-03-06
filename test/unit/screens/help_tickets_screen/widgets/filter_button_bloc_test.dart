import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/help_tickets_screen/widgets/widgets/filter_button/bloc/filter_button_bloc.dart';

void main() {
  group("Filter Button Bloc Tests", () {
    late FilterButtonBloc filterButtonBloc;
    late FilterButtonState _baseState;

    setUp(() {
      filterButtonBloc = FilterButtonBloc();
      _baseState = filterButtonBloc.state;
    });

    tearDown(() {
      filterButtonBloc.close();
    });

    test("Initial state of FilterButtonBloc is FilterButtonState.initial()", () {
      expect(filterButtonBloc.state, FilterButtonState.initial());
    });

    blocTest<FilterButtonBloc, FilterButtonState>(
      "FilterButtonBloc Toggle event yields state: [!state.isActive]",
      build: () => filterButtonBloc,
      act: (bloc) => bloc.add(Toggle()),
      expect: () => [_baseState.update(isActive: !_baseState.isActive)]
    );
  });
}