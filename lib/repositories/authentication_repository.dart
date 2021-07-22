import 'package:flutter/material.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/authentication_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:heist/repositories/token_repository.dart';

@immutable
class AuthenticationRepository extends BaseRepository {
  final TokenRepository _tokenRepository;
  final AuthenticationProvider _authenticationProvider;
  
  
  AuthenticationRepository({required TokenRepository tokenRepository, required AuthenticationProvider authenticationProvider})
    : _tokenRepository = tokenRepository,
      _authenticationProvider = authenticationProvider;
  
  Future<Customer> register({required String email, required String password, required String passwordConfirmation}) async {
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    final Map<String, dynamic> json = await this.send(request: _authenticationProvider.register(body: body));
    return deserialize(json: json);
  }

  Future<Customer> login({required String email, required String password}) async {
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    final Map<String, dynamic> json = await this.send(request: _authenticationProvider.login(body: body));
    return deserialize(json: json);
  }

  Future<bool> logout() async {
    return this.send(request: _authenticationProvider.logout())
      .then((json) async {
        await _tokenRepository.deleteToken();
        return true;
      });
  }

  Future<bool> checkPassword({required String password}) async {
    final Map<String, dynamic> body = {"password": password};

    return this.send(request: _authenticationProvider.checkPassword(body: body))
      .then((json) => json['password_verified']);
  }

  Future<bool> requestPasswordReset({required String email}) async {
    final Map<String, dynamic> body = {"email": email};

    return this.send(request: _authenticationProvider.requestPasswordReset(body: body))
      .then((_) => true);
  }

  Future<bool> resetPassword({required String email, required String resetCode, required String password, required String passwordConfirmation}) async {
    final Map<String, dynamic> body = {
      "email": email,
      "reset_code": resetCode,
      "password": password,
      "password_confirmation": passwordConfirmation
    };
    return this.send(request: _authenticationProvider.resetPassword(body: body))
      .then((_) => true);
  }

  Future<bool> isSignedIn() async {
    return await _tokenRepository.hasValidToken();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    _tokenRepository.saveToken(token: Token.fromJson(json: json!));
    return Customer.fromJson(json: json);
  }
}