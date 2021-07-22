import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:image_picker/image_picker.dart';

class FadeInFile extends StatefulWidget {
  final XFile _imageFile;
  final double _size;

  FadeInFile({required XFile imageFile, double size = 25})
    : _imageFile = imageFile,
      _size = size;

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
        radius: SizeConfig.getWidth(widget._size),
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