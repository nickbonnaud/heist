import 'package:flutter/material.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/providers/photo_provider.dart';
import 'package:heist/repositories/base_repository.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class PhotoRepository extends BaseRepository {
  final PhotoProvider? _photoProvider;

  const PhotoRepository({PhotoProvider? photoProvider})
    : _photoProvider = photoProvider;

  Future<Customer> upload({required XFile photo, required String profileIdentifier}) async {
    PhotoProvider photoProvider = _getPhotoProvider();
    Map<String, dynamic> body = {'avatar': photo};

    Map<String, dynamic> json = await send(request: photoProvider.upload(body: body, profileIdentifier: profileIdentifier));
    return deserialize(json: json);
  }

  PhotoProvider _getPhotoProvider() {
    return _photoProvider ?? const PhotoProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Customer.fromJson(json: json!);
  }
}