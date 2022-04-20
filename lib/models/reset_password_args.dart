import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ResetPasswordArgs extends Equatable {
  final String email;
  final String? resetCode;

  const ResetPasswordArgs({required this.email, this.resetCode});

  ResetPasswordArgs update({String? resetCode}) => ResetPasswordArgs(
    email: email,
    resetCode: resetCode ?? this.resetCode
  );
  
  @override
  List<Object?> get props => [email, resetCode];

  @override
  String toString() => "ResetPasswordArgs { email: $email, resetCode: $resetCode }";
}