import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/providers/icon_creator_provider.dart';
import 'package:heist/repositories/icon_creator_repository.dart';
import 'package:heist/screens/home_screen/widgets/home_screen_body/widgets/nearby_businesses_map/models/pre_marker.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';

class MockIconCreatorProvider extends Mock implements IconCreatorProvider {}
class MockBitmapDescriptor extends Mock implements BitmapDescriptor {}
class MockBusiness extends Mock implements Business {}

void main() {
  group("Icon Creator Repository Tests", () {
    late IconCreatorProvider iconCreatorProvider;
    late IconCreatorRepository iconCreatorRepository;
    late MockDataGenerator mockDataGenerator;

    setUp(() {
      registerFallbackValue(const Size(150, 150));
      registerFallbackValue(MockBusiness());

      iconCreatorProvider = MockIconCreatorProvider();
      when(() => iconCreatorProvider.createMarkers(size: any(named: "size"), business: any(named: 'business')))
        .thenAnswer((_) async => MockBitmapDescriptor());

      iconCreatorRepository = IconCreatorRepository(iconCreatorProvider: iconCreatorProvider);
      mockDataGenerator = MockDataGenerator();
    });

    test("Icon Creator Repository creates a List of PreMarkers", () async {
      int numberBusinesses = 5;
      final List<Business> businesses = List.generate(numberBusinesses, (index) => mockDataGenerator.createBusiness());

      var preMarkers = await iconCreatorRepository.createPreMarkers(businesses: businesses, size: const Size(150, 150));
      expect(preMarkers, isA<List<PreMarker>>());
      expect(preMarkers.length, numberBusinesses);
    });
  });
}