import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/home_screen/blocs/side_drawer_bloc/side_drawer_bloc.dart';

void main() {
  group("Side Menu Bloc Tests", () {
    late SideDrawerBloc sideMenuBloc;
    late SideDrawerState _baseState;

    setUp(() {
      sideMenuBloc = SideDrawerBloc();
      _baseState = sideMenuBloc.state;
    });

    tearDown(() {
      sideMenuBloc.close();
    });

    test("Initial state of SideDrawerBloc is SideDrawerState.initial()", () {
      expect(sideMenuBloc.state, SideDrawerState.initial());
    });

    blocTest<SideDrawerBloc, SideDrawerState>(
      "SideDrawerBloc DrawerStatusChanged event yields state: [menuOpen: true, buttonVisible: !buttonVisible]",
      build: () => sideMenuBloc,
      act: (bloc) => bloc.add(DrawerStatusChanged(menuOpen: true)),
      expect: () => [_baseState.update(menuOpened: true, buttonVisible: false)]
    );

    blocTest<SideDrawerBloc, SideDrawerState>(
      "SideDrawerBloc ButtonVisibilityChanged event yields state: [buttonVisible: true]",
      build: () => sideMenuBloc,
      act: (bloc) => bloc.add(ButtonVisibilityChanged(isVisible: true)),
      expect: () => [_baseState.update( buttonVisible: true)]
    );
  });
}