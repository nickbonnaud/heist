import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/transaction_provider.dart';

void main() {
  group("Transaction Provider Tests", () {
    late TransactionProvider transactionProvider;

    setUp(() {
      transactionProvider = const TransactionProvider();
    });

    test("Fetching transactions returns ApiResponse", () async {
      var response = await transactionProvider.fetch();
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Transaction Provider can fetch transactions by query", () async {
      var response = await transactionProvider.fetch(query: '?status=200');
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Transaction Provider can paginate", () async {
      var response = await transactionProvider.fetch(paginateUrl: "http://novapay.ai/api/customer/transaction?status=200&page=2");
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Fetching Unassigned Transactions returns PaginatedApiResponse", () async {
      var response = await transactionProvider.fetchUnassigned(businessIdentifier: "businessIdentifier");
      expect(response, isA<PaginatedApiResponse>());
    });

    test("Updating unassigned returns ApiResponse", () async {
      var response = await transactionProvider.patchUnassigned(transactionId: "transactionId");
      expect(response, isA<ApiResponse>());
    });

    test("Updating status returns ApiResponse", () async {
      var response = await transactionProvider.patchStatus(body: {}, transactionId: "transactionId");
      expect(response, isA<ApiResponse>());
    });
  });
}