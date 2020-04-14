import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/providers/transaction_provider.dart';

class TransactionRepository {
  final TransactionProvider _transactionProvider = TransactionProvider();

  Future<PaginateDataHolder> fetchPaid(int nextPage) async {
    final PaginatedApiResponse response = await _transactionProvider.fetch(query: 'status=200&page=$nextPage');
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