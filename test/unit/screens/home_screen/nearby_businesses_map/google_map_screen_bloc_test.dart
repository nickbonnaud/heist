import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/screens/home_screen/widgets/nearby_businesses_map/widgets/google_map_screen/bloc/google_map_screen_bloc.dart';

class MockBusiness extends Mock implements Business {}

void main() {
  group("Google Map Screen Bloc Tests", () {
    late GoogleMapScreenBloc googleMapScreenBloc;
    
    late Business _business;

    setUp(() {
      googleMapScreenBloc = GoogleMapScreenBloc();
    });

    tearDown(() {
      googleMapScreenBloc.close();
    });

    test("Initial state of GoogleMapScreenBloc is GoogleMapScreenState.initial()", () {
      expect(googleMapScreenBloc.state, GoogleMapScreenState.initial());
    });

    blocTest<GoogleMapScreenBloc, GoogleMapScreenState>(
      "GoogleMapScreenBloc Tapped event yields state: [screenCoordinate: coords, business: business]",
      build: () => googleMapScreenBloc,
      act: (bloc) {
        _business = MockBusiness();
        bloc.add(Tapped(screenCoordinate: ScreenCoordinate(x: 1, y: 1), business: _business));
      },
      expect: () => [GoogleMapScreenState(screenCoordinate: ScreenCoordinate(x: 1, y: 1), business: _business)]
    );

    blocTest<GoogleMapScreenBloc, GoogleMapScreenState>(
      "GoogleMapScreenBloc Reset event yields state: GoogleMapScreenState.initial()",
      build: () => googleMapScreenBloc,
      seed: () {
        _business = MockBusiness();
        return GoogleMapScreenState(screenCoordinate: ScreenCoordinate(x: 1, y: 1), business: _business);
      },
      act: (bloc) {
        _business = MockBusiness();
        bloc.add(Reset());
      },
      expect: () => [GoogleMapScreenState.initial()]
    );
  });
}