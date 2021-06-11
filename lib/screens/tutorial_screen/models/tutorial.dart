import 'package:equatable/equatable.dart';
import 'package:heist/screens/tutorial_screen/bloc/tutorial_screen_bloc.dart';

class Tutorial extends Equatable {
  final TutorialCardType type;
  final String header;
  final String body;
  final String? artboard;
  final bool hasInitialAnimation;
  final bool dismissed;

  Tutorial({
    required this.type,
    required this.header,
    required this.body,
    this.artboard,
    required this.hasInitialAnimation,
    required this.dismissed
  });

  Tutorial update({
    TutorialCardType? type,
    String? header,
    String? body,
    String? artboard,
    bool? hasInitialAnimation,
    bool? dismissed
  }) => Tutorial(
    type: type ?? this.type,
    header: header ?? this.header,
    body: body ?? this.body,
    artboard: artboard ?? this.artboard,
    hasInitialAnimation: hasInitialAnimation ?? this.hasInitialAnimation,
    dismissed: dismissed ?? this.dismissed
  );
  
  @override
  List<Object?> get props => [type, header, body, artboard, hasInitialAnimation, dismissed];

  @override
  String toString() => 'Tutorial { type: $type, header: $header, body: $body, artboard: $artboard, hasInitialAnimation: $hasInitialAnimation, dismissed: $dismissed }';
}