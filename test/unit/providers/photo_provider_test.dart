import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/photo_provider.dart';

void main() {
  group("Photo Provider Tests", () {
    late PhotoProvider photoProvider;

    setUp(() {
      photoProvider = const PhotoProvider();
    });

    test("Uploading Photo returns ApiResponse", () async {
      var response = await photoProvider.upload(body: {}, profileIdentifier: "profileIdentifier");
      expect(response, isA<ApiResponse>());
    });
  });
}