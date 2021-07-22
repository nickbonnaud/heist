import 'package:equatable/equatable.dart';
import 'package:heist/screens/tutorial_screen/bloc/tutorial_screen_bloc.dart';

class Tutorial extends Equatable {
  final TutorialCardType type;
  final String key;
  final String header;
  final String body;
  final String? artboard;
  final bool hasInitialAnimation;
  final bool dismissed;

  Tutorial({
    required this.type,
    required this.key,
    required this.header,
    required this.body,
    this.artboard,
    required this.hasInitialAnimation,
    required this.dismissed
  });

  Tutorial update({required bool dismissed}) => Tutorial(
    type: this.type,
    key: this.key,
    header: this.header,
    body: this.body,
    artboard: this.artboard,
    hasInitialAnimation: this.hasInitialAnimation,
    dismissed: dismissed
  );
  
  @override
  List<Object?> get props => [type, key, header, body, artboard, hasInitialAnimation, dismissed];

  @override
  String toString() => 'Tutorial { type: $type, key: $key header: $header, body: $body, artboard: $artboard, hasInitialAnimation: $hasInitialAnimation, dismissed: $dismissed }';
}