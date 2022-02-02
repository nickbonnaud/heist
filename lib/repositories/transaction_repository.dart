import 'package:flutter/material.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/providers/transaction_provider.dart';
import 'package:heist/repositories/base_repository.dart';

@immutable
class TransactionRepository extends BaseRepository {
  final TransactionProvider _transactionProvider;

  TransactionRepository({required TransactionProvider transactionProvider})
    : _transactionProvider = transactionProvider;

  Future<PaginateDataHolder> fetchHistoric() async {
    final String query = this.formatQuery(baseQuery: 'status=200');

    final PaginateDataHolder holder = await this.sendPaginated(request: _transactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchDateRange({required DateTimeRange dateRange}) async {
    final String query = this.formatDateQuery(dateRange: dateRange);

    final PaginateDataHolder holder = await this.sendPaginated(request: _transactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByBusiness({required String identifier}) async {
    final String query = this.formatQuery(baseQuery: 'business=$identifier');

    final PaginateDataHolder holder = await this.sendPaginated(request: _transactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByIdentifier({required String identifier}) async {
    final String query = this.formatQuery(baseQuery: 'id=$identifier');

    final PaginateDataHolder holder = await this.sendPaginated(request: _transactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<List<TransactionResource>> fetchOpen() async {
    final String query = this.formatQuery(baseQuery: 'open=true');

    PaginateDataHolder holder = await this.sendPaginated(request: _transactionProvider.fetch(query: query));
    holder = deserialize(holder: holder);
    return holder.data as List<TransactionResource>;
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    final PaginateDataHolder holder = await this.sendPaginated(request: _transactionProvider.fetch(paginateUrl: url));
    return deserialize(holder: holder);
  }

  Future<List<UnassignedTransactionResource>> fetchUnassigned({required String businessIdentifier}) async {
    final PaginateDataHolder holder = await this.sendPaginated(request: _transactionProvider.fetchUnassigned(businessIdentifier: businessIdentifier));
    return holder.data.map((transaction) => UnassignedTransactionResource.fromJson(json: transaction)).toList();
  }

  Future<TransactionResource> claimUnassigned({required String transactionId}) async {
    final Map<String, dynamic> json = await this.send(request: _transactionProvider.patchUnassigned(transactionId: transactionId));
    return deserialize(json: json);
  }

  Future<TransactionResource> approveTransaction({required String transactionId}) async {
    final Map<String, dynamic> body = {'status_code': 104};
    
    final Map<String, dynamic> json = await this.send(request: _transactionProvider.patchStatus(body: body, transactionId: transactionId));
    return deserialize(json: json);
  }

  Future<TransactionResource> keepBillOpen({required String transactionId}) async {
    final Map<String, dynamic> body = {'status_code': 106};

    final Map<String, dynamic> json = await this.send(request: _transactionProvider.patchStatus(body: body, transactionId: transactionId));
    return deserialize(json: json);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    if (holder != null) {
      return holder.update(
        data: holder.data.map((transaction) => TransactionResource.fromJson(json: transaction)).toList()
      );
    }

    return TransactionResource.fromJson(json: json!);
  }
}