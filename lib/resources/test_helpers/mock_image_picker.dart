import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_picker/image_picker.dart';

class MockImagePicker {

  Future<XFile> init() async {
    ByteData data = await rootBundle.load('assets/profile_customer.png');
    Uint8List bytes = data.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/tmp.tmp').writeAsBytes(bytes);
    return XFile(file.path);
  }
}