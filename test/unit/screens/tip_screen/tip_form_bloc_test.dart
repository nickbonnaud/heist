import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/tip_screen/bloc/tip_form_bloc.dart';

class MockAccountRepository extends Mock implements AccountRepository {}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Tip Form Bloc Tests", () {
    late AccountRepository accountRepository;
    late CustomerBloc customerBloc;

    late TipFormBloc tipFormBloc;
    late TipFormState _baseState;

    setUp(() {
      registerFallbackValue(CustomerUpdated(customer: MockCustomer()));
      accountRepository = MockAccountRepository();
      customerBloc = MockCustomerBloc();

      tipFormBloc = TipFormBloc(accountRepository: accountRepository, customerBloc: customerBloc);
      _baseState = tipFormBloc.state;
    });

    tearDown(() {
      tipFormBloc.close();
    });

    test("Initial state of TipFormBloc is TipFormState.initial()", () {
      expect(tipFormBloc.state, TipFormState.initial());
    });

    blocTest<TipFormBloc, TipFormState>(
      "TipFormBloc TipRateChanged event yields state: [isTipRateValid: true]",
      build: () => tipFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(TipRateChanged(tipRate: 18)),
      expect: () => [_baseState.update(isTipRateValid: true)]
    );

    blocTest<TipFormBloc, TipFormState>(
      "TipFormBloc QuickTipRateChanged event yields state: [isQuickTipRateValid: true]",
      build: () => tipFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(QuickTipRateChanged(quickTipRate: 5)),
      expect: () => [_baseState.update(isQuickTipRateValid: true)]
    );

    blocTest<TipFormBloc, TipFormState>(
      "TipFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => tipFormBloc,
      act: (bloc) {
        when(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted(accountIdentifier: faker.guid.guid(), tipRate: 18, quickTipRate: 5));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<TipFormBloc, TipFormState>(
      "TipFormBloc Submitted event calls accountRepository.update && customerBloc.add",
      build: () => tipFormBloc,
      act: (bloc) {
        when(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted(accountIdentifier: faker.guid.guid(), tipRate: 18, quickTipRate: 5));
      },
      verify: (_) {
        verify(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate"))).called(1);
        verify(() => customerBloc.add(any(that: isA<CustomerUpdated>()))).called(1);
      }
    );

    blocTest<TipFormBloc, TipFormState>(
      "TipFormBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => tipFormBloc,
      act: (bloc) {
        when(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(Submitted(accountIdentifier: faker.guid.guid(), tipRate: 18, quickTipRate: 5));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<TipFormBloc, TipFormState>(
      "TipFormBloc Reset event yields state: [isSuccess: false, errorMessage: ""]",
      build: () => tipFormBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: "error"),
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(isSuccess: false, errorMessage: '')]
    );
  });
}