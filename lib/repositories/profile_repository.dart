import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/profile_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:meta/meta.dart';

@immutable
class ProfileRepository extends BaseRepository {
  final ProfileProvider? _profileProvider;

  const ProfileRepository({ProfileProvider? profileProvider})
    : _profileProvider = profileProvider;

  Future<Customer> store({required String firstName, required String lastName}) async {
    ProfileProvider profileProvider = _getProfileProvider();
    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName
    };

    Map<String, dynamic> json = await send(request: profileProvider.store(body: body));
    return deserialize(json: json);
  }

  Future<Customer> update({required String firstName, required String lastName, required String profileIdentifier}) async {
    ProfileProvider profileProvider = _getProfileProvider();
    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName
    };

    Map<String, dynamic> json = await send(request: profileProvider.update(body: body, profileIdentifier: profileIdentifier));
    return deserialize(json: json);
  }

  ProfileProvider _getProfileProvider() {
    return _profileProvider ?? const ProfileProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Customer.fromJson(json: json!);
  }
}