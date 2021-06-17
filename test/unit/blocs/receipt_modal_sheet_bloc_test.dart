import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';

void main() {
  group("Receipt Modal Sheet Bloc Tests", () {
    late ReceiptModalSheetBloc receiptModalSheetBloc;
    
    late ReceiptModalSheetState _baseState;

    setUp(() {
      receiptModalSheetBloc = ReceiptModalSheetBloc();
      _baseState = receiptModalSheetBloc.state;
    });

    tearDown(() {
      receiptModalSheetBloc.close();
    });

    test("Initial state of ReceiptModalSheetBloc is ReceiptModalSheetState.initial()", () {
      expect(receiptModalSheetBloc.state, ReceiptModalSheetState.initial());
    });

    blocTest<ReceiptModalSheetBloc, ReceiptModalSheetState>(
      "ReceiptModalSheetBloc Toggle event yields state: [!state.visible]", 
      build: () => receiptModalSheetBloc,
      act: (bloc) => bloc.add(Toggle()),
      expect: () => [_baseState.update(visible: !_baseState.visible)]
    );
  });
}