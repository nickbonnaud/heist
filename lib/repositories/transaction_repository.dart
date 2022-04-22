import 'package:flutter/material.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/providers/transaction_provider.dart';
import 'package:heist/repositories/base_repository.dart';

@immutable
class TransactionRepository extends BaseRepository {
  final TransactionProvider? _transactionProvider;

  const TransactionRepository({TransactionProvider? transactionProvider})
    : _transactionProvider = transactionProvider;

  Future<PaginateDataHolder> fetchHistoric() async {
    TransactionProvider transactionProvider = _getTransactionProvider();
    String query = formatQuery(baseQuery: 'status=200');

    PaginateDataHolder holder = await sendPaginated(request: transactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchDateRange({required DateTimeRange dateRange}) async {
    TransactionProvider transactionProvider = _getTransactionProvider();
    String query = formatDateQuery(dateRange: dateRange);

    PaginateDataHolder holder = await sendPaginated(request: transactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByBusiness({required String identifier}) async {
    TransactionProvider transactionProvider = _getTransactionProvider();
    String query = formatQuery(baseQuery: 'business=$identifier');

    PaginateDataHolder holder = await sendPaginated(request: transactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByIdentifier({required String identifier}) async {
    TransactionProvider transactionProvider = _getTransactionProvider();
    String query = formatQuery(baseQuery: 'id=$identifier');

    PaginateDataHolder holder = await sendPaginated(request: transactionProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<List<TransactionResource>> fetchOpen() async {
    TransactionProvider transactionProvider = _getTransactionProvider();
    String query = formatQuery(baseQuery: 'open=true');

    PaginateDataHolder holder = await sendPaginated(request: transactionProvider.fetch(query: query));
    holder = deserialize(holder: holder);
    return holder.data as List<TransactionResource>;
  }

  Future<PaginateDataHolder> paginate({required String url}) async {
    TransactionProvider transactionProvider = _getTransactionProvider();

    PaginateDataHolder holder = await sendPaginated(request: transactionProvider.fetch(paginateUrl: url));
    return deserialize(holder: holder);
  }

  Future<List<UnassignedTransactionResource>> fetchUnassigned({required String businessIdentifier}) async {
    TransactionProvider transactionProvider = _getTransactionProvider();

    PaginateDataHolder holder = await sendPaginated(request: transactionProvider.fetchUnassigned(businessIdentifier: businessIdentifier));
    return holder.data.map((transaction) => UnassignedTransactionResource.fromJson(json: transaction)).toList();
  }

  Future<TransactionResource> claimUnassigned({required String transactionId}) async {
    TransactionProvider transactionProvider = _getTransactionProvider();

    Map<String, dynamic> json = await send(request: transactionProvider.patchUnassigned(transactionId: transactionId));
    return deserialize(json: json);
  }

  Future<TransactionResource> approveTransaction({required String transactionId}) async {
    TransactionProvider transactionProvider = _getTransactionProvider();
    Map<String, dynamic> body = {'status_code': 104};
    
    Map<String, dynamic> json = await send(request: transactionProvider.patchStatus(body: body, transactionId: transactionId));
    return deserialize(json: json);
  }

  Future<TransactionResource> keepBillOpen({required String transactionId}) async {
    TransactionProvider transactionProvider = _getTransactionProvider();
    Map<String, dynamic> body = {'status_code': 106};

    Map<String, dynamic> json = await send(request: transactionProvider.patchStatus(body: body, transactionId: transactionId));
    return deserialize(json: json);
  }

  TransactionProvider _getTransactionProvider() {
    return _transactionProvider ?? const TransactionProvider();
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