import 'package:heist/models/api_response.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/providers/business_provider.dart';
import 'package:meta/meta.dart';

class BusinessRepository {
  final BusinessProvider _businessProvider = BusinessProvider();

  Future<List<Business>> fetchByName({@required String name}) async {
    final String query = 'name=$name';
    final ApiResponse response = await _businessProvider.fetch(query: query);
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return [Business.withError((response.error))].toList();
  }

  Future<List<Business>> fetchByIdentifier({@required String identifier}) async {
    final String query = 'id=$identifier';
    final ApiResponse response = await _businessProvider.fetch(query: query);
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return [Business.withError((response.error))].toList();
  }

  Future<List<Business>> fetchByBeaconIdentifier({@required String identifier}) async {
    final String query = 'beacon=$identifier';
    final ApiResponse response = await _businessProvider.fetch(query: query);
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return [Business.withError((response.error))].toList();
  }

  List<Business> _handleSuccess(ApiResponse response) {
    final data = response.body as List;
    return data.map((rawBusiness) {
      return Business.fromJson(rawBusiness);
    }).toList();
  }
}