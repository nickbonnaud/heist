import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/profile_setup_screen/widgets/cards/setup_tip_screen.dart/bloc/setup_tip_card_bloc.dart';

class MockAccountRepository extends Mock implements AccountRepository{}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Setup Tip Card Bloc Tests", () {
    late AccountRepository accountRepository;
    late CustomerBloc customerBloc;

    late SetupTipCardBloc setupTipCardBloc;
    late SetupTipCardState _baseState;

    setUp(() {
      registerFallbackValue(CustomerUpdated(customer: MockCustomer()));
      accountRepository = MockAccountRepository();
      customerBloc = MockCustomerBloc();

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
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(TipRateChanged(tipRate: 20)),
      expect: () => [_baseState.update(isTipRateValid: true)]
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc QuickTipRateChanged event yields state: [isQuickTipRateValid: true]",
      build: () => setupTipCardBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(QuickTipRateChanged(quickTipRate: 10)),
      expect: () => [_baseState.update(isQuickTipRateValid: true)]
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => setupTipCardBloc,
      act: (bloc) {
        when(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted(accountIdentifier: faker.guid.guid(), tipRate: 18, quickTipRate: 12));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc Submitted event calls accountRepository.update && customerBloc.add",
      build: () => setupTipCardBloc,
      act: (bloc) {
        when(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted(accountIdentifier: faker.guid.guid(), tipRate: 18, quickTipRate: 12));
      },
      verify: (_) {
        verify(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate"))).called(1);
        verify(() => customerBloc.add(any(that: isA<CustomerUpdated>()))).called(1);
      }
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => setupTipCardBloc,
      act: (bloc) {
        when(() => accountRepository.update(accountIdentifier: any(named: "accountIdentifier"), tipRate: any(named: "tipRate"), quickTipRate: any(named: "quickTipRate")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(Submitted(accountIdentifier: faker.guid.guid(), tipRate: 18, quickTipRate: 12));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<SetupTipCardBloc, SetupTipCardState>(
      "SetupTipCardBloc Reset event on yields state: [isSuccess: false, errorMessage: '']",
      build: () => setupTipCardBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: "error"),
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}