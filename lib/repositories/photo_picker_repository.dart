import 'dart:io';

import 'package:heist/providers/photo_picker_provider.dart';

class PhotoPickerRepository {

  Future<File> pickPhoto() async {
    return await PhotoPickerProvder().pickPhoto();
  }

  Future<File> takePhoto() async {
    return await PhotoPickerProvder().takePhoto();
  }
}