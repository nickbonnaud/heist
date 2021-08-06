import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/global_widgets/ios_date_picker/bloc/ios_date_picker_bloc.dart';

void main() {
  group("Ios Date Picker Bloc Tests", () {
    late IosDatePickerBloc iosDatePickerBloc;
    late IosDatePickerState _baseState;

    late DateTime _date;

    setUp(() {
      iosDatePickerBloc = IosDatePickerBloc();
      _baseState = iosDatePickerBloc.state;
    });

    tearDown(() {
      iosDatePickerBloc.close();
    });

    test("Initial state of IosDatePickerBloc is IosDatePickerState.initial()", () {
      IosDatePickerState initialState = IosDatePickerState.initial();
      expect(iosDatePickerBloc.state.startDate, initialState.startDate);
      expect(iosDatePickerBloc.state.endDate, isA<DateTime>());
      expect(initialState.endDate, isA<DateTime>());
      expect(iosDatePickerBloc.state.active, initialState.active);
    });

    blocTest<IosDatePickerBloc, IosDatePickerState>(
      "IosDatePickerBloc DateChanged event changes state when Active.start: [startDate: dateTime]",
      build: () => iosDatePickerBloc,
      wait: Duration(milliseconds: 500),
      act: (bloc) {
        _date = DateTime.now();
        bloc.add(DateChanged(date: _date));
      },
      expect: () => [_baseState.update(startDate: _date)]
    );

    blocTest<IosDatePickerBloc, IosDatePickerState>(
      "IosDatePickerBloc DateChanged event changes state when Active.end: [endDate: dateTime]",
      build: () => iosDatePickerBloc,
      seed: () => _baseState.update(active: Active.end),
      wait: Duration(milliseconds: 500),
      act: (bloc) {
        _date = DateTime.now();
        bloc.add(DateChanged(date: _date));
      },
      expect: () => [_baseState.update(endDate: _date, active: Active.end)]
    );

    blocTest<IosDatePickerBloc, IosDatePickerState>(
      "IosDatePickerBloc ActiveSelectionChanged event changes state [active: Active.end]",
      build: () => iosDatePickerBloc,
      act: (bloc) {
        bloc.add(ActiveSelectionChanged(active: Active.end));
      },
      expect: () => [_baseState.update(active: Active.end)]
    );

    blocTest<IosDatePickerBloc, IosDatePickerState>(
      "IosDatePickerBloc Reset event changes state IosDatePickerState.initial()",
      build: () => iosDatePickerBloc,
      seed: () => _baseState.update(startDate: DateTime.now(), endDate: DateTime.now(), active: Active.end),
      act: (bloc) {
        bloc.add(Reset());
      },
      verify: ((_) {
        expect(iosDatePickerBloc.state.startDate, null);
        expect(iosDatePickerBloc.state.endDate, isA<DateTime>());
        expect(iosDatePickerBloc.state.active, Active.start);
      })
    );
  });
}