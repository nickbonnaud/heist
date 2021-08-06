import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';

void main() {
  group("Default App Bar Bloc Tests", () {
    late DefaultAppBarBloc defaultAppBarBloc;
    late DefaultAppBarState _baseState;
    
    setUp(() {
      defaultAppBarBloc = DefaultAppBarBloc();
      _baseState = defaultAppBarBloc.state;
    });

    tearDown(() {
      defaultAppBarBloc.close();
    });

    test("Initial state of DefaultAppBarBloc is DefaultAppBarState.initial()", () {
      expect(defaultAppBarBloc.state, DefaultAppBarState.initial());
    });

    blocTest<DefaultAppBarBloc, DefaultAppBarState>(
      "DefaultAppBarBloc Rotate event changes state: [isRotated: true]",
      build: () => defaultAppBarBloc,
      act: (bloc) => bloc.add(Rotate()),
      expect: () => [_baseState.update(isRotated: true)]
    );

    blocTest<DefaultAppBarBloc, DefaultAppBarState>(
      "DefaultAppBarBloc Reset event changes state: [isRotated: false]",
      build: () => defaultAppBarBloc,
      seed: () => _baseState.update(isRotated: true),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isRotated: false)]
    );
  });
}