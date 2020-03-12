import 'package:equatable/equatable.dart';
import 'package:heist/repositories/token_repository.dart';

class Token extends Equatable {
  final String value;
  final int expiry;

  Token({this.value, this.expiry});

  Token.fromJson(Map<String, dynamic> json)
    : value = json['token'],
      expiry = TokenRepository.getExpiry(json['token']);

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'expiry': expiry
    };
  }

  @override
  List<Object> get props => [value, expiry];

  
}