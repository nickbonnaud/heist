import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';

class FadeInFile extends StatefulWidget {
  final File _imageFile;
  final double _size;

  FadeInFile({@required File imageFile, double size = 25})
    : assert(imageFile != null),
      _imageFile = imageFile,
      _size = size;

  @override
  State<FadeInFile> createState() => _FadeInFileState();
}

class _FadeInFileState extends State<FadeInFile> with SingleTickerProviderStateMixin {
  AnimationController _controller;

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
        backgroundImage: Image.file(widget._imageFile).image,
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