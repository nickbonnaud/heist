import 'package:flutter/material.dart';
import 'package:heist/providers/photo_picker_provider.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class PhotoPickerRepository {
  final PhotoPickerProvder _photoPickerProvder;

  const PhotoPickerRepository({required PhotoPickerProvder photoPickerProvder})
    : _photoPickerProvder = photoPickerProvder;

  Future<PickedFile?> pickPhoto() async {
    return await _photoPickerProvder.pickPhoto();
  }

  Future<PickedFile?> takePhoto() async {
    return await _photoPickerProvder.takePhoto();
  }
}