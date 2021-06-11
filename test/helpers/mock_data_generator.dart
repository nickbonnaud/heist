import 'package:heist/models/business/business.dart';
import 'package:heist/resources/http/mock_responses.dart';

class MockDataGenerator {

  Business createBusiness() {
    return Business.fromJson(json: MockResponses.generateBusiness());
  }
}