import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:transparent_image/transparent_image.dart';

class CachedAvatarHero extends StatelessWidget {
  final String _url;
  final int _radius;
  final String _tag;
  final bool _showLoading;

  CachedAvatarHero({@required String url, @required int radius, @required String tag, bool showLoading = false})
    : assert(url != null && radius != null),
      _url = url,
      _radius = radius,
      _tag = tag,
      _showLoading = showLoading;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _url,
      imageBuilder: (context, imageProvider) => Hero(
        tag: _tag,
        child: CircleAvatar(
          backgroundImage: imageProvider,
          radius: SizeConfig.getWidth(_radius.toDouble()),
        ),
      ),
      placeholder: (_,__) => Image.memory(kTransparentImage),
      progressIndicatorBuilder: _showLoading 
        ? (_, __, ___) => CircularProgressIndicator()
        : null,
    );
  }
}