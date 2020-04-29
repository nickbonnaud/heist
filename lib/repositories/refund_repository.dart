import 'package:heist/models/date_range.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/providers/refund_provider.dart';
import 'package:meta/meta.dart';

class RefundRepository {
  final RefundProvider _refundProvider = RefundProvider();

  Future<PaginateDataHolder> fetchAll({@required int nextPage}) async {
    final PaginatedApiResponse response = await _refundProvider.fetch(query: "page=$nextPage");
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return _handleError(response.error);
  }

  Future<PaginateDataHolder> fetchDateRange({@required int nextPage, @required DateRange dateRange}) async {
    final String startDate = Uri.encodeQueryComponent(dateRange.startDate.toIso8601String());
    final String endDate = Uri.encodeQueryComponent(dateRange.endDate.toIso8601String());
    final String query = "date[]=$startDate&date[]=$endDate";
    final PaginatedApiResponse response = await _refundProvider.fetch(query: '$query&page=$nextPage');
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return _handleError(response.error);
  }

  Future<PaginateDataHolder> fetchByBusiness({@required int nextPage, @required String identifier}) async {
    final String query = 'business=$identifier';
    final PaginatedApiResponse response = await _refundProvider.fetch(query: '$query&page=$nextPage');
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return _handleError(response.error);
  }

  Future<PaginateDataHolder> fetchByIdentifier({@required int nextPage, @required String identifier}) async {
    final String query = 'id=$identifier';
    final PaginatedApiResponse response = await _refundProvider.fetch(query: '$query&page=$nextPage');
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return _handleError(response.error);
  }

  Future<PaginateDataHolder> fetchByTransactionIdentifier({@required int nextPage, @required String identifier}) async {
    final String query = 'transactionId=$identifier';
    final PaginatedApiResponse response = await _refundProvider.fetch(query: '$query&page=$nextPage');
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return _handleError(response.error);
  }

  Future<PaginateDataHolder> fetchByStatus({@required int nextPage, @required int code}) async {
    final String query = 'status=$code';
    final PaginatedApiResponse response = await _refundProvider.fetch(query: '$query&page=$nextPage');
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return _handleError(response.error);
  }
  
  PaginateDataHolder _handleSuccess(PaginatedApiResponse response) {
    final rawData = response.body as List;
    List<RefundResource> data = rawData.map((rawRefund) {
      return RefundResource.fromJson(rawRefund);
    }).toList();
    return PaginateDataHolder(data: data, nextPage: response.nextPage);
  }

  PaginateDataHolder _handleError(String error) {
    return PaginateDataHolder(data: [RefundResource.withError(error)].toList(), nextPage: null);
  }
}