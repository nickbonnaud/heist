import 'package:equatable/equatable.dart';

import 'account.dart';
import 'profile.dart';
import 'status.dart';

class Customer extends Equatable {
  final String identifier;
  final String email;
  final Profile profile;
  final Account account;
  final Status status;
  final String error;

  Customer({
    this.identifier,
    this.email,
    this.profile,
    this.account,
    this.status,
    this.error
  });

  Customer.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      email = json['email'],
      profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      account = Account.fromJson(json['account']),
      status = Status.fromJson(json['status']),
      error = "";

  Customer.withError(String error)
    : identifier = null,
      email = null,
      profile = null,
      account = null,
      status = null,
      error = error;

  Customer update({
    String identifier,
    String email,
    Profile profile,
    Account account,
    Status status,
  }) {
    return _copyWith(
      identifier: identifier,
      email: email,
      profile: profile,
      account: account,
      status: status
    );
  }
  
  Customer _copyWith({
    String identifier,
    String email,
    Profile profile,
    Account account,
    Status status,

  }) {
    return Customer(
      identifier: identifier ?? this.identifier,
      email: email ?? this.email,
      profile: profile ?? this.profile,
      account: account ?? this.account,
      status: status ?? this.status,
      error: ''
    );

  }

  @override
  List<Object> get props => [identifier, email, profile, account, status, error];

  @override
  String toString() => 'Customer { identifier: $identifier, email: $email, profile: $profile, account: $account, status: $status, error: $error }';
}
