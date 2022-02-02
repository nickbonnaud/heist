import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Authentication Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late CustomerBloc customerBloc;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
      registerFallbackValue(CustomerAuthenticated());
      authenticationRepository = MockAuthenticationRepository();
      customerBloc = MockCustomerBloc();
      when(() => customerBloc.add(any(that: isA<CustomerEvent>())))
        .thenReturn(null);
      authenticationBloc = AuthenticationBloc(authenticationRepository: authenticationRepository, customerBloc: customerBloc);
    });

    tearDown(() {
      authenticationBloc.close();
    });

    test("Initial state of Authentication Bloc is Unknown", () {
      expect(authenticationBloc.state, isA<Unknown>());
    });

    test("Authentication Bloc has isAuthenticated getter", () {
      expect(authenticationBloc.isAuthenticated, false);
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Authentication Bloc Init event checks if customer logged in.", 
      build: () => authenticationBloc,
      act: (bloc) {
        when(() => authenticationRepository.isSignedIn()).thenAnswer((_) async => true);
        bloc.add(InitAuthentication());
      },
      verify: (_) {
        verify(() => authenticationRepository.isSignedIn()).called(1);
      }
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Authentication Bloc Init event yields Authenticated if customer logged in.", 
      build: () => authenticationBloc,
      act: (bloc) {
        when(() => authenticationRepository.isSignedIn()).thenAnswer((_) async => true);
        bloc.add(InitAuthentication());
      },
      expect: () => [isA<Authenticated>()]
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Authentication Bloc Init event yields calls customerBloc.add if customer logged in.", 
      build: () => authenticationBloc,
      act: (bloc) {
        when(() => authenticationRepository.isSignedIn()).thenAnswer((_) async => true);
        bloc.add(InitAuthentication());
      },
      verify: (_) {
        verify(() => customerBloc.add(any(that: isA<CustomerEvent>()))).called(1);
      }
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Authentication Bloc Init event yields Unauthenticated if customer not logged in.", 
      build: () => authenticationBloc,
      act: (bloc) {
        when(() => authenticationRepository.isSignedIn()).thenAnswer((_) async => false);
        bloc.add(InitAuthentication());
      },
      expect: () => [isA<Unauthenticated>()]
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Authentication Bloc LoggedIn event yields Authenticated", 
      build: () => authenticationBloc,
      act: (bloc) {
        bloc.add(LoggedIn(customer: MockCustomer()));
      },
      expect: () => [isA<Authenticated>()]
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Authentication Bloc LoggedIn event calls customerBloc.add", 
      build: () => authenticationBloc,
      act: (bloc) {
        bloc.add(LoggedIn(customer: MockCustomer()));
      },
      verify: (_) {
        verify(() => customerBloc.add(any(that: isA<CustomerEvent>()))).called(1);
      }
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Authentication Bloc LoggedOut event yields Unauthenticated", 
      build: () => authenticationBloc,
      act: (bloc) {
        bloc.add(LoggedOut());
      },
      expect: () => [isA<Unauthenticated>()]
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "Authentication Bloc LoggedOut event customerBloc.add", 
      build: () => authenticationBloc,
      act: (bloc) {
        bloc.add(LoggedOut());
      },
      verify: (_) {
        verify(() => customerBloc.add(any(that: isA<CustomerEvent>()))).called(1);
      }
    );
  });
}