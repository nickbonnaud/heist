import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class PhotoPickerProvder {
  final ImagePicker _imagePicker = ImagePicker();

  Future<PickedFile?> pickPhoto() async {
    return await _imagePicker.getImage(source: ImageSource.gallery);
  }

  Future<PickedFile?> takePhoto() async {
    return await _imagePicker.getImage(source: ImageSource.camera);
  }
}