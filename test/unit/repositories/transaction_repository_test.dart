import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/providers/transaction_provider.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionProvider extends Mock implements TransactionProvider {}

void main() {
  group("Transaction Repository Tests", () {
    late TransactionRepository transactionRepository;
    late TransactionProvider mockTransactionProvider;
    late TransactionRepository transactionRepositoryWithMock;

    setUp(() {
      transactionRepository = TransactionRepository(transactionProvider: TransactionProvider());
      mockTransactionProvider = MockTransactionProvider();
      transactionRepositoryWithMock = TransactionRepository(transactionProvider: mockTransactionProvider);
    });

    test("Transaction Repository can fetch historic transactions", () async {
      var holder = await transactionRepository.fetchHistoric();
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<TransactionResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on fetch historic transactions fail", () async {
      when(() => mockTransactionProvider.fetch(query: any(named: "query")))
        .thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        transactionRepositoryWithMock.fetchHistoric(),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can fetch by date range", () async {
      var holder = await transactionRepository.fetchDateRange(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()));
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<TransactionResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on fetch date range fail", () async {
      when(() => mockTransactionProvider.fetch(query: any(named: "query")))
        .thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        transactionRepositoryWithMock.fetchDateRange(dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now())),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can fetch by business", () async {
      var holder = await transactionRepository.fetchByBusiness(identifier: "identifier");
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<TransactionResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on fetch business fail", () async {
      when(() => mockTransactionProvider.fetch(query: any(named: "query")))
        .thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        transactionRepositoryWithMock.fetchByBusiness(identifier: "identifier"),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can fetch by transaction identifier", () async {
      var holder = await transactionRepository.fetchByIdentifier(identifier: "identifier");
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<TransactionResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on fetch by transaction identifier fail", () async {
      when(() => mockTransactionProvider.fetch(query: any(named: "query")))
        .thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        transactionRepositoryWithMock.fetchByIdentifier(identifier: "identifier"),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can fetch open transactions", () async {
      var transactions = await transactionRepository.fetchOpen();
      expect(transactions, isA<List<TransactionResource>>());
    });

    test("Transaction Repository throws error on fetch open transactions fail", () async {
      when(() => mockTransactionProvider.fetch(query: any(named: "query")))
        .thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        transactionRepositoryWithMock.fetchOpen(),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can paginate", () async {
      var holder = await transactionRepository.paginate(url: "http://novapay.ai/api/customer/transaction?status=200&page=2");
      expect(holder, isA<PaginateDataHolder>());
      expect(holder.data, isA<List<TransactionResource>>());
      expect(holder.data.isNotEmpty, true);
    });

    test("Transaction Repository throws error on paginate fail", () async {
      when(() => mockTransactionProvider.fetch(paginateUrl: any(named: "paginateUrl")))
        .thenAnswer((_) async => const PaginatedApiResponse(body: [], isOK: false));

      expect(
        transactionRepositoryWithMock.paginate(url: "http://novapay.ai/api/customer/transaction?status=200&page=2"),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can claim unassigned", () async {
      var transaction = await transactionRepository.claimUnassigned(transactionId: "transactionId");
      expect(transaction, isA<TransactionResource>());
    });

    test("Transaction Repository throws error on claim unassigned fail", () async {
      when(() => mockTransactionProvider.patchUnassigned(transactionId: any(named: "transactionId")))
        .thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        transactionRepositoryWithMock.claimUnassigned(transactionId: "transactionId"),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can approve a transaction", () async {
      var transaction = await transactionRepository.approveTransaction(transactionId: "transactionId");
      expect(transaction, isA<TransactionResource>());
    });

    test("Transaction Repository throws error on approve transaction fail", () async {
      when(() => mockTransactionProvider.patchStatus(body: any(named: "body"), transactionId: any(named: "transactionId")))
        .thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        transactionRepositoryWithMock.approveTransaction(transactionId: "transactionId"),
        throwsA(isA<ApiException>())
      );
    });

    test("Transaction Repository can keep bill open", () async {
      var transaction = await transactionRepository.keepBillOpen(transactionId: "transactionId");
      expect(transaction, isA<TransactionResource>());
    });

    test("Transaction Repository throws error on keep bill open fail", () async {
      when(() => mockTransactionProvider.patchStatus(body: any(named: "body"), transactionId: any(named: "transactionId")))
        .thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        transactionRepositoryWithMock.keepBillOpen(transactionId: "transactionId"),
        throwsA(isA<ApiException>())
      );
    });
  });
}