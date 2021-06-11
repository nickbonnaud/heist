import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/routing/route_data.dart';

void main() {
  group("Route Data Tests", () {

    test("RouteData [] operator returns value of query parameters if exists, else empty string", () {
      final Map<String, String> queryParams = { "query": "params" };
      
      RouteData routeData = RouteData(route: "fake", queryParameters: queryParams);
      expect(routeData['query'], queryParams["query"]);

      routeData = RouteData(route: "fake");
      expect(routeData['query'], "");
    });

    test("RouteData can receive args", () {
      final Profile profile = Profile.empty();
      
      RouteData routeData = RouteData(route: "fake", args: profile);
      expect(routeData.args, isA<Profile>());
    });

    test("RouteData factory can create RouteData", () {
      final RouteSettings settings = RouteSettings(name: "fake?query=params" );
      final RouteData routeData = RouteData.init(settings: settings);
      expect(routeData.route, Uri.parse(settings.name!).path);
      expect(routeData['query'], Uri.parse(settings.name!).queryParameters['query']);
    });

    test("RouteData factory returns home route if settings name is null", () {
      final RouteSettings settings = RouteSettings();
      final RouteData routeData = RouteData.init(settings: settings);
      expect(routeData.route, "/");
    });
  });
}