import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/repositories/refund_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/refunds_screen/bloc/refunds_screen_bloc.dart';
import 'package:heist/screens/refunds_screen/widgets/filter_button/filter_button.dart';
import 'package:mocktail/mocktail.dart';

class MockRefundRepository extends Mock implements RefundRepository {}
class MockRefundResource extends Mock implements RefundResource {}

void main() {
  group("Refunds Screen Bloc Tests", () {
    late RefundRepository refundRepository;

    late RefundsScreenBloc refundsScreenBloc;
    late RefundsScreenState _baseState;

    setUp(() {
      refundRepository = MockRefundRepository();
      refundsScreenBloc = RefundsScreenBloc(refundRepository: refundRepository);
      _baseState = refundsScreenBloc.state;
    });

    tearDown(() {
      refundsScreenBloc.close();
    });

    List<RefundResource> _createRefunds({int numRefunds = 4}) {
      return List<RefundResource>.generate(numRefunds, (_) => MockRefundResource());
    }

    RefundsLoaded _createRefundsLoadedState() {
      return RefundsLoaded(
        refunds: _createRefunds(),
        paginating: false,
        hasReachedEnd: false,
        currentQuery: Option.all,
        queryParams: "",
        nextUrl: "next"
      );
    }
    
    test("Initial state of RefundsScreenBloc is Uninitialized()", () {
      expect(refundsScreenBloc.state, Uninitialized());
    });

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchAllRefunds(reset: false) when currentState: Uninitialized event yields state: [Loading()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchAll())
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "nex"));

        bloc.add(FetchAllRefunds(reset: false));
      },
      expect: () => [isA<Loading>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchAllRefunds(reset: true) event yields state: [Loading()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchAll())
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "nex"));

        bloc.add(FetchAllRefunds(reset: true));
      },
      expect: () => [isA<Loading>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchAllRefunds(reset: false) when currentState: RefundsLoaded event yields state: [Loading()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      seed: () => _createRefundsLoadedState(),
      act: (bloc) {
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "nex"));

        bloc.add(FetchAllRefunds(reset: false));
      },
      expect: () => [isA<RefundsLoaded>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchAllRefunds() calls refundRepository.fetchAll()",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchAll())
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "nex"));

        bloc.add(FetchAllRefunds(reset: false));
      },
      verify: (_) {
        verify(() => refundRepository.fetchAll()).called(1);
      }
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc _fetchUnitialized on fail yields state: [Loading()], [FetchFailure()]",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchAll())
          .thenThrow(ApiException(error: "error"));

        bloc.add(FetchAllRefunds(reset: false));
      },
      expect: () => [isA<Loading>(), isA<FetchFailure>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc _fetchMore on fail yields state: [Loading()], [FetchFailure()]",
      build: () => refundsScreenBloc,
      seed: () => _createRefundsLoadedState(),
      act: (bloc) {
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(FetchAllRefunds(reset: false));
      },
      expect: () => [isA<RefundsLoaded>(), isA<FetchFailure>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundsByDateRange(reset: true) yields state: [Loading()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchAll(dateRange: any(named: "dateRange")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(),next: "next"));

        bloc.add(FetchRefundsByDateRange(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()), reset: true));
      },
      expect: () => [isA<Loading>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundsByDateRange(reset: true) calls refundRepository.fetchAll(dateRange)",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchAll(dateRange: any(named: "dateRange")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(),next: "next"));

        bloc.add(FetchRefundsByDateRange(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()), reset: true));
      },
      verify: (_) {
        verify(() => refundRepository.fetchAll(dateRange: any(named: "dateRange"))).called(1);
      }
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundsByDateRange(reset: false) yields state: [RefundsLoaded()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      seed: () => _createRefundsLoadedState(),
      act: (bloc) {
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(),next: "next"));

        bloc.add(FetchRefundsByDateRange(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()), reset: false));
      },
      expect: () => [isA<RefundsLoaded>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundByIdentifier(reset: true) yields state: [Loading()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchByIdentifier(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchRefundByIdentifier(identifier: faker.guid.guid(), reset: true));
      },
      expect: () => [isA<Loading>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundByIdentifier(reset: true) calls refundRepository.fetchByIdentifier()",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchByIdentifier(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchRefundByIdentifier(identifier: faker.guid.guid(), reset: true));
      },
      verify: (_) {
        verify(() => refundRepository.fetchByIdentifier(identifier: any(named: "identifier"))).called(1);
      }
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundByIdentifier(reset: false) yields state: [RefundsLoaded()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      seed: () => _createRefundsLoadedState(),
      act: (bloc) {
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchRefundByIdentifier(identifier: faker.guid.guid(), reset: false));
      },
      expect: () => [isA<RefundsLoaded>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundByBusiness(reset: true) yields state: [Loading()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchByBusiness(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchRefundByBusiness(identifier: faker.guid.guid(), reset: true));
      },
      expect: () => [isA<Loading>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundByBusiness(reset: true) calls fetchByBusiness()",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchByBusiness(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchRefundByBusiness(identifier: faker.guid.guid(), reset: true));
      },
      verify: (_) {
        verify(() => refundRepository.fetchByBusiness(identifier: any(named: "identifier"))).called(1);
      }
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundByBusiness(reset: false) yields state: [RefundsLoaded()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      seed: () => _createRefundsLoadedState(),
      act: (bloc) {
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchRefundByBusiness(identifier: faker.guid.guid(), reset: false));
      },
      expect: () => [isA<RefundsLoaded>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundByTransaction(reset: true) yields state: [Loading()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchByTransactionIdentifier(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchRefundByTransaction(identifier: faker.guid.guid(), reset: true));
      },
      expect: () => [isA<Loading>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundByTransaction(reset: true) calls refundRepository.fetchByTransactionIdentifier()",
      build: () => refundsScreenBloc,
      act: (bloc) {
        when(() => refundRepository.fetchByTransactionIdentifier(identifier: any(named: "identifier")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchRefundByTransaction(identifier: faker.guid.guid(), reset: true));
      },
      verify: (_) {
        verify(() => refundRepository.fetchByTransactionIdentifier(identifier: any(named: "identifier"))).called(1);
      }
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchRefundByTransaction(reset: false) yields state: [RefundsLoaded()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      seed: () => _createRefundsLoadedState(),
      act: (bloc) {
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchRefundByTransaction(identifier: faker.guid.guid(), reset: false));
      },
      expect: () => [isA<RefundsLoaded>(), isA<RefundsLoaded>()]
    );

    blocTest<RefundsScreenBloc, RefundsScreenState>(
      "RefundsScreenBloc FetchMoreRefunds yields state: [RefundsLoaded()], [RefundsLoaded()]",
      build: () => refundsScreenBloc,
      seed: () => _createRefundsLoadedState(),
      act: (bloc) {
        when(() => refundRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: _createRefunds(), next: "next"));

        bloc.add(FetchMoreRefunds());
      },
      expect: () => [isA<RefundsLoaded>(), isA<RefundsLoaded>()]
    );
  });
}