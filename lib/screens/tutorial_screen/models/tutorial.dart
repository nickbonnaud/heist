import 'package:equatable/equatable.dart';
import 'package:heist/screens/tutorial_screen/bloc/tutorial_screen_bloc.dart';

class Tutorial extends Equatable {
  final TutorialCardType type;
  final String header;
  final String body;
  final String artboard;
  final bool hasInitialAnimation;
  final bool dismissed;

  Tutorial({this.type, this.header, this.body, this.artboard, this.hasInitialAnimation, this.dismissed});

  Tutorial update({
    TutorialCardType type,
    String header,
    String body,
    String artboard,
    bool hasInitialAnimation,
    bool dismissed
  }) {
    return _copyWith(
      type: type,
      header: header,
      body: body,
      artboard: artboard,
      hasInitialAnimation: hasInitialAnimation,
      dismissed: dismissed
    );
  }
  
  Tutorial _copyWith({
    TutorialCardType type,
    String header,
    String body,
    String artboard,
    bool hasInitialAnimation,
    bool dismissed
  }) {
    return Tutorial(
      type: type ?? this.type,
      header: header ?? this.header,
      body: body ?? this.body,
      artboard: artboard ?? this.artboard,
      hasInitialAnimation: hasInitialAnimation ?? this.hasInitialAnimation,
      dismissed: dismissed ?? this.dismissed
    );
  }
  
  @override
  List<Object> get props => [type, header, body, artboard, hasInitialAnimation, dismissed];

  @override
  String toString() => 'Tutorial { type: $type, header: $header, body: $body, artboard: $artboard, hasInitialAnimation: $hasInitialAnimation, dismissed: $dismissed }';
}