import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/layout_screen/bloc/side_menu_bloc.dart';

void main() {
  group("Side Menu Bloc Tests", () {
    late SideMenuBloc sideMenuBloc;
    late SideMenuState _baseState;

    setUp(() {
      sideMenuBloc = SideMenuBloc();
      _baseState = sideMenuBloc.state;
    });

    tearDown(() {
      sideMenuBloc.close();
    });

    test("Initial state of SideMenuBloc is SideMenuState.initial()", () {
      expect(sideMenuBloc.state, SideMenuState.initial());
    });

    blocTest<SideMenuBloc, SideMenuState>(
      "SideMenuBloc MenuStatusChanged event yields state: [menuOpen: true, buttonVisible: !buttonVisible]",
      build: () => sideMenuBloc,
      act: (bloc) => bloc.add(MenuStatusChanged(menuOpen: true)),
      expect: () => [_baseState.update(menuOpened: true, buttonVisible: false)]
    );

    blocTest<SideMenuBloc, SideMenuState>(
      "SideMenuBloc ButtonVisibilityChanged event yields state: [buttonVisible: true]",
      build: () => sideMenuBloc,
      act: (bloc) => bloc.add(ButtonVisibilityChanged(isVisible: true)),
      expect: () => [_baseState.update( buttonVisible: true)]
    );
  });
}