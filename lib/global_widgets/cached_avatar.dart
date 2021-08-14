import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:transparent_image/transparent_image.dart';

class CachedAvatar extends StatelessWidget {
  final String _url;
  final int _radius;

  CachedAvatar({required String url, required int radius})
    : _url = url,
      _radius = radius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _url,
      imageBuilder: (_, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: SizeConfig.getWidth(_radius.toDouble()),
      ),
      placeholder: (_,__) => Image.memory(kTransparentImage),
      // progressIndicatorBuilder: (_, __, ___) => _showLoading
      //   ? CircularProgressIndicator()
      //   : Container(),
    );
  }
}