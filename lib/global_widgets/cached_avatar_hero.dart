import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CachedAvatarHero extends StatelessWidget {
  final String _url;
  final double _radius;
  final String _tag;
  final bool _showLoading;

  const CachedAvatarHero({required String url, required double radius, required String tag, bool showLoading = false, Key? key})
    : _url = url,
      _radius = radius,
      _tag = tag,
      _showLoading = showLoading,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _url,
      imageBuilder: (context, imageProvider) => Hero(
        tag: _tag,
        child: CircleAvatar(
          backgroundImage: imageProvider,
          radius: _radius,
        ),
      ),
      placeholder: (_,__) => Image.memory(kTransparentImage),
      progressIndicatorBuilder: _showLoading 
        ? (_, __, ___) => const CircularProgressIndicator()
        : null,
    );
  }
}