import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';


class CachedAvatar extends StatelessWidget {
  final String _url;
  final double _radius;

  const CachedAvatar({required String url, required double radius, Key? key})
    : _url = url,
      _radius = radius,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _url,
      imageBuilder: (_, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: _radius,
      ),
      placeholder: (_,__) => Image.memory(kTransparentImage),
    );
  }
}