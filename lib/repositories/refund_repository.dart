import 'package:flutter/material.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/providers/refund_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:meta/meta.dart';

@immutable
class RefundRepository extends BaseRepository {
  final RefundProvider _refundProvider;

  RefundRepository({required RefundProvider refundProvider})
    : _refundProvider = refundProvider;

  Future<PaginateDataHolder> fetchAll({DateTimeRange? dateRange}) async {
    String query = this.formatDateQuery(dateRange: dateRange);
    query = query.isNotEmpty ? query.replaceFirst("&", "?") : "";

    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByBusiness({required String identifier}) async {
    final String query = this.formatQuery(baseQuery: 'business=$identifier');
    
    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByIdentifier({required String identifier}) async {
    final String query = this.formatQuery(baseQuery: 'id=$identifier');

    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByTransactionIdentifier({required String identifier}) async {
    final String query = this.formatQuery(baseQuery: 'transactionId=$identifier');

    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }

  Future<PaginateDataHolder> fetchByStatus({required int code}) async {
    final String query = this.formatQuery(baseQuery: 'status=$code');

    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetch(query: query));
    return deserialize(holder: holder);
  }
  
  Future<PaginateDataHolder> paginate({required String url}) async {
    final PaginateDataHolder holder = await this.sendPaginated(request: _refundProvider.fetch(paginateUrl: url));
    return deserialize(holder: holder);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return holder!.update(
      data: holder.data.map((refund) => RefundResource.fromJson(json: refund)).toList()
    );
  }
}