import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/screens/map_screen/helpers/pre_marker.dart';

class IconCreator {
  final Size _size;
  final List<Business> _businesses;

  IconCreator({@required Size size, @required List<Business> businesses})
    : assert(size != null),
      _size = size,
      _businesses = businesses;

  Future<List<PreMarker>> createPreMarkers() async {
    return await Future.wait(_businesses.map((Business business) async {
      BitmapDescriptor icon = await _createMarker(business);
      return PreMarker(
        markerId: business.identifier,
        lat: business.location.geo.lat,
        lng: business.location.geo.lng,
        icon: icon,
        business: business
      );
    }));
  }

  Future<BitmapDescriptor> _createMarker(Business business) async {
    final File markerImageFile = await DefaultCacheManager().getSingleFile(business.photos.logo.smallUrl);
    final Uint8List imageBytes = await markerImageFile.readAsBytes();
    Uint8List marker = await _formatIcon(imageBytes, _size);
    return BitmapDescriptor.fromBytes(marker);
  }

  Future<Uint8List> _formatIcon(Uint8List imageBytes, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          0.0, 
          0.0, 
          size.width, 
          size.height
        ),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius
      ),
      shadowPaint
    );

    // Add border circle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          shadowWidth,
          shadowWidth,
          size.width - (shadowWidth * 2),
          size.height - (shadowWidth * 2)
        ),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius
      ),
      borderPaint
    );

    // Oval for the image
    Rect oval = Rect.fromLTWH(
      imageOffset,
      imageOffset,
      size.width - (imageOffset * 2),
      size.height - (imageOffset * 2)
    );

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add Image
    ui.Image image = await decodeImageFromList(imageBytes);
    paintImage(canvas: canvas, rect: oval, image: image, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
      size.width.toInt(), 
      size.height.toInt()
    );

    // Convert image to bytes
    final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }
}