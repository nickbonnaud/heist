import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/global_widgets/material_date_picker/bloc/material_date_picker_bloc.dart';

void main() {
  group("Material Date Picker Bloc Tests", () {
    late MaterialDatePickerBloc materialDatePickerBloc;
    late MaterialDatePickerState _baseState;

    late DateTime _date;

    setUp(() {
      materialDatePickerBloc = MaterialDatePickerBloc();
      _baseState = materialDatePickerBloc.state;
    });

    tearDown(() {
      materialDatePickerBloc.close();
    });

    test("Initial state of MaterialDatePickerBloc is MaterialDatePickerState.initial()", () {
      MaterialDatePickerState initialState = MaterialDatePickerState.initial();

      expect(materialDatePickerBloc.state.startDate, initialState.startDate);
      expect(materialDatePickerBloc.state.endDate, isA<DateTime>());
      expect(initialState.endDate, isA<DateTime>());
      expect(materialDatePickerBloc.state.active, initialState.active);
    });

    blocTest<MaterialDatePickerBloc, MaterialDatePickerState>(
      "MaterialDatePickerBloc DateChanged event changes state when Active.start: [startDate: dateTime]",
      build: () => materialDatePickerBloc,
      act: (bloc) {
        _date = DateTime.now();
        bloc.add(DateChanged(date: _date));
      },
      expect: () => [_baseState.update(startDate: _date)]
    );

    blocTest<MaterialDatePickerBloc, MaterialDatePickerState>(
      "MaterialDatePickerBloc DateChanged event changes state when Active.end: [endDate: dateTime]",
      build: () => materialDatePickerBloc,
      seed: () => _baseState.update(active: Active.end),
      act: (bloc) {
        _date = DateTime.now();
        bloc.add(DateChanged(date: _date));
      },
      expect: () => [_baseState.update(endDate: _date, active: Active.end)]
    );

    blocTest<MaterialDatePickerBloc, MaterialDatePickerState>(
      "MaterialDatePickerBloc ActiveSelectionChanged event changes state: [active: Active.end]",
      build: () => materialDatePickerBloc,
      act: (bloc) {
        bloc.add(ActiveSelectionChanged(active: Active.end));
      },
      expect: () => [_baseState.update(active: Active.end)]
    );

    blocTest<MaterialDatePickerBloc, MaterialDatePickerState>(
      "MaterialDatePickerBloc Reset event changes state MaterialDatePickerState.initial()",
      build: () => materialDatePickerBloc,
      seed: () => _baseState.update(startDate: DateTime.now(), endDate: DateTime.now(), active: Active.end),
      act: (bloc) {
        bloc.add(Reset());
      },
      verify: ((_) {
        expect(materialDatePickerBloc.state.startDate, null);
        expect(materialDatePickerBloc.state.endDate, isA<DateTime>());
        expect(materialDatePickerBloc.state.active, Active.start);
      })
    );
  });
}