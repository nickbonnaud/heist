import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/profile_setup_screen/widgets/cards/setup_tip_screen.dart/bloc/setup_tip_card_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_data_generator.dart';

class MockAccountRepository extends Mock implements AccountRepository{}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Setup Tip Card Bloc Tests", () {
    late AccountRepository accountRepository;
    late CustomerBloc customerBloc;

    late SetupTipCardBloc setupTipCardBloc;
    late SetupTipCardState _baseState;

    late String tipRate;
    late String quickTipRate;

    setUp(() {
      registerFallbackValue(CustomerUpdated(customer: MockCustomer()));
      accountRepository = MockAccountRepository();

      Customer customer = MockDataGenerator().createCustomer();
      customerBloc = MockCustomerBloc();

      when(() => customerBloc.customer).thenReturn(customer);

      setupTipCardBloc = SetupTipCardBloc(accountRepository: accountRepository, customerBloc: customerBloc);
      _baseState = setupTipCardBloc.state;
    });

    tearDown(() {
      setupTipCardBloc.close();
    });

    test("Initial state of SetupTipCardBloc is SetupTipCardState.initial()", () {
      expect(setupTipCardBloc.state, SetupTipCardState.initial());
    });

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc TipRateChanged event yields state: [isTipRateValid: true]",
      build: () => setupTipCardBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        tipRate = '20';
        bloc.add(TipRateChanged(tipRate: tipRate));
      },
      expect: () => [_baseState.update(tipRate: tipRate, isTipRateValid: true)]
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc QuickTipRateChanged event yields state: [isQuickTipRateValid: true]",
      build: () => setupTipCardBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        quickTipRate = '10';
         bloc.add(QuickTipRateChanged(quickTipRate: quickTipRate));
      },
      expect: () => [_baseState.update(quickTipRate: quickTipRate, isQuickTipRateValid: true)]
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => setupTipCardBloc,
      seed: () {
        tipRate = '18';
        quickTipRate = '12';
        _baseState = _baseState.update(tipRate: tipRate, quickTipRate: quickTipRate);
        return _baseState;
      },
      act: (bloc) {
        when(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc Submitted event calls accountRepository.update && customerBloc.add",
      build: () => setupTipCardBloc,
      seed: () {
        tipRate = '18';
        quickTipRate = '12';
        _baseState = _baseState.update(tipRate: tipRate, quickTipRate: quickTipRate);
        return _baseState;
      },
      act: (bloc) {
        when(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate"))).called(1);
        verify(() => customerBloc.add(any(that: isA<CustomerUpdated>()))).called(1);
      }
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => setupTipCardBloc,
      seed: () {
        tipRate = '18';
        quickTipRate = '12';
        _baseState = _baseState.update(tipRate: tipRate, quickTipRate: quickTipRate);
        return _baseState;
      },
      act: (bloc) {
        when(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate")))
          .thenThrow(const ApiException(error: "error"));

        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc Reset event on yields state: [isSuccess: false, errorMessage: '']",
      build: () => setupTipCardBloc,
      seed: () {
        tipRate = '18';
        quickTipRate = '12';
        _baseState = _baseState.update(tipRate: tipRate, quickTipRate: quickTipRate, isSuccess: true, errorMessage: "error");
        return _baseState;
      },
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}