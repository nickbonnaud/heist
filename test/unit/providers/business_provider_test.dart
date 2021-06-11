import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/business_provider.dart';

void main() {
  group("Business Provider Tests", () {
    late BusinessProvider businessProvider;

    setUp(() {
      businessProvider = BusinessProvider();
    });

    test("Fetching Businesses returns PaginatedApiResponse", () async {
      var response = await businessProvider.fetch();
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Business Provider can fetch by query", () async {
      var response = await businessProvider.fetch(query: 'name=acme');
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Business Provider can paginate", () async {
      var response = await businessProvider.fetch(paginateUrl: 'http://novapay.ai/api/customer/business?page=2');
      expect(response, isA<PaginatedApiResponse>());
    });
  });
}