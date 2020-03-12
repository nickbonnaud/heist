import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PhotoPickerProvder {

  Future<File> pickPhoto() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<File> takePhoto() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }
}