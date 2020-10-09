part of 'authentication_bloc.dart';

@immutable
class AuthenticationState {
  final bool authenticated;
  final Customer customer;
  final bool loading;
  final bool authCheckComplete;

  AuthenticationState({
    @required this.authenticated, 
    @required this.customer, 
    @required this.loading,
    @required this.authCheckComplete
  });

  factory AuthenticationState.initial() {
    return AuthenticationState(
      authenticated: false,
      customer: null,
      loading: true,
      authCheckComplete: false
    );
  }

  factory AuthenticationState.authenticated({@required Customer customer}) {
    return AuthenticationState(
      authenticated: true,
      customer: customer,
      loading: false,
      authCheckComplete: true
    );
  }

  factory AuthenticationState.unAuthenticated() {
    return AuthenticationState(
      authenticated: false,
      customer: null,
      loading: false,
      authCheckComplete: true
    );
  }

  AuthenticationState update({
    bool authenticated,
    Customer customer,
    bool loading,
    bool authCheckComplete
  }) {
    return _copyWith(
      authenticated: authenticated,
      customer: customer,
      loading: loading,
      authCheckComplete: authCheckComplete
    );
  }
  
  AuthenticationState _copyWith({
    bool authenticated,
    Customer customer,
    bool loading,
    bool authCheckComplete
  }) {
    return AuthenticationState(
      authenticated: authenticated ?? this.authenticated,
      customer: customer ?? this.customer,
      loading: loading ?? this.loading,
      authCheckComplete: authCheckComplete ?? this.authCheckComplete
    );
  }

  @override
  String toString() => 'AuthenticationState { authenticated: $authenticated, customer: $customer, loading: $loading, authCheckComplete: $authCheckComplete}';
}