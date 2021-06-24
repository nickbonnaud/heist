import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/status.dart';
import 'package:heist/models/transaction/transaction.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';

import '../../../helpers/mock_data_generator.dart';

void main() {
  group("Receipt Screen Bloc Tests", () {
    late ReceiptScreenBloc receiptScreenBloc;
    late ReceiptScreenState _baseState;

    late MockDataGenerator _mockDataGenerator;
    late TransactionResource _transactionResource;

    setUp(() {
      _mockDataGenerator = MockDataGenerator();

      _transactionResource = _mockDataGenerator.createTransactionResource();
      Transaction transaction = _transactionResource.transaction.update(status: Status(name: "name", code: 101));
      _transactionResource = _transactionResource.update(transaction: transaction);

      receiptScreenBloc = ReceiptScreenBloc(transactionResource: _transactionResource);
      _baseState = receiptScreenBloc.state;
    });

    tearDown(() {
      receiptScreenBloc.close();
    });

    test("Initial state of ReceiptScreenBloc is ReceiptScreenState.initial", () {
      expect(receiptScreenBloc.state, ReceiptScreenState.initial(transactionResource: _transactionResource, isButtonVisible: true));
    });

    blocTest<ReceiptScreenBloc, ReceiptScreenState>(
      "ReceiptScreenBloc TransactionChanged event yields state: [transactionResource: transactionResource, isButtonVisible: false]",
      build: () => receiptScreenBloc,
      act: (bloc) {
        Transaction transaction = _transactionResource.transaction.update(status: Status(name: "name", code: 200));
        _transactionResource = _transactionResource.update(transaction: transaction);

        bloc.add(TransactionChanged(transactionResource: _transactionResource));
      },
      expect: () => [_baseState.update(transactionResource: _transactionResource, isButtonVisible: false)]
    );
  });
}