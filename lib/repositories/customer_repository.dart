import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/customer_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:heist/repositories/token_repository.dart';
import 'package:meta/meta.dart';

@immutable
class CustomerRepository extends BaseRepository {
  final CustomerProvider? _customerProvider;
  final TokenRepository? _tokenRepository;

  const CustomerRepository({CustomerProvider? customerProvider, TokenRepository? tokenRepository})
    : _customerProvider = customerProvider,
      _tokenRepository = tokenRepository;
  
  Future<Customer> fetchCustomer() async {
    CustomerProvider customerProvider = _getCustomerProvider();

    Map<String, dynamic> json = await send(request: customerProvider.fetchCustomer());
    return deserialize(json: json);
  }

  Future<Customer> updateEmail({required String email, required String customerId}) async {
    CustomerProvider customerProvider = _getCustomerProvider();
    Map<String, dynamic> body = {'email': email};
    
    Map<String, dynamic> json = await send(request: customerProvider.updateEmail(body: body, customerId: customerId));
    return Customer.fromJson(json: json);
  }

  Future<Customer> updatePassword({required String oldPassword, required String password, required String passwordConfirmation, required String customerId}) async {
    CustomerProvider customerProvider = _getCustomerProvider();
    Map<String, dynamic> body = {
      'old_password': oldPassword,
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    Map<String, dynamic> json = await send(request: customerProvider.updatePassword(body: body, customerId: customerId));
    return Customer.fromJson(json: json);
  }

  CustomerProvider _getCustomerProvider() {
    return _customerProvider ?? const CustomerProvider();
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