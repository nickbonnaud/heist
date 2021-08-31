import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FadeInFile extends StatefulWidget {
  final XFile _imageFile;

  FadeInFile({required XFile imageFile})
    : _imageFile = imageFile;

  @override
  State<FadeInFile> createState() => _FadeInFileState();
}

class _FadeInFileState extends State<FadeInFile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800)
    )..forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _controller.value, 
      duration: Duration(milliseconds: 800),
      child: CircleAvatar(
        backgroundImage: Image.file(File(widget._imageFile.path)).image,
        radius: 100.w,
        backgroundColor: Colors.transparent,
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}