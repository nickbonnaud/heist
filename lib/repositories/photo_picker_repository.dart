import 'package:flutter/material.dart';
import 'package:heist/providers/photo_picker_provider.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class PhotoPickerRepository {
  final PhotoPickerProvider _photoPickerProvider = const PhotoPickerProvider();

  const PhotoPickerRepository();

  Future<XFile?> pickPhoto() async {
    return await _photoPickerProvider.pickPhoto();
  }

  Future<XFile?> takePhoto() async {
    return await _photoPickerProvider.takePhoto();
  }
}