import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/refund_provider.dart';

void main() {
  group("Refund Provider Tests", () {
    late RefundProvider refundProvider;

    setUp(() {
      refundProvider = RefundProvider();
    });

    test("Fetching Refunds returns PaginatedApiResponse", () async {
      var response = await refundProvider.fetch();
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Refund Provider can fetch refunds by query", () async {
      var response = await refundProvider.fetch(query: "?business=identifier");
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Refund Provider can paginate data", () async {
      var response = await refundProvider.fetch(paginateUrl: "http://novapay.ai/api/customer/refund?business=identifier&page=2");
      expect(response, isA<PaginatedApiResponse>());
    });
  });
}