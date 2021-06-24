import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/transaction_picker_screen/widgets/transaction/bloc/transaction_bloc.dart';

void main() {
  group("Transaction Bloc Tests", () {
    late TransactionBloc transactionBloc;

    late DateTime? _baseState;

    setUp(() {
      transactionBloc = TransactionBloc();
      _baseState = transactionBloc.state;
    });

    tearDown(() {
      transactionBloc.close();
    });

    test("Initial state of TransactionBloc is null", () {
      expect(transactionBloc.state, null);
    });

    blocTest<TransactionBloc, DateTime?>(
      "TransactionBloc PickerChanged event changes state: [DateTime]",
      build: () => transactionBloc,
      act: (bloc) {
        _baseState = DateTime.now();
        bloc.add(PickerChanged(transactionUpdatedAt: _baseState!));
      },
      expect: () => [_baseState]
    );
  });
}