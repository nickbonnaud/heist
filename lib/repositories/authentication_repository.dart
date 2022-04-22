import 'package:flutter/material.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/authentication_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:heist/repositories/token_repository.dart';

@immutable
class AuthenticationRepository extends BaseRepository {
  final TokenRepository? _tokenRepository;
  final AuthenticationProvider? _authenticationProvider;
  
  const AuthenticationRepository({TokenRepository? tokenRepository, AuthenticationProvider? authenticationProvider})
    : _tokenRepository = tokenRepository,
      _authenticationProvider = authenticationProvider;
  
  Future<Customer> register({required String email, required String password, required String passwordConfirmation}) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    AuthenticationProvider authenticationProvider = _getAuthenticationProvider();
    Map<String, dynamic> json = await send(request: authenticationProvider.register(body: body));
    return deserialize(json: json);
  }

  Future<Customer> login({required String email, required String password}) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    AuthenticationProvider authenticationProvider = _getAuthenticationProvider();
    Map<String, dynamic> json = await send(request: authenticationProvider.login(body: body));
    return deserialize(json: json);
  }

  Future<bool> logout() async {
    AuthenticationProvider authenticationProvider = _getAuthenticationProvider();
    TokenRepository tokenRepository = _getTokenRepository();

    return send(request: authenticationProvider.logout())
      .then((json) async {
        await tokenRepository.deleteToken();
        return true;
      });
  }

  Future<bool> checkPassword({required String password}) async {
    AuthenticationProvider authenticationProvider = _getAuthenticationProvider();
    Map<String, dynamic> body = {"password": password};

    return send(request: authenticationProvider.checkPassword(body: body))
      .then((json) => json['password_verified']);
  }

  Future<bool> requestPasswordReset({required String email}) async {
    AuthenticationProvider authenticationProvider = _getAuthenticationProvider();
    Map<String, dynamic> body = {"email": email};

    return send(request: authenticationProvider.requestPasswordReset(body: body))
      .then((_) => true);
  }

  Future<bool> resetPassword({required String email, required String resetCode, required String password, required String passwordConfirmation}) async {
    AuthenticationProvider authenticationProvider = _getAuthenticationProvider();
    Map<String, dynamic> body = {
      "email": email,
      "reset_code": resetCode,
      "password": password,
      "password_confirmation": passwordConfirmation
    };
    return send(request: authenticationProvider.resetPassword(body: body))
      .then((_) => true);
  }

  Future<bool> isSignedIn() async {
    TokenRepository tokenRepository = _getTokenRepository();

    return await tokenRepository.hasValidToken();
  }
  
  AuthenticationProvider _getAuthenticationProvider() {
    return _authenticationProvider ?? const AuthenticationProvider();
  }
  
  TokenRepository _getTokenRepository() {
    return _tokenRepository ?? const TokenRepository();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    TokenRepository tokenRepository = _getTokenRepository();
    
    tokenRepository.saveToken(token: Token.fromJson(json: json!));
    return Customer.fromJson(json: json);
  }
}