import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/account.dart';
import 'package:heist/providers/account_provider.dart';
import 'package:meta/meta.dart';

class AccountRepository {
  final AccountProvider _accountProvider = AccountProvider();

  Future<Account> update({@required String accountIdentifier, @required int tipRate, @required int quickTipRate, String primary}) async {
    Map body = {};
    if (tipRate != null) {
      body.addAll({'tip_rate': tipRate});
    }
    if (quickTipRate != null) {
      body.addAll({'quick_tip_rate': quickTipRate});
    }
    if (primary != null) {
      body.addAll({'primary': primary});
    }

    final ApiResponse response = await _accountProvider.update(body: body, accountIdentifier: accountIdentifier);
    if (response.isOK) {
      return Account.fromJson(response.body);
    }
    return Account.withError(response.error);
  }
}