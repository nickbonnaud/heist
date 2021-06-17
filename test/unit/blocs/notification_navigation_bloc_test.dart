import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';

class MockTransactionResource extends Mock implements TransactionResource {}

void main() {
  group("Notification Navigation Bloc Tests", () {
    late NotificationNavigationBloc notificationNavigationBloc;

    late NotificationNavigationState _baseState;
    late TransactionResource _argument;

    setUp(() {
      notificationNavigationBloc = NotificationNavigationBloc();
      _baseState = notificationNavigationBloc.state;
    });

    tearDown(() {
      notificationNavigationBloc.close();
    });

    test("Initial state of NotificationNavigationBloc is NotificationNavigationState.empty()", () {
      expect(notificationNavigationBloc.state, NotificationNavigationState.empty());
    });

    blocTest<NotificationNavigationBloc, NotificationNavigationState>(
      "NotificationNavigationBloc NavigateTo event yields state: [route: event.route, arguments: event.arguments]",
      build: () => notificationNavigationBloc,
      act: (bloc) {
        _argument = MockTransactionResource();
        bloc.add(NavigateTo(route: "route", arguments: _argument));
      },
      expect: () => [_baseState.update(route: "route", arguments: _argument)]
    );

    blocTest<NotificationNavigationBloc, NotificationNavigationState>(
      "NotificationNavigationBloc ResetFromNotification event yields state: [route: null, arguments: null]",
      build: () => notificationNavigationBloc,
      seed: () {
        _argument = MockTransactionResource();
        return _baseState.update(route: "route", arguments: _argument);
      },
      act: (bloc) => bloc.add(ResetFromNotification()),
      expect: () => [NotificationNavigationState.empty()]
    );
  });
}