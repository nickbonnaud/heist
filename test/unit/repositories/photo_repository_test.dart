import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/providers/photo_provider.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockPhotoProvider extends Mock implements PhotoProvider {}

void main() {
  group("Photo Repository Tests", () {
    late PhotoRepository photoRepository;
    late PhotoProvider mockPhotoProvider;
    late PhotoRepository photoRepositoryWithMock;

    setUp(() {
      photoRepository = const PhotoRepository();
      mockPhotoProvider = MockPhotoProvider();
      photoRepositoryWithMock = PhotoRepository(photoProvider: mockPhotoProvider);
    });

    test("Photo Repository can upload photo", () async {
      var customer = await photoRepository.upload(photo: XFile("path"), profileIdentifier: "profileIdentifier");
      expect(customer, isA<Customer>());
    });

    test("Photo Repository throws error on upload photo fail", () async {
      when(() => mockPhotoProvider.upload(body: any(named: "body"), profileIdentifier: any(named: "profileIdentifier")))
        .thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        photoRepositoryWithMock.upload(photo: XFile("path"), profileIdentifier: "profileIdentifier"),
        throwsA(isA<ApiException>())
      );
    });
  });
}