import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/profile_setup_screen/widgets/cards/profile_name_card/widgets/bloc/profile_name_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Profile Name Form Bloc Tests", () {
    late ProfileRepository profileRepository;
    late CustomerBloc customerBloc;

    late ProfileNameFormBloc profileNameFormBloc;
    late ProfileNameFormState _baseState;

    late String firstName;
    late String lastName;

    setUp(() {
      registerFallbackValue(CustomerUpdated(customer: MockCustomer()));
      profileRepository = MockProfileRepository();
      customerBloc = MockCustomerBloc();

      profileNameFormBloc = ProfileNameFormBloc(profileRepository: profileRepository, customerBloc: customerBloc);
      _baseState = profileNameFormBloc.state;
    });

    tearDown(() {
      profileNameFormBloc.close();
    });

    test("Initial state of ProfileNameFormBloc is ProfileNameFormState.initial()", () {
      expect(profileNameFormBloc.state, ProfileNameFormState.initial());
    });

    blocTest<ProfileNameFormBloc, ProfileNameFormState>(
      "ProfileNameFormBloc FirstNameChanged event yields state: [isFirstNameValid: true]",
      build: () => profileNameFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        firstName = faker.person.firstName();
        bloc.add(FirstNameChanged(firstName: firstName));
      },
      expect: () => [_baseState.update(firstName: firstName, isFirstNameValid: true)]
    );

    blocTest<ProfileNameFormBloc, ProfileNameFormState>(
      "ProfileNameFormBloc LastNameChanged event yields state: [isLastNameValid: true]",
      build: () => profileNameFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        lastName = faker.person.lastName();
        bloc.add(LastNameChanged(lastName: lastName));
      },
      expect: () => [_baseState.update(lastName: lastName, isLastNameValid: true)]
    );

    blocTest<ProfileNameFormBloc, ProfileNameFormState>(
      "ProfileNameFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => profileNameFormBloc,
      seed: () {
        firstName = faker.person.firstName();
        lastName = faker.person.lastName();
        _baseState = _baseState.update(firstName: firstName, lastName: lastName);
        return _baseState;
      },
      act: (bloc) {
        when(() => profileRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<ProfileNameFormBloc, ProfileNameFormState>(
      "ProfileNameFormBloc Submitted event calls profileRepository.store && customerBloc.add",
      build: () => profileNameFormBloc,
      seed: () {
        firstName = faker.person.firstName();
        lastName = faker.person.lastName();
        _baseState = _baseState.update(firstName: firstName, lastName: lastName);
        return _baseState;
      },
      act: (bloc) {
        when(() => profileRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);

        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => profileRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"))).called(1);
        verify(() => customerBloc.add(any(that: isA<CustomerUpdated>()))).called(1);
      }
    );

    blocTest<ProfileNameFormBloc, ProfileNameFormState>(
      "ProfileNameFormBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => profileNameFormBloc,
      seed: () {
        firstName = faker.person.firstName();
        lastName = faker.person.lastName();
        _baseState = _baseState.update(firstName: firstName, lastName: lastName);
        return _baseState;
      },
      act: (bloc) {
        when(() => profileRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName")))
          .thenThrow(const ApiException(error: "error"));

        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<ProfileNameFormBloc, ProfileNameFormState>(
      "ProfileNameFormBloc Reset event yields state: [isSuccess: false, errorMessage: ""]",
      build: () => profileNameFormBloc,
      seed: () {
        firstName = faker.person.firstName();
        lastName = faker.person.lastName();
        _baseState = _baseState.update(firstName: firstName, lastName: lastName, isSuccess: true, errorMessage: "error");
        return _baseState;
      },
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}