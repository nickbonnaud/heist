import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'account.dart';
import 'profile.dart';
import '../status.dart';

@immutable
class Customer extends Equatable {
  final String identifier;
  final String email;
  final Profile profile;
  final Account account;
  final Status status;

  Customer({
    required this.identifier,
    required this.email,
    required this.profile,
    required this.account,
    required this.status,
  });

  Customer.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      email = json['email'],
      profile = json['profile'] != null 
        ? Profile.fromJson(json: json['profile']) 
        : Profile.empty(),
      account = Account.fromJson(json: json['account']),
      status = Status.fromJson(json: json['status']);

  Customer update({
    String? email,
    Profile? profile,
    Account? account,
    Status? status,
  }) => Customer(
    identifier: this.identifier,
    email: email ?? this.email,
    profile: profile ?? this.profile,
    account: account ?? this.account,
    status: status ?? this.status,
  );

  @override
  List<Object> get props => [identifier, email, profile, account, status];

  @override
  String toString() => 'Customer { identifier: $identifier, email: $email, profile: $profile, account: $account, status: $status }';
}
