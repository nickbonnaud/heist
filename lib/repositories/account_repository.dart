import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/account_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:meta/meta.dart';

@immutable
class AccountRepository extends BaseRepository {
  final AccountProvider _accountProvider;

  AccountRepository({required AccountProvider accountProvider})
    : _accountProvider = accountProvider;
  
  Future<Customer> update({required String accountIdentifier, int? tipRate, int? quickTipRate, String? primary}) async {
    Map<String, dynamic> body = {};
    if (tipRate != null) {
      body.addAll({'tip_rate': tipRate});
    }
    if (quickTipRate != null) {
      body.addAll({'quick_tip_rate': quickTipRate});
    }
    if (primary != null) {
      body.addAll({'primary': primary});
    }

    final Map<String, dynamic> json = await this.send(request: _accountProvider.update(body: body, accountIdentifier: accountIdentifier));
    return deserialize(json: json);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Customer.fromJson(json: json!);
  }
}