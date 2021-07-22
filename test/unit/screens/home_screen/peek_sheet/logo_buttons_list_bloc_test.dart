import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/screens/home_screen/widgets/home_screen_body/widgets/peek_sheet/widgets/logo_buttons_list/bloc/logo_buttons_list_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}
class MockActiveLocationBloc extends Mock implements ActiveLocationBloc {}
class MockNearbyBusinessesBloc extends Mock implements NearbyBusinessesBloc {}
class MockTransactionResource extends Mock implements TransactionResource {}
class MockActiveLocation extends Mock implements ActiveLocation {}
class MockBusiness extends Mock implements Business {}

void main() {
  group("Logo Buttons List Bloc Tests", () {
    late OpenTransactionsBloc openTransactionsBloc;
    late ActiveLocationBloc activeLocationBloc;
    late NearbyBusinessesBloc nearbyBusinessesBloc;

    late LogoButtonsListBloc logoButtonsListBloc;
    late LogoButtonsListState _baseState;

    setUp(() {
      openTransactionsBloc = MockOpenTransactionsBloc();
      whenListen(openTransactionsBloc, Stream<OpenTransactionsState>.fromIterable([]));

      activeLocationBloc = MockActiveLocationBloc();
      whenListen(activeLocationBloc, Stream<ActiveLocationState>.fromIterable([]));

      nearbyBusinessesBloc = MockNearbyBusinessesBloc();
      whenListen(nearbyBusinessesBloc, Stream<NearbyBusinessesState>.fromIterable([]));

      logoButtonsListBloc = LogoButtonsListBloc(openTransactionsBloc: openTransactionsBloc, activeLocationBloc: activeLocationBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, numberOpenTransactions: 3, numberActiveLocations: 2, numberNearbyLocations: 4);
      _baseState = logoButtonsListBloc.state;
    });

    tearDown(() {
      logoButtonsListBloc.close();
    });

    test("LogoButtonsListBloc initial state is LogoButtonsListState.initial()", () {
      expect(logoButtonsListBloc.state, LogoButtonsListState.initial(numberOpenTransactions: 3, numberActiveLocations: 2, numberNearbyLocations: 4));
    });

    blocTest<LogoButtonsListBloc, LogoButtonsListState>(
      "LogoButtonsListBloc NumberOpenTransactionsChanged event yields state: [numberOpenTransactions: 1]",
      build: () => logoButtonsListBloc,
      act: (bloc) => bloc.add(NumberOpenTransactionsChanged(numberOpenTransactions: 1)),
      expect: () => [_baseState.update(numberOpenTransactions: 1)]
    );

    blocTest<LogoButtonsListBloc, LogoButtonsListState>(
      "LogoButtonsListBloc openTransactionsBloc.stream yields state: [numberOpenTransactions: 1]",
      build: () {
        whenListen(openTransactionsBloc, Stream<OpenTransactionsState>.fromIterable([OpenTransactionsLoaded(transactions: [MockTransactionResource()])]));
        return LogoButtonsListBloc(openTransactionsBloc: openTransactionsBloc, activeLocationBloc: activeLocationBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, numberOpenTransactions: 3, numberActiveLocations: 2, numberNearbyLocations: 4);
      },
      expect: () => [_baseState.update(numberOpenTransactions: 1)]
    );

    blocTest<LogoButtonsListBloc, LogoButtonsListState>(
      "LogoButtonsListBloc NumberActiveLocationsChanged event yields state: [numberActiveLocations: 5]",
      build: () => logoButtonsListBloc,
      act: (bloc) => bloc.add(NumberActiveLocationsChanged(numberActiveLocations: 5)),
      expect: () => [_baseState.update(numberActiveLocations: 5)]
    );

    blocTest<LogoButtonsListBloc, LogoButtonsListState>(
      "LogoButtonsListBloc activeLocationBloc.stream yields state: [numberActiveLocations: 5]",
      build: () {
        whenListen(activeLocationBloc, Stream<ActiveLocationState>.fromIterable([ActiveLocationState(activeLocations: List<ActiveLocation>.generate(5, (_) => MockActiveLocation()), addingLocations: [], removingLocations: [], errorMessage: "")]));
        return LogoButtonsListBloc(openTransactionsBloc: openTransactionsBloc, activeLocationBloc: activeLocationBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, numberOpenTransactions: 3, numberActiveLocations: 2, numberNearbyLocations: 4);
      },
      expect: () => [_baseState.update(numberActiveLocations: 5)]
    );

    blocTest<LogoButtonsListBloc, LogoButtonsListState>(
      "LogoButtonsListBloc NumberNearbyBusinessesChanged event yields state: [numberNearbyLocations: 10]",
      build: () => logoButtonsListBloc,
      act: (bloc) => bloc.add(NumberNearbyBusinessesChanged(numberNearbyBusinesses: 10)),
      expect: () => [_baseState.update(numberNearbyLocations: 10)]
    );

    blocTest<LogoButtonsListBloc, LogoButtonsListState>(
      "LogoButtonsListBloc nearbyBusinessesBloc.stream yields state: [numberNearbyLocations: 10]",
      build: () {
        whenListen(nearbyBusinessesBloc, Stream<NearbyBusinessesState>.fromIterable([NearbyBusinessLoaded(preMarkers: [], businesses: List<Business>.generate(10, (_) => MockBusiness()))]));
        return LogoButtonsListBloc(openTransactionsBloc: openTransactionsBloc, activeLocationBloc: activeLocationBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, numberOpenTransactions: 3, numberActiveLocations: 2, numberNearbyLocations: 4);
      },
      expect: () => [_baseState.update(numberNearbyLocations: 10)]
    );
  });
}