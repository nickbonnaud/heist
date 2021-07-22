import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoPickerInterceptor {

  void init()  {

    const MethodChannel channel = MethodChannel('plugins.flutter.io/image_picker');

    channel.setMockMethodCallHandler((call) async {
      ByteData data = await rootBundle.load('assets/profile_customer.png');
      Uint8List bytes = data.buffer.asUint8List();
      Directory tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/tmp.tmp').writeAsBytes(bytes);
      return file.path;
    });
  }
}