import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/customer_provider.dart';
import 'package:heist/repositories/token_repository.dart';
import 'package:meta/meta.dart';

class CustomerRepository {
  final CustomerProvider _customerProvider = CustomerProvider();
  final TokenRepository _tokenRepository = TokenRepository();
  
  Future<Customer> register({@required String email, @required String password, @required String passwordConfirmation}) async {
    final ApiResponse registerResponse =  await _customerProvider.register(email: email, password: password, passwordConfirmation: passwordConfirmation);
    if (registerResponse.isOK) {
      return _handleSuccess(registerResponse);
    }
    return Customer.withError(registerResponse.error);
  }

  Future<Customer> login({@required String email, @required String password}) async {
    final ApiResponse loginResponse =  await _customerProvider.login(email: email, password: password);
    if (loginResponse.isOK) {
      return _handleSuccess(loginResponse);
    }
    return Customer.withError(loginResponse.error);
  }

  Future<bool> logout() async {
    final ApiResponse logoutResponse = await _customerProvider.logout();
    if (logoutResponse.isOK) {
      _tokenRepository.deleteToken();
    }
    return logoutResponse.isOK;
  }

  Future<bool> requestPassword({@required String email}) async {
    final ApiResponse requestPasswordResponse = await _customerProvider.requestPassword(email: email);
    if (requestPasswordResponse.isOK) {
      return requestPasswordResponse.body;
    }
    return requestPasswordResponse.isOK;
  }

  Future<bool> isSignedIn() async {
    return await _tokenRepository.hasValidToken();
  }
  
  Future<Customer> fetchCustomer() async {
    final ApiResponse response = await _customerProvider.getCustomer();
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return Customer.withError(response.error);
  }

  Future<Customer> updateCustomer(String email, String customerId) async {
    final ApiResponse updateResponse = await _customerProvider.updateCustomer(email, customerId);
    if (updateResponse.isOK) {
      return Customer.fromJson(updateResponse.body);
    }
    return Customer.withError(updateResponse.error);
  }

  Customer _handleSuccess(ApiResponse response) {
    // _tokenRepository.saveToken(Token.fromJson(response.body));
    return Customer.fromJson(response.body);
  }
}