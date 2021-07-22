import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class PhotoPickerProvder {
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> pickPhoto() async {
    return await _imagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> takePhoto() async {
    return await _imagePicker.pickImage(source: ImageSource.camera);
  }
}