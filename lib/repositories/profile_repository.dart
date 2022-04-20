import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/profile_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:meta/meta.dart';

@immutable
class ProfileRepository extends BaseRepository {
  final ProfileProvider _profileProvider;

  ProfileRepository({required ProfileProvider profileProvider})
    : _profileProvider = profileProvider;

  Future<Customer> store({required String firstName, required String lastName}) async {
    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName
    };

    Map<String, dynamic> json = await send(request: _profileProvider.store(body: body));
    return deserialize(json: json);
  }

  Future<Customer> update({required String firstName, required String lastName, required String profileIdentifier}) async {
    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName
    };

    Map<String, dynamic> json = await send(request: _profileProvider.update(body: body, profileIdentifier: profileIdentifier));
    return deserialize(json: json);
  }

  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Customer.fromJson(json: json!);
  }
}