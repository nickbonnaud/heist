import 'package:equatable/equatable.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/models/customer/status.dart';

class Customer extends Equatable {
  final String identifier;
  final String email;
  final Profile profile;
  final Status status;
  final String error;

  Customer({this.identifier, this.email, this.profile, this.status, this.error});

  Customer.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      email = json['email'],
      profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      status = Status.fromJson(json['status']),
      error = "";

  Customer.withError(String error)
    : identifier = null,
      email = null,
      profile = null,
      status = null,
      error = error;

  Customer update({
    String identifier,
    String email,
    Profile profile,
    Status status,
  }) {
    return _copyWith(
      identifier: identifier,
      email: email,
      profile: profile,
      status: status
    );
  }
  
  Customer _copyWith({
    String identifier,
    String email,
    Profile profile,
    Status status,

  }) {
    return Customer(
      identifier: identifier ?? this.identifier,
      email: email ?? this.email,
      profile: profile ?? this.profile,
      status: status ?? this.status,
      error: ''
    );

  }

  @override
  List<Object> get props => [identifier, email, profile, status, error];

  @override
  String toString() => 'Customer { identifier: $identifier, email: $email, profile: $profile, status: $status, error: $error }';
}
