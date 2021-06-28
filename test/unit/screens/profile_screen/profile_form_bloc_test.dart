import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/profile_screen/bloc/profile_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Profile Form Bloc Tests", () {
    late ProfileRepository profileRepository;
    late CustomerBloc customerBloc;

    late ProfileFormBloc profileFormBloc;
    late ProfileFormState _baseState;

    setUp(() {
      registerFallbackValue(CustomerUpdated(customer: MockCustomer()));
      profileRepository = MockProfileRepository();
      customerBloc = MockCustomerBloc();

      profileFormBloc = ProfileFormBloc(profileRepository: profileRepository, customerBloc: customerBloc);
      _baseState = profileFormBloc.state;
    });

    tearDown(() {
      profileFormBloc.close();
    });

    test("Initial state of ProfileFormBloc is ProfileFormState.initial()", () {
      expect(profileFormBloc.state, ProfileFormState.initial());
    });

    blocTest<ProfileFormBloc, ProfileFormState>(
      "ProfileFormBloc FirstNameChanged event yields state: [isFirstNameValid: true]",
      build: () => profileFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(FirstNameChanged(firstName: faker.person.firstName())),
      expect: () => [_baseState.update(isFirstNameValid: true)]
    );

    blocTest<ProfileFormBloc, ProfileFormState>(
      "ProfileFormBloc LastNameChanged event yields state: [isLastNameValid: true]",
      build: () => profileFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(LastNameChanged(lastName: faker.person.lastName())),
      expect: () => [_baseState.update(isLastNameValid: true)]
    );

    blocTest<ProfileFormBloc, ProfileFormState>(
      "ProfileFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => profileFormBloc,
      act: (bloc) {
        when(() => profileRepository.update(firstName: any(named: "firstName"), lastName: any(named: "lastName"), profileIdentifier: any(named: "profileIdentifier")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);
        
        bloc.add(Submitted(firstName: faker.person.firstName(), lastName: faker.person.lastName(), profileIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<ProfileFormBloc, ProfileFormState>(
      "ProfileFormBloc Submitted event calls profileRepository.update && customerBloc.add",
      build: () => profileFormBloc,
      act: (bloc) {
        when(() => profileRepository.update(firstName: any(named: "firstName"), lastName: any(named: "lastName"), profileIdentifier: any(named: "profileIdentifier")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);
        
        bloc.add(Submitted(firstName: faker.person.firstName(), lastName: faker.person.lastName(), profileIdentifier: faker.guid.guid()));
      },
      verify: (_) {
        verify(() => profileRepository.update(firstName: any(named: "firstName"), lastName: any(named: "lastName"), profileIdentifier: any(named: "profileIdentifier"))).called(1);
        verify(() => customerBloc.add(any(that: isA<CustomerUpdated>()))).called(1);
      }
    );

    blocTest<ProfileFormBloc, ProfileFormState>(
      "ProfileFormBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => profileFormBloc,
      act: (bloc) {
        when(() => profileRepository.update(firstName: any(named: "firstName"), lastName: any(named: "lastName"), profileIdentifier: any(named: "profileIdentifier")))
          .thenThrow(ApiException(error: "error"));
        
        bloc.add(Submitted(firstName: faker.person.firstName(), lastName: faker.person.lastName(), profileIdentifier: faker.guid.guid()));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<ProfileFormBloc, ProfileFormState>(
      "ProfileFormBloc Reset event on yields state: [isSuccess: false, errorMessage: ""]",
      build: () => profileFormBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: "error"),
      act: (bloc) {        
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}