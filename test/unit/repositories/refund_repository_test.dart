import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/providers/refund_provider.dart';
import 'package:heist/repositories/refund_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockRefundProvider extends Mock implements RefundProvider {}

void main() {
  group("Refund Repository Tests", () {
    late RefundRepository refundRepository;
    late RefundProvider mockRefundProvider;
    late RefundRepository refundRepositoryWithMock;

    setUp(() {
      refundRepository = const RefundRepository();
      mockRefundProvider = MockRefundProvider();
      refundRepositoryWithMock = RefundRepository(refundProvider: mockRefundProvider);
    });

    test("Refund Repository can fetch all refunds", () async {
      var holder = await refundRepository.fetchAll();
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<RefundResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Refund Repository can fetch all refunds with dateTimeRange", () async {
      var holder = await refundRepository.fetchAll(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()));
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<RefundResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Refund Repository throws error on fetch all refunds fail", () async {
      when(() => mockRefundProvider.fetch()).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        refundRepositoryWithMock.fetchAll(),
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can fetch refunds by business", () async {
      var holder = await refundRepository.fetchByBusiness(identifier: "identifier");
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<RefundResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Refund Repository throws error on fetch refunds by business fail", () async {
      when(() => mockRefundProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        refundRepositoryWithMock.fetchByBusiness(identifier: "identifier"),
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can fetch refunds by identifier", () async {
      var holder = await refundRepository.fetchByIdentifier(identifier: "identifier");
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<RefundResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Refund Repository throws error on fetch refunds by identifier fail", () async {
      when(() => mockRefundProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        refundRepositoryWithMock.fetchByIdentifier(identifier: "identifier"),
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can fetch refunds by transaction identifier", () async {
      var holder = await refundRepository.fetchByTransactionIdentifier(identifier: "identifier");
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<RefundResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Refund Repository throws error on fetch refunds by transaction identifier fail", () async {
      when(() => mockRefundProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        refundRepositoryWithMock.fetchByTransactionIdentifier(identifier: "identifier"),
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can fetch refunds by status", () async {
      var holder = await refundRepository.fetchByStatus(code: 100);
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<RefundResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Refund Repository throws error on fetch refunds by status fail", () async {
      when(() => mockRefundProvider.fetch(query: any(named: "query"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        refundRepositoryWithMock.fetchByStatus(code: 100),
        throwsA(isA<ApiException>())
      );
    });

    test("Refund Repository can paginate", () async {
      var holder = await refundRepository.paginate(url: "http://novapay.ai/api/customer/refund?page=2");
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<RefundResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Refund Repository throws error on paginate fail", () async {
      when(() => mockRefundProvider.fetch(paginateUrl: any(named: "paginateUrl"))).thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        refundRepositoryWithMock.paginate(url: "http://novapay.ai/api/customer/refund?page=2"),
        throwsA(isA<ApiException>())
      );
    });
  });
}