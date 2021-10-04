import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/home_screen/blocs/side_drawer_bloc/side_drawer_bloc.dart';

void main() {
  group("Side Drawer Bloc Tests", () {
    late SideDrawerBloc sideDrawerBloc;
    late SideDrawerState _baseState;
    
    setUp(() {
      sideDrawerBloc = SideDrawerBloc();
      _baseState = sideDrawerBloc.state;
    });

    tearDown(() {
      sideDrawerBloc.close();
    });

    test("Initial state of SideDrawerBloc is SideDrawerState.initial()", () {
      expect(sideDrawerBloc.state, SideDrawerState.initial());
    });

    blocTest<SideDrawerBloc, SideDrawerState>(
      "SideDrawerBloc DrawerStatusChanged event yields state: [menuOpened: true, buttonVisible: false]",
      build: () => sideDrawerBloc,
      act: (bloc) => bloc.add(DrawerStatusChanged(menuOpen: true)),
      expect: () => [_baseState.update(menuOpened: true, buttonVisible: false)]
    );

    blocTest<SideDrawerBloc, SideDrawerState>(
      "SideDrawerBloc ButtonVisibilityChanged event yields state: [buttonVisible: false]",
      build: () => sideDrawerBloc,
      act: (bloc) => bloc.add(ButtonVisibilityChanged(isVisible: false)),
      expect: () => [_baseState.update(buttonVisible: false)]
    );
  });
}