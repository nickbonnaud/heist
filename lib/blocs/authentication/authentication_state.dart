part of 'authentication_bloc.dart';

@immutable
class AuthenticationState {
  final bool authenticated;
  final Customer customer;
  final bool loading;

  AuthenticationState({
    @required this.authenticated, 
    @required this.customer, 
    @required this.loading
  });

  factory AuthenticationState.initial() {
    return AuthenticationState(
      authenticated: false,
      customer: null,
      loading: true
    );
  }

  factory AuthenticationState.authenticated({@required Customer customer}) {
    return AuthenticationState(
      authenticated: true,
      customer: customer,
      loading: false
    );
  }

  factory AuthenticationState.unAuthenticated() {
    return AuthenticationState(
      authenticated: false,
      customer: null,
      loading: false
    );
  }

  AuthenticationState update({
    bool authenticated,
    Customer customer,
    bool loading
  }) {
    return _copyWith(
      authenticated: authenticated,
      customer: customer,
      loading: loading
    );
  }
  
  AuthenticationState _copyWith({
    bool authenticated,
    Customer customer,
    bool loading
  }) {
    return AuthenticationState(
      authenticated: authenticated ?? this.authenticated,
      customer: customer ?? this.customer,
      loading: loading ?? this.loading
    );
  }

  @override
  String toString() => 'AuthenticationState { authenticated: $authenticated, customer: $customer, loading: $loading }';
}