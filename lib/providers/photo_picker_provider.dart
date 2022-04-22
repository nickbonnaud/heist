import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class PhotoPickerProvider {

  const PhotoPickerProvider();
  
  Future<XFile?> pickPhoto() async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> takePhoto() async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.camera);
  }
}