import 'package:flutter/material.dart';

@immutable
class RouteData {
  final String route;
  final Map<String, String>? _queryParameters;
  final Object? args;

  const RouteData({required this.route, Map<String, String>? queryParameters, this.args})
    : _queryParameters = queryParameters;
  
  operator [](String key) => _queryParameters != null
    ? _queryParameters![key]
    : "";

  factory RouteData.init({required RouteSettings settings}) {
    final String? routeName = settings.name;

    if (routeName != null) {
      final Uri uri = Uri.parse(routeName);
      return RouteData(
        route: uri.path,
        queryParameters: Uri.parse(routeName).queryParameters,
        args: settings.arguments
      );
    }

    return const RouteData(route: "/");
  }

  @override
  String toString() => 'RouteData { route: $route, queryParams: $_queryParameters, args: $args }';
}