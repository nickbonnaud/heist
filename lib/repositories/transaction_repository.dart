import 'package:heist/models/date_range.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/providers/transaction_provider.dart';
import 'package:meta/meta.dart';

class TransactionRepository {
  final TransactionProvider _transactionProvider = TransactionProvider();

  Future<PaginateDataHolder> fetchHistoric(int nextPage) async {
    final PaginatedApiResponse response = await _transactionProvider.fetch(query: 'status=200&page=$nextPage');
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return PaginateDataHolder(data:[TransactionResource.withError(response.error)].toList(), nextPage: null);
  }

  Future<PaginateDataHolder> fetchDateRange({@required int nextPage, @required DateRange dateRange}) async {
    final String startDate = Uri.encodeQueryComponent(dateRange.startDate.toIso8601String());
    final String endDate = Uri.encodeQueryComponent(dateRange.endDate.toIso8601String());
    final String query = "date[]=$startDate&date[]=$endDate";
    final PaginatedApiResponse response = await _transactionProvider.fetch(query: '$query&page=$nextPage');
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return PaginateDataHolder(data:[TransactionResource.withError(response.error)].toList(), nextPage: null);
  }

  Future<PaginateDataHolder> fetchByBusiness({@required int nextPage, @required String identifier}) async {
    final String query = 'business=$identifier';
    final PaginatedApiResponse response = await _transactionProvider.fetch(query: '$query&page=$nextPage');
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return PaginateDataHolder(data:[TransactionResource.withError(response.error)].toList(), nextPage: null);
  }

  Future<PaginateDataHolder> fetchByIdentifier({@required int nextPage, @required String identifier}) async {
    final String query = 'id=$identifier';
    final PaginatedApiResponse response = await _transactionProvider.fetch(query: '$query&page=$nextPage');
    if (response.isOK) {
      return _handleSuccess(response);
    }
    return PaginateDataHolder(data:[TransactionResource.withError(response.error)].toList(), nextPage: null);
  }

  PaginateDataHolder _handleSuccess(PaginatedApiResponse response) {
    final rawData = response.body as List;
    List<TransactionResource> data = rawData.map((rawTransaction) {
      return TransactionResource.fromJson(rawTransaction);
    }).toList();
    return PaginateDataHolder(data: data, nextPage: response.nextPage);
  }
}