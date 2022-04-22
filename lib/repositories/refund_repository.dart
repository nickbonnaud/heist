import 'package:flutter/material.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/providers/refund_provider.dart';
import 'package:heist/repositories/base_repository.dart';

@immutable
class RefundRepository extends BaseRepository {
  final RefundProvider? _refundProvider;

  const RefundRepository({RefundProvider? refundProvider})
    : _refundProvider = refundProvider;

  Future<PaginateDataHolder> fetchAll({DateTimeRange? dateRange}) async {
    RefundProvider refundProvider = _getRefundProvider();
    
    String query = formatDateQuery(dateRange: dateRange);
    query = query.isNotEmpty ? query.replaceFirst("&", "?") : "";

    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByBusiness({required String identifier}) async {
    RefundProvider refundProvider = _getRefundProvider();
    String query = formatQuery(baseQuery: 'business=$identifier');
    
    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByIdentifier({required String identifier}) async {
    RefundProvider refundProvider = _getRefundProvider();
    String query = formatQuery(baseQuery: 'id=$identifier');

    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByTransactionIdentifier({required String identifier}) async {
    RefundProvider refundProvider = _getRefundProvider();
    String query = formatQuery(baseQuery: 'transactionId=$identifier');

    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByStatus({required int code}) async {
    RefundProvider refundProvider = _getRefundProvider();
    String query = formatQuery(baseQuery: 'status=$code');

    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }
  
  Future<PaginateDataHolder> paginate({required String url}) async {
    RefundProvider refundProvider = _getRefundProvider();

    PaginateDataHolder holder = await sendPaginated(request: refundProvider.fetch(paginateUrl: url));
    return deserialize(holder: holder);
  }

  RefundProvider _getRefundProvider() {
    return _refundProvider ?? const RefundProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((refund) => RefundResource.fromJson(json: refund)).toList()
    );
  }
}